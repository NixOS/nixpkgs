{ lib, ... }:
let
  # Mock mkNamedStruct since lib.ron doesn't exist in this branch yet
  mkNamedStruct =
    { name, value }:
    {
      _type = "ron-named-struct";
      inherit name value;
    };
in
{
  options = {
    validPoint = lib.mkOption {
      type = lib.types.ronNamedStructOf lib.types.int;
      # Force evaluation for testing
      apply = v: builtins.deepSeq v v;
    };

    validPerson = lib.mkOption {
      type = lib.types.ronNamedStructOf lib.types.str;
      # Force evaluation for testing
      apply = v: builtins.deepSeq v v;
    };

    invalidNotRonNamedStruct = lib.mkOption {
      type = lib.types.ronNamedStructOf lib.types.int;
    };

    invalidWrongType = lib.mkOption {
      type = lib.types.ronNamedStructOf lib.types.int;
      # Force evaluation for testing
      apply = v: builtins.deepSeq v v;
    };

    invalidMixedNames = lib.mkOption {
      type = lib.types.ronNamedStructOf lib.types.int;
    };
  };

  config = {
    validPoint = mkNamedStruct {
      name = "Point";
      value = {
        x = 10;
        y = 20;
      };
    };
    validPerson = mkNamedStruct {
      name = "Person";
      value = {
        name = "Alice";
        age = "30";
      };
    };
    invalidNotRonNamedStruct = {
      x = 10;
      y = 20;
    };
    invalidWrongType = mkNamedStruct {
      name = "Point";
      value = {
        x = "not an int";
        y = 20;
      };
    };
    invalidMixedNames = lib.mkMerge [
      (mkNamedStruct {
        name = "Point";
        value = {
          x = 10;
        };
      })
      (mkNamedStruct {
        name = "Line";
        value = {
          x = 20;
        };
      })
    ];
  };
}
