# NOTE: Tests related to occursInArray go here.
{
  lib,
  occursInArray,
  runCommand,
  testers,
}:
let
  inherit (lib.attrsets) recurseIntoAttrs;
  inherit (testers) shellcheck shfmt testBuildFailure';

  check =
    {
      name,
      valuesArray,
      value,
    }:
    runCommand name
      {
        __structuredAttrs = true;
        strictDeps = true;
        preferLocalBuild = true;
        nativeBuildInputs = [ occursInArray ];
        inherit value valuesArray;
      }
      ''
        set -eu
        nixLog "running occursInArray with value ''${value@Q} and array ''${valuesArray[@]@Q}"
        if occursInArray "$value" valuesArray; then
          nixLog "test passed"
          touch "$out"
        else
          nixErrorLog "test failed"
          exit 1
        fi
      '';
in
recurseIntoAttrs {
  shellcheck = shellcheck {
    name = "occursInArray";
    src = ./occursInArray.bash;
  };

  shfmt = shfmt {
    name = "occursInArray";
    src = ./occursInArray.bash;
  };

  empty = testBuildFailure' {
    name = "empty";
    drv = check {
      name = "empty";
      valuesArray = [ ];
      value = "apple";
    };
    expectedBuilderLogEntries = [
      "test failed"
    ];
  };

  singletonMatch = check {
    name = "singletonMatch";
    valuesArray = [ "apple" ];
    value = "apple";
  };

  singletonNoMatch = testBuildFailure' {
    name = "singletonNoMatch";
    drv = check {
      name = "singletonNoMatch";
      valuesArray = [ "apple" ];
      value = "banana";
    };
    expectedBuilderLogEntries = [
      "test failed"
    ];
  };

  oneDuplicateMatch = check {
    name = "oneDuplicateMatch";
    valuesArray = [
      "apple"
      "apple"
    ];
    value = "apple";
  };

  oneDuplicateNoMatch = testBuildFailure' {
    name = "oneDuplicateNoMatch";
    drv = check {
      name = "oneDuplicateNoMatch";
      valuesArray = [
        "apple"
        "apple"
      ];
      value = "banana";
    };
    expectedBuilderLogEntries = [
      "test failed"
    ];
  };

  oneUniqueMatch = check {
    name = "oneUniqueMatch";
    valuesArray = [
      "bee"
      "apple"
      "bee"
    ];
    value = "apple";
  };
}
