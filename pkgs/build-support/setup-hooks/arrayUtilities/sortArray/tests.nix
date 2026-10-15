# NOTE: Tests related to sortArray go here.
{
  lib,
  sortArray,
  testers,
}:
let
  inherit (lib.attrsets) recurseIntoAttrs;
  inherit (testers) shellcheck shfmt testEqualArrayOrMap;
  check =
    {
      name,
      valuesArray,
      expectedArray,
    }:
    (testEqualArrayOrMap {
      inherit name valuesArray expectedArray;
      script = ''
        set -eu
        nixLog "running sortArray with valuesArray to populate actualArray"
        sortArray valuesArray actualArray
      '';
    }).overrideAttrs
      (prevAttrs: {
        nativeBuildInputs = prevAttrs.nativeBuildInputs or [ ] ++ [ sortArray ];
      });

  checkInPlace =
    {
      name,
      valuesArray,
      expectedArray,
    }:
    (testEqualArrayOrMap {
      inherit name valuesArray expectedArray;
      script = ''
        set -eu
        nixLog "running sortArray with valuesArray as input and output"
        sortArray valuesArray valuesArray
        nixLog "copying valuesArray to actualArray"
        actualArray=("''${valuesArray[@]}")
      '';
    }).overrideAttrs
      (prevAttrs: {
        nativeBuildInputs = prevAttrs.nativeBuildInputs or [ ] ++ [ sortArray ];
      });
in
recurseIntoAttrs {
  shellcheck = shellcheck {
    name = "sortArray";
    src = ./sortArray.bash;
  };

  shfmt = shfmt {
    name = "sortArray";
    src = ./sortArray.bash;
  };

  empty = check {
    name = "empty";
    valuesArray = [ ];
    expectedArray = [ ];
  };

  singleton = check {
    name = "singleton";
    valuesArray = [ "apple" ];
    expectedArray = [ "apple" ];
  };

  oneDuplicate = check {
    name = "oneDuplicate";
    valuesArray = [
      "apple"
      "apple"
    ];
    expectedArray = [
      "apple"
      "apple"
    ];
  };

  oneUnique = check {
    name = "oneUnique";
    valuesArray = [
      "bee"
      "apple"
      "bee"
    ];
    expectedArray = [
      "apple"
      "bee"
      "bee"
    ];
  };

  duplicatesWithSpacesAndLineBreaks = check {
    name = "duplicatesWithSpacesAndLineBreaks";
    valuesArray = [
      "dog"
      "bee"
      ''
        line
        break
      ''
      "cat"
      "zebra"
      "bee"
      "cat"
      "elephant"
      "dog with spaces"
      ''
        line
        break
      ''
    ];
    expectedArray = [
      "bee"
      "bee"
      "cat"
      "cat"
      "dog"
      "dog with spaces"
      "elephant"
      # NOTE: lead whitespace is removed, so the following entries start with `l`.
      ''
        line
        break
      ''
      ''
        line
        break
      ''
      "zebra"
    ];
  };

  duplicatesWithSpacesAndLineBreaksInPlace = checkInPlace {
    name = "duplicatesWithSpacesAndLineBreaksInPlace";
    valuesArray = [
      "dog"
      "bee"
      ''
        line
        break
      ''
      "cat"
      "zebra"
      "bee"
      "cat"
      "elephant"
      "dog with spaces"
      ''
        line
        break
      ''
    ];
    expectedArray = [
      "bee"
      "bee"
      "cat"
      "cat"
      "dog"
      "dog with spaces"
      "elephant"
      # NOTE: lead whitespace is removed, so the following entries start with `l`.
      ''
        line
        break
      ''
      ''
        line
        break
      ''
      "zebra"
    ];
  };
}
