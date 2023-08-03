{ lib, ... }:
let
  foo_bar = lib.types.enumMap { "foo" = "bar"; };
  bar_foo = lib.types.enumMap { "bar" = "foo"; };
  merged = lib.defaultTypeMerge foo_bar.functor bar_foo.functor;
in
{
  options = {
    map = lib.mkOption {
      type = foo_bar;
    };
    multiple = lib.mkOption {
      type = merged;
    };
    merge = lib.mkOption {
      type = merged;
    };
    priorities = lib.mkOption {
      type = merged;
    };
  };

  config = {
    map = "foo";
    multiple = lib.mkMerge [
      "foo"
      "bar"
    ];
    merge = "bar";
    priorities = lib.mkMerge [
      "foo"
      (lib.mkForce "bar")
    ];
  };
}
