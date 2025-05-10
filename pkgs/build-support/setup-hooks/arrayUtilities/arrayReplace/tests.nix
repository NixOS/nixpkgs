# NOTE: Tests related to arrayReplace go here.
{
  arrayReplace,
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
      valuesMap,
      delimiter,
      expectedArray,
    }:
    (testEqualArrayOrMap {
      inherit
        name
        valuesArray
        valuesMap
        expectedArray
        ;
      script = ''
        set -eu
        nixLog "running arrayReplace with valuesArray and valuesMap to populate actualArray"
        arrayReplace valuesArray valuesMap "$delimiter" actualArray
      '';
    }).overrideAttrs
      (prevAttrs: {
        inherit delimiter;
        nativeBuildInputs = prevAttrs.nativeBuildInputs or [ ] ++ [ arrayReplace ];
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
    name = "arrayReplace";
    src = ./arrayReplace.bash;
  };

  shfmt = shfmt {
    name = "arrayReplace";
    src = ./arrayReplace.bash;
  };

  empty = check {
    name = "empty";
    valuesArray = [ ];
    valuesMap = { };
    delimiter = " ";
    expectedArray = [ ];
  };

  singleton = check {
    name = "singleton";
    valuesArray = [ "apple" ];
    valuesMap = { };
    delimiter = " ";
    expectedArray = [ "apple" ];
  };

  singletonMadeEmpty = check {
    name = "singletonMadeEmpty";
    valuesArray = [ "apple" ];
    valuesMap = {
      "apple" = "";
    };
    delimiter = " ";
    expectedArray = [ ];
  };

  singletonReplacedWithSingleton = check {
    name = "singletonReplacedWithSingleton";
    valuesArray = [ "apple" ];
    valuesMap = {
      "apple" = "bee";
    };
    delimiter = " ";
    expectedArray = [ "bee" ];
  };

  singletonNoReplacementMatches = check {
    name = "singletonNoReplacementMatches";
    valuesArray = [ "apple" ];
    valuesMap = {
      "bee" = "cat";
    };
    delimiter = " ";
    expectedArray = [ "apple" ];
  };

  singletonReplacedWithTwo = check {
    name = "singletonReplacedWithTwo";
    valuesArray = [ "apple" ];
    valuesMap = {
      "apple" = "bee cat";
    };
    delimiter = " ";
    expectedArray = [
      "bee"
      "cat"
    ];
  };

  preservesDuplicates = check {
    name = "preservesDuplicates";
    valuesArray = [
      "apple"
      "bee"
      "apple"
    ];
    valuesMap.bee = "";
    delimiter = " ";
    expectedArray = [
      "apple"
      "apple"
    ];
  };

  preservesOrder = check {
    name = "preservesOrder";
    valuesArray = [
      "apple"
      "cat"
      "bee"
      "dog"
      "apple"
      "bee"
    ];
    valuesMap = {
      "apple" = "";
      "bee" = "";
    };
    delimiter = " ";
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
      "bee"
      "dog"
      "apple"
      "bee"
    ];
    valuesMap = {
      "zebra" = "";
      "pony" = "";
    };
    delimiter = " ";
    expectedArray = [
      "elephant"
      "apple"
      "cat"
      "bee"
      "dog"
      "apple"
      "bee"
    ];
  };

  preservesElementsOfOutputArraySomeMatching = checkWithExistingElephant {
    name = "preservesElementsOfOutputArraySomeMatching";
    valuesArray = [
      "apple"
      "cat"
      "bee"
      "dog"
      "apple"
      "bee"
    ];
    valuesMap = {
      "bee" = "pony";
      "apple" = "";
    };
    delimiter = " ";
    expectedArray = [
      "elephant"
      "cat"
      "pony"
      "dog"
      "pony"
    ];
  };

  preservesElementsOfOutputArraySomeMatchingExisting = checkWithExistingElephant {
    name = "preservesElementsOfOutputArraySomeMatchingExisting";
    valuesArray = [
      "apple"
      "cat"
      "bee"
      "dog"
      "apple"
      "bee"
    ];
    valuesMap = {
      "elephant" = "";
      "bee" = "pony";
      "apple" = "";
    };
    delimiter = " ";
    expectedArray = [
      "elephant"
      "cat"
      "pony"
      "dog"
      "pony"
    ];
  };
}
