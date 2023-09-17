{ lib, ... }:
with lib;
with types;
{
  options = mapAttrs (_: type: mkOption { inherit type; }) rec {
    enumString = enum [ "foo" ];
    enumInt = enum [ 42 ];
    merge = enumString.typeMerge enumInt.functor;
    multiple = merge;
    priorities = merge;
    string = enum "Not a list";
  };

  config = {
    enumString = "foo";
    enumInt = 42;
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
