# NOTE: Tests related to deduplicateArray go here.
{
  deduplicateArray,
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
    {
      name,
      valuesArray,
      expectedArray,
    }:
    (testEqualArrayOrMap {
      inherit name valuesArray expectedArray;
      script = ''
        set -eu
        nixLog "running deduplicateArray with valuesArray to populate actualArray"
        deduplicateArray valuesArray actualArray
      '';
    }).overrideAttrs
      (prevAttrs: {
        nativeBuildInputs = prevAttrs.nativeBuildInputs or [ ] ++ [ deduplicateArray ];
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
    name = "deduplicateArray";
    src = ./deduplicateArray.bash;
  };

  shfmt = shfmt {
    name = "deduplicateArray";
    src = ./deduplicateArray.bash;
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

  allUniqueOrderPreserved = check {
    name = "allUniqueOrderPreserved";
    valuesArray = [
      "apple"
      "bee"
    ];
    expectedArray = [
      "apple"
      "bee"
    ];
  };

  oneDuplicate = check {
    name = "oneDuplicate";
    valuesArray = [
      "apple"
      "apple"
    ];
    expectedArray = [
      "apple"
    ];
  };

  oneUniqueOrderPreserved = check {
    name = "oneUniqueOrderPreserved";
    valuesArray = [
      "bee"
      "apple"
      "bee"
    ];
    expectedArray = [
      "bee"
      "apple"
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
      "dog"
      "bee"
      ''
        line
        break
      ''
      "cat"
      "zebra"
      "elephant"
      "dog with spaces"
    ];
  };

  preservesElementsOfOutputArrayNoneMatching = checkWithExistingElephant {
    name = "preservesElementsOfOutputArrayNoneMatching";
    valuesArray = [
      "dog"
      "bee"
      "cat"
      "zebra"
      "bee"
      "cat"
      "dog with spaces"
    ];
    expectedArray = [
      "elephant"
      "dog"
      "bee"
      "cat"
      "zebra"
      "dog with spaces"
    ];
  };

  preservesElementsOfOutputArraySomeMatching = checkWithExistingElephant {
    name = "preservesElementsOfOutputArraySomeMatching";
    valuesArray = [
      "dog"
      "bee"
      "cat"
      "zebra"
      "bee"
      "cat"
      "elephant"
      "dog with spaces"
    ];
    expectedArray = [
      "elephant"
      "dog"
      "bee"
      "cat"
      "zebra"
      "elephant"
      "dog with spaces"
    ];
  };

  failNoDeduplication = testBuildFailure' {
    drv = check {
      name = "failNoDeduplication";
      valuesArray = [
        "bee"
        "apple"
        "bee"
      ];
      expectedArray = [
        "bee"
        "apple"
        "bee"
      ];
    };
    expectedBuilderLogEntries = [
      "ERROR: assertEqualArray: arrays differ in length: expectedArray has length 3 but actualArray has length 2"
      "ERROR: assertEqualArray: arrays differ at index 2: expectedArray has value 'bee' but actualArray has no such index"
    ];
  };
}
