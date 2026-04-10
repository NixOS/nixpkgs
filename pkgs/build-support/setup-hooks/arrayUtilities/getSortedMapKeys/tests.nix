# NOTE: Tests related to getSortedMapKeys go here.
{
  getSortedMapKeys,
  lib,
  testers,
}:
let
  inherit (lib.attrsets) recurseIntoAttrs;
  inherit (testers) shellcheck shfmt testEqualArrayOrMap;

  check =
    {
      name,
      valuesMap,
      expectedArray,
    }:
    (testEqualArrayOrMap {
      inherit name valuesMap expectedArray;
      script = ''
        set -eu
        nixLog "running getSortedMapKeys with valuesMap to populate actualArray"
        getSortedMapKeys valuesMap actualArray
      '';
    }).overrideAttrs
      (prevAttrs: {
        nativeBuildInputs = prevAttrs.nativeBuildInputs or [ ] ++ [ getSortedMapKeys ];
      });
in
recurseIntoAttrs {
  shellcheck = shellcheck {
    name = "getSortedMapKeys";
    src = ./getSortedMapKeys.bash;
  };

  shfmt = shfmt {
    name = "getSortedMapKeys";
    src = ./getSortedMapKeys.bash;
  };

  empty = check {
    name = "empty";
    valuesMap = { };
    expectedArray = [ ];
  };

  singleton = check {
    name = "singleton";
    valuesMap = {
      "apple" = "fruit";
    };
    expectedArray = [ "apple" ];
  };

  keysAreSorted = check {
    name = "keysAreSorted";
    valuesMap = {
      "apple" = "fruit";
      "bee" = "insect";
      "carrot" = "vegetable";
    };
    expectedArray = [
      "apple"
      "bee"
      "carrot"
    ];
  };

  # NOTE: While keys can be whitespace, they cannot be null (empty).
  keysCanBeWhitespace = check {
    name = "keysCanBeWhitespace";
    valuesMap = {
      " " = 1;
      "  " = 2;
    };
    expectedArray = [
      " "
      "  "
    ];
  };
}
