/*
 * Duration manipulation functions.
 */

{ lib }:

with lib;
with builtins;

let

  # Using the definitions of systemd.time(7).
  unitToScale = rec {
    us = 1;
    usec = us;

    ms = 1000 * us;
    msec = ms;

    s = 1000 * ms;
    seconds = s;
    second = s;
    sec = s;

    m = 60 * s;
    minutes = m;
    minute = m;
    min = m;

    h = 60 * m;
    hours = h;
    hour = h;
    hr = h;

    d = 24 * h;
    days = d;
    day = d;

    w = 7 * d;
    weeks = w;
    week = w;

    M = 2630016 * s;            # 30.44 days
    months = M;
    month = M;

    y = 31557600 * s;           # 365.25 days
    years = y;
    year = y;
  };

  parseToNat = str:
    let
      maybeNat = fromJSON str;
    in
      if match "[[:space:]]*[[:digit:]]+" str != null && isInt maybeNat
      then { ok = maybeNat; }
      else { error = "Expected natural number but got \"${str}\"."; };

  parseToScale = str:
      if hasAttr str unitToScale
      then { ok = unitToScale.${str}; }
      else { error = "Expected time unit but got \"${str}\"."; };

  scaleToMillis = magnitudeStr: unitStr:
    let
      maybeMagnitude = parseToNat magnitudeStr;
      maybeScale = parseToScale unitStr;
    in
      if magnitudeStr == "" && unitStr == ""
      then mkDuration 0
      else
        if maybeMagnitude ? ok
        then
          if maybeScale ? ok
          then mkDuration (maybeMagnitude.ok * maybeScale.ok)
          else maybeScale
        else maybeMagnitude;

  parseDuration = str:
    let
      err = msg: { error = "Invalid duration \"${str}\": ${msg}"; };
      lstRaw = split "[[:space:]]*([a-zA-Z]+)[[:space:]]*" str;
      lstParts = partition isString lstRaw;
      magnitudes = lstParts.right;
      units = map (xs: assert length xs == 1; head xs) lstParts.wrong ++ [""];
      lstScaled = zipListsWith scaleToMillis magnitudes units;
      add = acc: dur:
        if acc ? duration
        then
          if dur ? duration
          then mkDuration (acc.duration + dur.duration)
          else err dur.error
        else acc;
    in
      if str == ""
      then err "Cannot be empty string."
      else foldl' add (mkDuration 0) lstScaled;

  # Duration value constructor.
  mkDuration = ms: {
    duration = ms;
    __toString = self:
      let
        mkField = state: unit:
          let
            scale = unitToScale.${unit};
            n = state.remainder / scale;
          in
            {
              fields = state.fields ++ optional (n > 0) (toString n + unit);
              remainder = state.remainder - n * scale;
            };

        zero = { fields = []; remainder = self.duration; };

        result = foldl' mkField zero [ "y" "M" "w" "d" "h" "m" "s" "ms" "us" ];
      in
        toString result.fields;
  };

in

rec {

  # Parses a string representation of a time duration.
  #
  # The accepted syntax is
  #
  #     duration ::= (nat " "* unit " "*)+
  #     nat ::= decimal-digit+
  #     decimal-digit ::= "0" | "1" | … | "9"
  #     unit ::=
  #         "us" | "usec"
  #       | "ms" | "msec"
  #       |  "s" | "seconds" | "second" | "sec"
  #       |  "m" | "minutes" | "minute" | "min"
  #       |  "h" | "hours"   | "hour"   | "hr"
  #       |  "d" | "days"    | "day"
  #       |  "w" | "weeks"   | "week"
  #       |  "M" | "months"  | "month"
  #       |  "y" | "years"   | "year"
  #
  # and is a subset of the format supported by systemd as described in
  # systemd.time(7).
  #
  # The return value is a set of the form
  #
  #     { duration = <duration in microseconds> ; … }
  #
  # on success and
  #
  #     { error = <error message> ; }
  #
  # on failure.
  #
  # Example:
  #
  #     nix-repl> with lib.durations; toUsec (parse "1d")
  #     86400000000
  #
  #     nix-repl> with lib.durations; toUsec (parse "8d 30h 0m 177s 1ms")
  #     799377001000
  #
  #     nix-repl> with lib.durations; parse "1dd"
  #     { error = "Invalid duration \"1dd\": Expected time unit but got \"dd\"."; }
  #
  #     nix-repl> with lib.durations; parse "1h 10"
  #     { error = "Invalid duration \"1h 10\": Expected time unit but got \"\"."; }
  #
  parse = parseDuration;

  # Parses a string representation of a time duration.
  #
  # However, if given an integer as input this function will instead
  # produce a duration of the integer value scaled by the given
  # fallback unit.
  #
  # Example:
  #
  #    nix-repl> with lib.durations; toUsec (parseWithIntFallback "s" "5h")
  #    18000000000
  #
  #    nix-repl> with lib.durations; toUsec (parseWithIntFallback "s" 5) 
  #    5000000
  #
  #    nix-repl> with lib.durations; parseWithIntFallback "y" "foo"
  #    { error = "Invalid duration \"foo\": Expected natural number but got \"\"."; }
  parseWithIntFallback = fallbackUnit: value:
    if isInt value
    then mkDuration (value * unitToScale.${fallbackUnit})
    else parse value;

  # Given a duration returns the number of microseconds as an integer.
  toUsec = d: d.duration;

  # Given a duration returns the number of milliseconds as an integer.
  toMsec = d: d.duration / (0.0 + unitToScale.ms);

  # Given a duration returns the number of seconds as a float.
  toSeconds = d: d.duration / (0.0 + unitToScale.s);

  # Evaluates to 1 if tests pass, otherwise throws an error.
  tests =
    assert parse "" == {
      error = "Invalid duration \"\": Cannot be empty string.";
    };

    assert parse "1" == {
      error = "Invalid duration \"1\": Expected time unit but got \"\".";
    };

    assert parse "d" == {
      error = "Invalid duration \"d\": Expected natural number but got \"\".";
    };

    assert toUsec (parse "1 us") == 1;
    assert toUsec (parse "1 ms") == 1000;
    assert toUsec (parse "5 msec") == 5000;
    assert toUsec (parse "1 s") == 1000000;
    assert toUsec (parse "1 m") == 60000000;
    assert toUsec (parse "1 h") == 3600000000;
    assert toUsec (parse "1 d") == 86400000000;
    assert toUsec (parse "1 w") == 604800000000;
    assert toUsec (parse "1 week") == 604800000000;
    assert toUsec (parse "1 M") == 2630016000000;
    assert toUsec (parse "1 months") == 2630016000000;
    assert toUsec (parse "1 y") == 31557600000000;
    assert toUsec (parse "1 years") == 31557600000000;
    assert toUsec (parse "1 ms 10ms") == 11000;
    assert toUsec (parse "1ms 1s") == 1001000;
    assert toUsec (parse "   8d 30h 0m 177s 1ms ") == 799377001000;

    assert toMsec (parse "500 ms") == 500.0;
    assert toMsec (parse "500s 500ms") == 500500.0;

    assert toSeconds (parse "500 ms") == 0.5;
    assert toSeconds (parse "500s 500ms") == 500.5;

    assert toString (parse "1ms 1s") == "1s 1ms";
    assert toString (parse "8d 30h 0m 177s 1ms") == "1w 2d 6h 2m 57s 1ms";

    1;

}
