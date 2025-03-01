# NOTE: Tests related to computeFrequencyMap go here.
{
  computeFrequencyMap,
  lib,
  testers,
}:
let
  inherit (lib.attrsets) recurseIntoAttrs;
  inherit (testers) testBuildFailure' testEqualArrayOrMap;
  check =
    args:
    (testEqualArrayOrMap (
      args
      // {
        script = ''
          set -eu
          nixLog "running computeFrequencyMap with valuesArray to populate actualMap"
          computeFrequencyMap valuesArray actualMap
        '';
      }
    )).overrideAttrs
      (prevAttrs: {
        nativeBuildInputs = prevAttrs.nativeBuildInputs or [ ] ++ [ computeFrequencyMap ];
      });
in
recurseIntoAttrs {
  empty = check {
    name = "empty";
    valuesArray = [ ];
    expectedMap = { };
  };
  singleton = check {
    name = "singleton";
    valuesArray = [ "apple" ];
    expectedMap.apple = 1;
  };
  twoUnique = check {
    name = "twoUnique";
    valuesArray = [
      "apple"
      "bee"
    ];
    expectedMap = {
      apple = 1;
      bee = 1;
    };
  };
  oneDuplicate = check {
    name = "oneDuplicate";
    valuesArray = [
      "apple"
      "apple"
    ];
    expectedMap.apple = 2;
  };
  oneUniqueOneDuplicate = check {
    name = "oneUniqueOneDuplicate";
    valuesArray = [
      "bee"
      "apple"
      "bee"
    ];
    expectedMap = {
      apple = 1;
      bee = 2;
    };
  };
  failMissingKeyWithEmpty = testBuildFailure' {
    drv = check {
      name = "failMissingKeyWithEmpty";
      valuesArray = [ ];
      expectedMap.apple = 1;
    };
    expectedBuilderLogEntries = [
      "ERROR: assertEqualMap: maps differ in length: expectedMap has length 1 but actualMap has length 0"
      "ERROR: assertEqualMap: maps differ at key 'apple': expectedMap has value '1' but actualMap has no such key"
    ];
  };
  failIncorrectFrequency = testBuildFailure' {
    drv = check {
      name = "failIncorrectFrequency";
      valuesArray = [
        "apple"
        "bee"
        "apple"
      ];
      expectedMap = {
        apple = 1;
        bee = 1;
      };
    };
    expectedBuilderLogEntries = [
      "ERROR: assertEqualMap: maps differ at key 'apple': expectedMap has value '1' but actualMap has value '2'"
    ];
  };
  failMissingKeyWithNonEmpty = testBuildFailure' {
    drv = check {
      name = "failMissingKeyWithNonEmpty";
      valuesArray = [
        "cat"
        "apple"
        "bee"
      ];
      expectedMap = {
        apple = 1;
        bee = 1;
      };
    };
    expectedBuilderLogEntries = [
      "ERROR: assertEqualMap: maps differ in length: expectedMap has length 2 but actualMap has length 3"
      "ERROR: assertEqualMap: maps differ at key 'cat': expectedMap has no such key but actualMap has value '1'"
    ];
  };
  failFirstArgumentIsString = testBuildFailure' {
    drv = check {
      name = "failFirstArgumentIsString";
      valuesArray = "apple";
      expectedMap = { };
    };
    expectedBuilderLogEntries = [
      "ERROR: computeFrequencyMap: first arugment inputArrRef must be an array reference"
    ];
  };
  failFirstArgumentIsMap = testBuildFailure' {
    drv = check {
      name = "failFirstArgumentIsMap";
      valuesArray.apple = 1;
      expectedMap = { };
    };
    expectedBuilderLogEntries = [
      "ERROR: computeFrequencyMap: first arugment inputArrRef must be an array reference"
    ];
  };
  failSecondArgumentIsArray = testBuildFailure' {
    drv =
      (check {
        name = "failSecondArgumentIsArray";
        valuesArray = [ ];
        expectedMap = { };
      }).overrideAttrs
        (prevAttrs: {
          script =
            ''
              nixLog "unsetting and re-declaring actualMap to be an array"
              unset actualMap
              declare -ag actualMap=()
            ''
            + prevAttrs.script;
        });
    expectedBuilderLogEntries = [
      "ERROR: computeFrequencyMap: second arugment outputMapRef must be an associative array reference"
    ];
  };
  failSecondArgumentIsString = testBuildFailure' {
    drv =
      (check {
        name = "failSecondArgumentIsString";
        valuesArray = [ ];
        expectedMap = { };
      }).overrideAttrs
        (prevAttrs: {
          script =
            ''
              nixLog "unsetting and re-declaring actualMap to be a string"
              unset actualMap
              declare -g actualMap="hello!"
            ''
            + prevAttrs.script;
        });
    expectedBuilderLogEntries = [
      "ERROR: computeFrequencyMap: second arugment outputMapRef must be an associative array reference"
    ];
  };
}
