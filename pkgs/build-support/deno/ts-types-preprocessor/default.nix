{
  stdenvNoCC,
  jq,
  runCommand,
}:
let
  ts-types-json =
    {
      name ? "deno-ts-types-json",
      src,
    }:
    let
      tsTypesSearchTerms = [
        "@ts-types"
        "@deno-types"
      ];
      tsTypessearchString = builtins.concatStringsSep "|" tsTypesSearchTerms;
      referenceTypesSearchString = "[[:space:]]*/// [[:space:]]*<reference [[:space:]]*types[[:space:]]*=";
    in
    stdenvNoCC.mkDerivation {
      inherit name src;
      nativeBuildInputs = [
        jq
      ];
      buildPhase = ''
        grep -r -E '${tsTypessearchString}' . | sed -n -E 's!^.*(${tsTypessearchString})[[:space:]]*=[[:space:]]*"((https?://|npm:|jsr:).*)"$!\2!p' | jq -Rn '[inputs] | unique' > ts-types.json || true;
        grep -r -E '${referenceTypesSearchString}' . | sed -n -E 's!^.*${referenceTypesSearchString}[[:space:]]*"((https?://|npm:|jsr:).*)"[[:space:]]*/>[[:space:]]*$!\1!p' | jq -Rn '[inputs] | unique' > reference-types.json || true;
        jq -r '.compilerOptions.types? // []' < ./deno.json > deno-json-types.json
        jq -s 'add | unique | sort' ts-types.json reference-types.json deno-json-types.json > $out;
      '';
      passthru = { inherit tests; };
    };
  tests = {
    withTsTypes =
      let
        actual = ts-types-json { src = ./tests; };
      in
      runCommand "withTsTypes" { } ''
        diff ${./tests/expected.json} ${actual};
        touch $out;
      '';
  };
in
{
  inherit ts-types-json;
}
