{ lib, ... }:
with lib;
with attrsets;
with types;
{
  options = mapAttrs (_: type: mkOption { inherit type; }) rec {
    enumString = enumAttrs { "foo" = "f"; };
    enumInt = enumWith [ (keyValuePair 42 24) ];
    merge = enumString.typeMerge enumInt.functor;
    multiple = merge;
    priorities = merge;
    stringAttrs = enumAttrs "Not a list";
    string = enumWith "Not a list";
    missing = enumWith [ { key = "some"; } ];
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
    stringAttrs = null;
    string = null;
    missing = null;
  };
}
