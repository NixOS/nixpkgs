# NOTE: Tests related to arrayReplace go here.
{
  arrayReplace,
  lib,
  testers,
}:
let
  inherit (lib.attrsets) recurseIntoAttrs removeAttrs;
  inherit (testers) testEqualArrayOrMap;
  check =
    args:
    (testEqualArrayOrMap (
      (removeAttrs args [ "delimiter" ])
      // {
        script = ''
          set -eu
          nixLog "running arrayReplace with valuesArray and valuesMap to populate actualArray"
          arrayReplace valuesArray valuesMap "$delimiter" actualArray
        '';
      }
    )).overrideAttrs
      (prevAttrs: {
        nativeBuildInputs = prevAttrs.nativeBuildInputs or [ ] ++ [ arrayReplace ];
        inherit (args) delimiter;
      });
in
recurseIntoAttrs {
  empty-with-string = check {
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
  singleton-made-empty = check {
    name = "singleton-made-empty";
    valuesArray = [ "apple" ];
    valuesMap = {
      "apple" = "";
    };
    delimiter = " ";
    expectedArray = [ ];
  };
  singleton-made-singleton = check {
    name = "singleton-made-singleton";
    valuesArray = [ "apple" ];
    valuesMap = {
      "apple" = "bee";
    };
    delimiter = " ";
    expectedArray = [ "bee" ];
  };
  singleton-none-matching = check {
    name = "singleton-none-matching";
    valuesArray = [ "apple" ];
    valuesMap = {
      "bee" = "cat";
    };
    delimiter = " ";
    expectedArray = [ "apple" ];
  };
  # preserves-duplicates = check {
  #   name = "preserves-duplicates";
  #   valuesArray = [
  #     "apple"
  #     "bee"
  #     "apple"
  #   ];
  #   valuesToRemoveArray = [ "bee" ];
  #   expectedArray = [
  #     "apple"
  #     "apple"
  #   ];
  # };
  # order-of-first-array-preserved = check {
  #   name = "order-of-first-array-preserved";
  #   valuesArray = [
  #     "apple"
  #     "cat"
  #     "bee"
  #     "dog"
  #     "apple"
  #     "bee"
  #   ];
  #   valuesToRemoveArray = [
  #     "bee"
  #     "apple"
  #   ];
  #   expectedArray = [
  #     "cat"
  #     "dog"
  #   ];
  # };
  # TODO: Negative tests.
}
