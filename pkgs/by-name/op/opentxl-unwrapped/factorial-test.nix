{
  lib,
  runCommandNoCC,
  opentxl,
}:
runCommandNoCC "opentxl-test"
  {
    nativeBuildInputs = [ opentxl ];
    src = lib.sources.sourceByRegex ./. [
      ".*.txl"
    ];
  }
  ''
    printf '10' > factorial.in
    result=$(txl factorial.in $src/factorial.txl)
    [[ "$result" -eq '3628800' ]] && touch $out
  ''
