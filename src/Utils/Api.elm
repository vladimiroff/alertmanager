module Utils.Api exposing (..)

import Json.Decode as Json exposing (field)
import ISO8601
import Types exposing (Msg, Time, ApiResponse(..), ApiData)
import Http


fromResult : Result e a -> ApiResponse e a
fromResult result =
    case result of
        Err e ->
            Failure e

        Ok x ->
            Success x


send : Http.Request a -> Cmd (ApiData a)
send =
    Http.send fromResult


stringtoISO8601 : Json.Decoder ISO8601.Time
stringtoISO8601 =
    Json.string
        |> Json.andThen
            (\val ->
                case ISO8601.fromString val of
                    Err err ->
                        Json.fail err

                    Ok date ->
                        Json.succeed <| date
            )


iso8601Time : String -> Json.Decoder Time
iso8601Time fieldName =
    Json.map3 Types.Time
        (field fieldName stringtoISO8601)
        (field fieldName Json.string)
        (field fieldName <| Json.succeed True)


baseUrl : String
baseUrl =
    "http://alertmanager.int.s-cloud.net/api/v1"



-- "http://localhost:9093/api/v1"
