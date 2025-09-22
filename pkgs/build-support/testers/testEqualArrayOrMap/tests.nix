# NOTE: We must use `pkgs.runCommand` instead of `testers.runCommand` for negative tests -- those wrapped with
# `testers.testBuildFailure`. This is due to the fact that `testers.testBuildFailure` modifies the derivation such that
# it produces an output containing the exit code, logs, and other things. Since `testers.runCommand` expects the empty
# derivation, it produces a hash mismatch.
{ lib, testers }:
let
  inherit (lib.attrsets) recurseIntoAttrs;
  inherit (testers) testBuildFailure' testEqualArrayOrMap;
  concatValuesArrayToActualArray = ''
    nixLog "appending all values in valuesArray to actualArray"
    for value in "''${valuesArray[@]}"; do
      actualArray+=( "$value" )
    done
  '';
  concatValuesMapToActualMap = ''
    nixLog "adding all values in valuesMap to actualMap"
    for key in "''${!valuesMap[@]}"; do
      actualMap["$key"]="''${valuesMap["$key"]}"
    done
  '';
in
recurseIntoAttrs {
  # NOTE: This particular test is used in the docs:
  # See https://nixos.org/manual/nixpkgs/unstable/#tester-testEqualArrayOrMap
  # or doc/build-helpers/testers.chapter.md
  docs-test-function-add-cowbell = testEqualArrayOrMap {
    name = "test-function-add-cowbell";
    valuesArray = [
      "cowbell"
      "cowbell"
    ];
    expectedArray = [
      "cowbell"
      "cowbell"
      "cowbell"
    ];
    script = ''
      addCowbell() {
        local -rn arrayNameRef="$1"
        arrayNameRef+=( "cowbell" )
      }

      nixLog "appending all values in valuesArray to actualArray"
      for value in "''${valuesArray[@]}"; do
        actualArray+=( "$value" )
      done

      nixLog "applying addCowbell"
      addCowbell actualArray
    '';
  };
  array-append = testEqualArrayOrMap {
    name = "testEqualArrayOrMap-array-append";
    valuesArray = [
      "apple"
      "bee"
      "cat"
    ];
    expectedArray = [
      "apple"
      "bee"
      "cat"
      "dog"
    ];
    script = ''
      ${concatValuesArrayToActualArray}
      actualArray+=( "dog" )
    '';
  };
  array-prepend = testEqualArrayOrMap {
    name = "testEqualArrayOrMap-array-prepend";
    valuesArray = [
      "apple"
      "bee"
      "cat"
    ];
    expectedArray = [
      "dog"
      "apple"
      "bee"
      "cat"
    ];
    script = ''
      actualArray+=( "dog" )
      ${concatValuesArrayToActualArray}
    '';
  };
  array-empty = testEqualArrayOrMap {
    name = "testEqualArrayOrMap-array-empty";
    valuesArray = [
      "apple"
      "bee"
      "cat"
    ];
    expectedArray = [ ];
    script = ''
      # doing nothing
    '';
  };
  array-missing-value = testBuildFailure' {
    drv = testEqualArrayOrMap {
      name = "testEqualArrayOrMap-array-missing-value";
      valuesArray = [ "apple" ];
      expectedArray = [ ];
      script = concatValuesArrayToActualArray;
    };
    expectedBuilderLogEntries = [
      "ERROR: assertEqualArray: arrays differ in length: expectedArray has length 0 but actualArray has length 1"
      "ERROR: assertEqualArray: arrays differ at index 0: expectedArray has no such index but actualArray has value 'apple'"
    ];
  };
  map-insert = testEqualArrayOrMap {
    name = "testEqualArrayOrMap-map-insert";
    valuesMap = {
      apple = "0";
      bee = "1";
      cat = "2";
    };
    expectedMap = {
      apple = "0";
      bee = "1";
      cat = "2";
      dog = "3";
    };
    script = ''
      ${concatValuesMapToActualMap}
      actualMap["dog"]="3"
    '';
  };
  map-remove = testEqualArrayOrMap {
    name = "testEqualArrayOrMap-map-remove";
    valuesMap = {
      apple = "0";
      bee = "1";
      cat = "2";
      dog = "3";
    };
    expectedMap = {
      apple = "0";
      cat = "2";
      dog = "3";
    };
    script = ''
      ${concatValuesMapToActualMap}
      unset 'actualMap[bee]'
    '';
  };
  map-missing-key = testBuildFailure' {
    drv = testEqualArrayOrMap {
      name = "testEqualArrayOrMap-map-missing-key";
      valuesMap = {
        bee = "1";
        cat = "2";
        dog = "3";
      };
      expectedMap = {
        apple = "0";
        bee = "1";
        cat = "2";
        dog = "3";
      };
      script = concatValuesMapToActualMap;
    };
    expectedBuilderLogEntries = [
      "ERROR: assertEqualMap: maps differ in length: expectedMap has length 4 but actualMap has length 3"
      "ERROR: assertEqualMap: maps differ at key 'apple': expectedMap has value '0' but actualMap has no such key"
    ];
  };
  map-missing-key-with-empty = testBuildFailure' {
    drv = testEqualArrayOrMap {
      name = "testEqualArrayOrMap-map-missing-key-with-empty";
      valuesArray = [ ];
      expectedMap.apple = 1;
      script = "";
    };
    expectedBuilderLogEntries = [
      "ERROR: assertEqualMap: maps differ in length: expectedMap has length 1 but actualMap has length 0"
      "ERROR: assertEqualMap: maps differ at key 'apple': expectedMap has value '1' but actualMap has no such key"
    ];
  };
  map-extra-key = testBuildFailure' {
    drv = testEqualArrayOrMap {
      name = "testEqualArrayOrMap-map-extra-key";
      valuesMap = {
        apple = "0";
        bee = "1";
        cat = "2";
        dog = "3";
      };
      expectedMap = {
        apple = "0";
        bee = "1";
        dog = "3";
      };
      script = concatValuesMapToActualMap;
    };
    expectedBuilderLogEntries = [
      "ERROR: assertEqualMap: maps differ in length: expectedMap has length 3 but actualMap has length 4"
      "ERROR: assertEqualMap: maps differ at key 'cat': expectedMap has no such key but actualMap has value '2'"
    ];
  };
}
