# NOTE: Tests related to getMapKeys go here.
{
  getMapKeys,
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
        nixLog "running getMapKeys with valuesMap to populate actualArray"
        getMapKeys valuesMap actualArray
      '';
    }).overrideAttrs
      (prevAttrs: {
        nativeBuildInputs = prevAttrs.nativeBuildInputs or [ ] ++ [ getMapKeys ];
      });

  checkWithExistingElephant =
    args:
    (check args).overrideAttrs (prevAttrs: {
      script =
        ''
          nixLog "appending elephant to actualArray"
          actualArray+=("elephant")
        ''
        + prevAttrs.script;
    });
in
recurseIntoAttrs {
  shellcheck = shellcheck {
    name = "getMapKeys";
    src = ./getMapKeys.bash;
  };

  shfmt = shfmt {
    name = "getMapKeys";
    src = ./getMapKeys.bash;
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

  preservesElementsOfOutputArrayNoneMatching = checkWithExistingElephant {
    name = "preservesElementsOfOutputArrayNoneMatching";
    valuesMap = {
      "apple" = "fruit";
      "bee" = "insect";
      "carrot" = "vegetable";
    };
    expectedArray = [
      "elephant"
      "apple"
      "bee"
      "carrot"
    ];
  };

  preservesElementsOfOutputArraySomeMatching = checkWithExistingElephant {
    name = "preservesElementsOfOutputArraySomeMatching";
    valuesMap = {
      "apple" = "fruit";
      "bee" = "insect";
      "carrot" = "vegetable";
      "elephant" = "animal";
    };
    expectedArray = [
      "elephant"
      "apple"
      "bee"
      "carrot"
      "elephant"
    ];
  };
}
