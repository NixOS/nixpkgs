{ lib, ... }:
let
  # Mock mkTuple since lib.ron doesn't exist in this branch yet
  mkTuple = values: {
    _type = "ron-tuple";
    inherit values;
  };
in
{
  options = {
    validTuple = lib.mkOption {
      type = lib.types.ronTupleOf lib.types.int 3;
      # Force evaluation for testing
      apply = v: builtins.deepSeq v v;
    };

    anotherValidTuple = lib.mkOption {
      type = lib.types.ronTupleOf lib.types.int 2;
      # Force evaluation for testing
      apply = v: builtins.deepSeq v v;
    };

    invalidNotRonTuple = lib.mkOption {
      type = lib.types.ronTupleOf lib.types.int 3;
    };

    invalidWrongSize = lib.mkOption {
      type = lib.types.ronTupleOf lib.types.int 3;
    };

    invalidWrongType = lib.mkOption {
      type = lib.types.ronTupleOf lib.types.int 2;
      # Force evaluation for testing
      apply = v: builtins.deepSeq v v;
    };
  };

  config = {
    validTuple = mkTuple [
      1
      2
      3
    ];
    anotherValidTuple = mkTuple [
      10
      20
    ];
    invalidNotRonTuple = [
      1
      2
      3
    ];
    invalidWrongSize = mkTuple [
      1
      2
    ];
    invalidWrongType = mkTuple [
      "a"
      "b"
    ];
  };
}
