# NOTE: Tests related to arrayDifference go here.
{
  arrayDifference,
  lib,
  testers,
}:
let
  inherit (lib.attrsets) recurseIntoAttrs removeAttrs;
  inherit (testers) testEqualArrayOrMap;
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
  singleton-made-empty = check {
    name = "singleton-made-empty";
    valuesArray = [ "apple" ];
    valuesToRemoveArray = [ "apple" ];
    expectedArray = [ ];
  };
  singleton-none-matching = check {
    name = "singleton-none-matching";
    valuesArray = [ "apple" ];
    valuesToRemoveArray = [ "bee" ];
    expectedArray = [ "apple" ];
  };
  preserves-duplicates = check {
    name = "preserves-duplicates";
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
  order-of-first-array-preserved = check {
    name = "order-of-first-array-preserved";
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
