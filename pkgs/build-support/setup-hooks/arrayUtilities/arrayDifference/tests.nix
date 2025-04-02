# NOTE: Tests related to arrayDifference go here.
{
  arrayDifference,
  lib,
  testers,
}:
let
  inherit (lib.attrsets) recurseIntoAttrs removeAttrs;
  inherit (testers) shellcheck shfmt testEqualArrayOrMap;
  check =
    args:
    (testEqualArrayOrMap (
      (removeAttrs args [ "valuesToRemoveArray" ])
      // {
        script = ''
          set -eu
          if isDeclaredArray valuesToRemoveArray; then
            nixLog "using valuesToRemoveArray: $(declare -p valuesToRemoveArray)"
          else
            nixErrorLog "valuesToRemoveArray must be a declared array"
          fi

          nixLog "running arrayDifference with valuesArray and valuesToRemoveArray to populate actualArray"
          arrayDifference valuesArray valuesToRemoveArray actualArray
        '';
      }
    )).overrideAttrs
      (prevAttrs: {
        inherit (args) valuesToRemoveArray;
        nativeBuildInputs = prevAttrs.nativeBuildInputs or [ ] ++ [ arrayDifference ];
      });
in
recurseIntoAttrs {
  shellcheck = shellcheck {
    name = "arrayDifference";
    src = ./arrayDifference.bash;
  };

  shfmt = shfmt {
    name = "arrayDifference";
    src = ./arrayDifference.bash;
  };

  empty = check {
    name = "empty";
    valuesArray = [ ];
    valuesToRemoveArray = [ ];
    expectedArray = [ ];
  };

  singleton = check {
    name = "singleton";
    valuesArray = [ "apple" ];
    valuesToRemoveArray = [ ];
    expectedArray = [ "apple" ];
  };

  singletonMadeEmpty = check {
    name = "singletonMadeEmpty";
    valuesArray = [ "apple" ];
    valuesToRemoveArray = [ "apple" ];
    expectedArray = [ ];
  };

  singletonNoneMatching = check {
    name = "singletonNoneMatching";
    valuesArray = [ "apple" ];
    valuesToRemoveArray = [ "bee" ];
    expectedArray = [ "apple" ];
  };

  preservesDuplicates = check {
    name = "preservesDuplicates";
    valuesArray = [
      "apple"
      "bee"
      "apple"
    ];
    valuesToRemoveArray = [ "bee" ];
    expectedArray = [
      "apple"
      "apple"
    ];
  };

  preservesOrderOfFirstArray = check {
    name = "preservesOrderOfFirstArray";
    valuesArray = [
      "apple"
      "cat"
      "bee"
      "dog"
      "apple"
      "bee"
    ];
    valuesToRemoveArray = [
      "bee"
      "apple"
    ];
    expectedArray = [
      "cat"
      "dog"
    ];
  };

  # TODO: Negative tests.
}
