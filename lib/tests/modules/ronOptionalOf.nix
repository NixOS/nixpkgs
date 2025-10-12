{ lib, ... }:
let
  # Mock mkOptional since lib.ron doesn't exist in this branch yet
  mkOptional = value: {
    _type = "ron-optional";
    inherit value;
  };
in
{
  options = {
    validNone = lib.mkOption {
      type = lib.types.ronOptionalOf lib.types.int;
    };

    validSome = lib.mkOption {
      type = lib.types.ronOptionalOf lib.types.int;
      # Force evaluation for testing
      apply = v: builtins.deepSeq v v;
    };

    invalidNotRonOptional = lib.mkOption {
      type = lib.types.ronOptionalOf lib.types.int;
    };

    invalidWrongType = lib.mkOption {
      type = lib.types.ronOptionalOf lib.types.int;
    };

    invalidMixed = lib.mkOption {
      type = lib.types.ronOptionalOf lib.types.int;
    };
  };

  config = {
    validNone = mkOptional null;
    validSome = mkOptional 42;
    invalidNotRonOptional = 42;
    invalidWrongType = mkOptional "not an int";
    invalidMixed = lib.mkMerge [
      (mkOptional null)
      (mkOptional 10)
    ];
  };
}
