# NOTE: Tests related to getMapKeys go here.
{
  getMapKeys,
  lib,
  testers,
}:
let
  inherit (lib.attrsets) recurseIntoAttrs;
  inherit (testers)
    shellcheck
    shfmt
    testBuildFailure'
    testEqualArrayOrMap
    ;
  check =
    args:
    (testEqualArrayOrMap (
      args
      // {
        script = ''
          set -eu
          nixLog "running getMapKeys with valuesMap to populate actualArray"
          getMapKeys valuesMap actualArray
        '';
      }
    )).overrideAttrs
      (prevAttrs: {
        nativeBuildInputs = prevAttrs.nativeBuildInputs or [ ] ++ [ getMapKeys ];
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

  # TODO: Negative tests.
}
