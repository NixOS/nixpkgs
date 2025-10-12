{ lib, ... }:
let
  # Mock mkMap since lib.ron doesn't exist in this branch yet
  mkMap = attrs: {
    _type = "ron-map";
    inherit attrs;
  };
in
{
  options = {
    validStringIntMap = lib.mkOption {
      type = lib.types.ronMapOf lib.types.str lib.types.int;
      # Force evaluation for testing
      apply = v: builtins.deepSeq v v;
    };

    validIntStrMap = lib.mkOption {
      type = lib.types.ronMapOf lib.types.int lib.types.str;
      # Force evaluation for testing
      apply = v: builtins.deepSeq v v;
    };

    invalidNotRonMap = lib.mkOption {
      type = lib.types.ronMapOf lib.types.str lib.types.int;
    };

    invalidWrongKeyType = lib.mkOption {
      type = lib.types.ronMapOf lib.types.int lib.types.str;
      # Force evaluation for testing
      apply = v: builtins.deepSeq v v;
    };

    invalidWrongValueType = lib.mkOption {
      type = lib.types.ronMapOf lib.types.str lib.types.int;
      # Force evaluation for testing
      apply = v: builtins.deepSeq v v;
    };
  };

  config = {
    validStringIntMap = mkMap [
      {
        key = "a";
        value = 1;
      }
      {
        key = "b";
        value = 2;
      }
    ];
    validIntStrMap = mkMap [
      {
        key = 1;
        value = "one";
      }
      {
        key = 2;
        value = "two";
      }
    ];
    invalidNotRonMap = {
      a = 1;
      b = 2;
    };
    invalidWrongKeyType = mkMap [
      {
        key = "not an int";
        value = "value";
      }
    ];
    invalidWrongValueType = mkMap [
      {
        key = "key";
        value = "not an int";
      }
    ];
  };
}
