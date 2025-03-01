# NOTE: Tests related to arrayReplace go here.
{
  arraysAreEqual,
  lib,
  runCommand,
  testers,
}:
let
  inherit (lib.attrsets) recurseIntoAttrs;
  inherit (testers) testBuildFailure';
  check =
    args:
    runCommand "test-arraysAreEqual-${args.name}"
      {
        __structuredAttrs = true;
        strictDeps = true;
        nativeBuildInputs = [ arraysAreEqual ];
        inherit (args) valuesArray1 valuesArray2;
      }
      ''
        set -eu
        nixLog "running arraysAreEqual with valuesArray1 and valuesArray2"
        if arraysAreEqual valuesArray1 valuesArray2; then
          nixLog "arraysAreEqual returned successfully"
          touch $out
        else
          nixErrorLog "arraysAreEqual returned unsuccessfully"
          exit 1
        fi
      '';
in
recurseIntoAttrs {
  empty-with-string = check {
    name = "empty";
    valuesArray1 = [ ];
    valuesArray2 = [ ];
  };
  singleton = check {
    name = "singleton";
    valuesArray1 = [ "apple" ];
    valuesArray2 = [ "apple" ];
  };
  preserves-duplicates = check {
    name = "preserves-duplicates";
    valuesArray1 = [
      "apple"
      "bee"
      "apple"
    ];
    valuesArray2 = [
      "apple"
      "bee"
      "apple"
    ];
  };
  different = testBuildFailure' {
    name = "different";
    drv = check {
      name = "different";
      valuesArray1 = [
        "apple"
        "bee"
        "cat"
      ];
      valuesArray2 = [
        "apple"
        "bee"
        "dog"
      ];
    };
    expectedBuilderLogEntries = [
      "ERROR: genericBuild: arraysAreEqual returned unsuccessfully"
    ];
  };
}
