{ lib, ... }:
with lib;
with types;
{
  options = mapAttrs (_: type: mkOption { inherit type; }) rec {
    enum_string = enumAttrs { "foo" = "f"; };
    enum_int = enumWith [ (nameValuePair 42 24) ];
    merge = enum_string.typeMerge enum_int.functor;
    multiple = merge;
    priorities = merge;
    string_attrs = enumAttrs "Not a list";
    string = enumWith "Not a list";
    missing = enumWith [ { name = "some"; } ];
    duplicate = enumWith [ (nameValuePair 42 24) (nameValuePair 42 24) ];
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
    string_attrs = null;
    string = null;
    missing = null;
    duplicate = null;
  };
}
