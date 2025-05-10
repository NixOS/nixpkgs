# NOTE: Tests related to arrayDifference go here.
{
  arrayDifference,
  lib,
  testers,
}:
let
  inherit (lib.attrsets) recurseIntoAttrs;
  inherit (testers) shellcheck shfmt testEqualArrayOrMap;

  check =
    {
      name,
      valuesArray,
      valuesToRemoveArray,
      expectedArray,
    }:
    (testEqualArrayOrMap {
      inherit name valuesArray expectedArray;
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
    }).overrideAttrs
      (prevAttrs: {
        inherit valuesToRemoveArray;
        nativeBuildInputs = prevAttrs.nativeBuildInputs or [ ] ++ [ arrayDifference ];
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
    name = "arrayDifference";
    src = ./arrayDifference.bash;
  };

  shfmt = shfmt {
    name = "arrayDifference";
    src = ./arrayDifference.bash;
  };

  emptyRemoveEmptyIsEmpty = check {
    name = "emptyRemoveEmptyIsEmpty";
    valuesArray = [ ];
    valuesToRemoveArray = [ ];
    expectedArray = [ ];
  };

  emptyRemoveAppleIsEmpty = check {
    name = "emptyRemoveAppleIsEmpty";
    valuesArray = [ ];
    valuesToRemoveArray = [ "apple" ];
    expectedArray = [ ];
  };

  appleRemoveEmptyIsApple = check {
    name = "appleRemoveEmptyIsApple";
    valuesArray = [ "apple" ];
    valuesToRemoveArray = [ ];
    expectedArray = [ "apple" ];
  };

  appleRemoveAppleIsEmpty = check {
    name = "appleRemoveAppleIsEmpty";
    valuesArray = [ "apple" ];
    valuesToRemoveArray = [ "apple" ];
    expectedArray = [ ];
  };

  appleRemoveBeeIsApple = check {
    name = "appleRemoveBeeIsApple";
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

  preservesElementsOfOutputArrayNoneMatching = checkWithExistingElephant {
    name = "preservesElementsOfOutputArrayNoneMatching";
    valuesArray = [
      "apple"
      "cat"
    ];
    valuesToRemoveArray = [
      "pineapple"
    ];
    expectedArray = [
      "elephant"
      "apple"
      "cat"
    ];
  };

  preservesElementsOfOutputArraySomeMatching = checkWithExistingElephant {
    name = "preservesElementsOfOutputArraySomeMatching";
    valuesArray = [
      "pineapple"
      "apple"
      "cat"
    ];
    valuesToRemoveArray = [
      "pineapple"
    ];
    expectedArray = [
      "elephant"
      "apple"
      "cat"
    ];
  };

  preservesElementsOfOutputArraySomeMatchingExisting = checkWithExistingElephant {
    name = "preservesElementsOfOutputArraySomeMatchingExisting";
    valuesArray = [
      "pineapple"
      "apple"
      "elephant"
      "cat"
    ];
    valuesToRemoveArray = [
      "pineapple"
      "elephant"
    ];
    expectedArray = [
      "elephant"
      "apple"
      "cat"
    ];
  };
}
