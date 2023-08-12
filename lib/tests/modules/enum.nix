{ lib, ... }:
with lib;
with types;
{
  options = mapAttrs (_: type: mkOption { inherit type; }) rec {
    enum_string = enum [ "foo" ];
    enum_int = enum [ 42 ];
    merge = enum_string.typeMerge enum_int.functor;
    multiple = merge;
    priorities = merge;
    string = enum "Not a list";
  };

  config = {
    enum_string = "foo";
    enum_int = 42;
    multiple = mkMerge [
      "foo"
      42
    ];
    merge = 42;
    priorities = mkMerge [
      "foo"
      (mkForce 42)
    ];
    string = null;
  };
}
