{ lib, ... }:
let
  stringMergeEqualPrefix = lib.types.str // {
    merge = lib.options.mergeEqualOptionBy {
      project = lib.substring 0 3;
    };
  };
in
{
  options = {
    stringOption = lib.mkOption { type = lib.types.lazyAttrsOf lib.types.str; };
    stringPrefixOption = lib.mkOption { type = lib.types.lazyAttrsOf stringMergeEqualPrefix; };
  };
  config = {
    stringOption.ok1 = lib.mkMerge [
      "foo"
    ];
    stringOption.ok2 = lib.mkMerge [
      "foo"
      "foo"
      "foo"
    ];
    stringOption.bad1 = lib.mkMerge [
      "foo"
      "bar"
      "foo"
    ];

    stringPrefixOption.ok1 = lib.mkMerge [
      "foo"
    ];
    stringPrefixOption.ok2 = lib.mkMerge [
      "foo"
      "foo"
      "foo"
    ];
    stringPrefixOption.ok3 = lib.mkMerge [
      "foo"
      "foobar"
      "foobaz"
    ];
    stringPrefixOption.bad1 = lib.mkMerge [
      "foo"
      "bar"
      "foo"
    ];
  };
}
