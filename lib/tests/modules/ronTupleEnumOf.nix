{ lib, ... }:
let
  # Mock mkEnum since lib.ron doesn't exist in this branch yet
  mkEnum =
    {
      variant,
      values ? [ ],
    }:
    {
      _type = "ron-enum";
      inherit variant;
    }
    // lib.optionalAttrs (values != [ ]) { inherit values; };
in
{
  options = {
    validPoint = lib.mkOption {
      type = lib.types.ronTupleEnumOf lib.types.int [ "Point" "Line" ] 2;
      # Force evaluation for testing
      apply = v: builtins.deepSeq v v;
    };

    validLine = lib.mkOption {
      type = lib.types.ronTupleEnumOf lib.types.int [ "Point" "Line" ] 2;
      # Force evaluation for testing
      apply = v: builtins.deepSeq v v;
    };

    invalidWrongVariant = lib.mkOption {
      type = lib.types.ronTupleEnumOf lib.types.int [ "Point" "Line" ] 2;
    };

    invalidWrongSize = lib.mkOption {
      type = lib.types.ronTupleEnumOf lib.types.int [ "Point" "Line" ] 2;
    };

    invalidWrongType = lib.mkOption {
      type = lib.types.ronTupleEnumOf lib.types.int [ "Point" "Line" ] 2;
      # Force evaluation for testing
      apply = v: builtins.deepSeq v v;
    };

    invalidNotRonEnum = lib.mkOption {
      type = lib.types.ronTupleEnumOf lib.types.int [ "Point" "Line" ] 2;
    };
  };

  config = {
    validPoint = mkEnum {
      variant = "Point";
      values = [
        10
        20
      ];
    };
    validLine = mkEnum {
      variant = "Line";
      values = [
        0
        100
      ];
    };
    invalidWrongVariant = mkEnum {
      variant = "Circle";
      values = [
        5
        5
      ];
    };
    invalidWrongSize = mkEnum {
      variant = "Point";
      values = [ 10 ];
    };
    invalidWrongType = mkEnum {
      variant = "Point";
      values = [
        "a"
        "b"
      ];
    };
    invalidNotRonEnum = [
      10
      20
    ];
  };
}
