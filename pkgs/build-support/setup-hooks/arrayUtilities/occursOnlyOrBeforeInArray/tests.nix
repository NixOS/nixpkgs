# NOTE: Tests related to occursOnlyOrBeforeInArray go here.
{
  occursOnlyOrBeforeInArray,
  lib,
  testers,
}:
let
  inherit (lib.attrsets) recurseIntoAttrs;
  inherit (testers) runCommand;

  check =
    {
      name,
      value1,
      value2,
      valuesArray,
      shouldPass,
    }:
    runCommand {
      inherit
        name
        value1
        value2
        valuesArray
        shouldPass
        ;
      strictDeps = true;
      __structuredAttrs = true;
      nativeBuildInputs = [ occursOnlyOrBeforeInArray ];
      script = ''
        set -eu
        nixLog "using value1: ''${value1@Q}"
        nixLog "using value2: ''${value2@Q}"
        nixLog "using valuesArray: $(declare -p valuesArray)"
        nixLog "using shouldPass: $shouldPass"
        nixLog "running occursOnlyOrBeforeInArray with value1 value2 valuesArray"

        if occursOnlyOrBeforeInArray "$value1" "$value2" valuesArray; then
          if ((shouldPass)); then
            nixLog "Test passed as expected"
            touch $out
          else
            nixErrorLog "Test passed but should have failed!"
            exit 1
          fi
        else
          if ((shouldPass)); then
            nixErrorLog "Test failed but should have passed!"
            exit 1
          else
            nixLog "Test failed as expected"
            touch $out
          fi
        fi
      '';
    };
in
recurseIntoAttrs {
  emptyArray = check {
    name = "emptyArray";
    value1 = "apple";
    value2 = "bee";
    valuesArray = [ ];
    shouldPass = false;
  };
  emptyStringForValue1 = check {
    name = "emptyString";
    value1 = "";
    value2 = "bee";
    valuesArray = [ "" ];
    shouldPass = true;
  };
  singleton = check {
    name = "singleton";
    value1 = "apple";
    value2 = "bee";
    valuesArray = [ "apple" ];
    shouldPass = true;
  };
  occursBefore = check {
    name = "occursBefore";
    value1 = "apple";
    value2 = "bee";
    valuesArray = [
      "apple"
      "bee"
    ];
    shouldPass = true;
  };
  occursOnly = check {
    name = "occursOnly";
    value1 = "apple";
    value2 = "bee";
    valuesArray = [ "apple" ];
    shouldPass = true;
  };
  occursAfter = check {
    name = "occursAfter";
    value1 = "apple";
    value2 = "bee";
    valuesArray = [
      "bee"
      "apple"
    ];
    shouldPass = false;
  };
  occursBeforeAlmostAtEnd = check {
    name = "occursBeforeAlmostAtEnd";
    value1 = "apple";
    value2 = "cat";
    valuesArray = [
      "bee"
      "apple"
      "cat"
    ];
    shouldPass = true;
  };
  value1DoesntMatchStringWithPrefix = check {
    name = "value1DoesntMatchStringWithPrefix";
    value1 = "apple";
    value2 = "bee";
    valuesArray = [
      "apple with spaces"
      "bee"
    ];
    shouldPass = false;
  };
  value1DoesntMatchStringWithSuffix = check {
    name = "value1DoesntMatchStringWithSuffix";
    value1 = "apple";
    value2 = "bee";
    valuesArray = [
      "apple in a tree"
      "bee"
    ];
    shouldPass = false;
  };
  value2DoesntMatchStringWithPrefix = check {
    name = "value2DoesntMatchStringWithPrefix";
    value1 = "apple";
    value2 = "bee";
    valuesArray = [
      "bee with spaces"
      "apple"
    ];
    shouldPass = true;
  };
  value2DoesntMatchStringWithSuffix = check {
    name = "value2DoesntMatchStringWithSuffix";
    value1 = "apple";
    value2 = "bee";
    valuesArray = [
      "bee in a tree"
      "apple"
    ];
    shouldPass = true;
  };
  value1HasLineBreakOccursBefore = check {
    name = "value1HasLineBreakOccursBefore";
    value1 = ''
      apple

      up

      high
    '';
    value2 = "bee";
    valuesArray = [
      "cat"
      ''
        apple

        up

        high
      ''
      ''line break ''
      "bee"
    ];
    shouldPass = true;
  };
  value1HasLineBreakOccursAfter = check {
    name = "value1HasLineBreakOccursAfter";
    value1 = ''
      apple

      up

      high
    '';
    value2 = "bee";
    valuesArray = [
      "cat"
      "bee"
      ''
        apple

        up

        high
      ''
      ''line break ''
    ];
    shouldPass = false;
  };
}
