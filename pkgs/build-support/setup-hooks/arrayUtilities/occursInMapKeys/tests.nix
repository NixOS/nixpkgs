# NOTE: Tests related to occursInMapKeys go here.
{
  lib,
  occursInMapKeys,
  testers,
}:
let
  inherit (lib.attrsets) recurseIntoAttrs;
  inherit (testers) shellcheck shfmt testEqualArrayOrMap;
  check =
    {
      name,
      valuesArray,
      valuesMap,
      expectedMap,
    }:
    (testEqualArrayOrMap {
      inherit
        name
        valuesArray
        valuesMap
        expectedMap
        ;
      script = ''
        set -eu
        nixLog "running occursInMapKeys with valuesArray and valuesMap to populate actualMap"
        local key
        for key in "''${valuesArray[@]}"; do
          if occursInMapKeys "$key" valuesMap; then
            actualMap[$key]=1
          else
            actualMap[$key]=0
          fi
        done
      '';
    }).overrideAttrs
      (prevAttrs: {
        nativeBuildInputs = prevAttrs.nativeBuildInputs or [ ] ++ [ occursInMapKeys ];
      });
in
recurseIntoAttrs {
  shellcheck = shellcheck {
    name = "occursInMapKeys";
    src = ./occursInMapKeys.bash;
  };

  shfmt = shfmt {
    name = "occursInMapKeys";
    src = ./occursInMapKeys.bash;
  };

  empty = check {
    name = "empty";
    valuesArray = [ ];
    valuesMap = { };
    expectedMap = { };
  };

  singleton = check {
    name = "singleton";
    valuesArray = [ "apple" ];
    valuesMap.apple = "fruit";
    expectedMap.apple = 1;
  };

  singletonNotInMap = check {
    name = "singletonNotInMap";
    valuesArray = [ "apple" ];
    valuesMap.banana = "fruit";
    expectedMap.apple = 0;
  };

  multiple = check {
    name = "multiple";
    valuesArray = [
      "cat"
      "apple"
      "banana"
    ];
    valuesMap = {
      apple = "fruit";
      banana = "fruit";
    };
    expectedMap = {
      apple = 1;
      banana = 1;
      cat = 0;
    };
  };
}
