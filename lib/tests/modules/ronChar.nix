{ lib, ... }:
let
  # Mock mkChar since lib.ron doesn't exist in this branch yet
  mkChar = value: {
    _type = "ron-char";
    inherit value;
  };
in
{
  options = {
    validChar = lib.mkOption {
      type = lib.types.ronChar;
    };

    anotherValidChar = lib.mkOption {
      type = lib.types.ronChar;
    };

    invalidNotRonChar = lib.mkOption {
      type = lib.types.ronChar;
    };

    invalidTooLong = lib.mkOption {
      type = lib.types.ronChar;
    };

    invalidEmpty = lib.mkOption {
      type = lib.types.ronChar;
    };
  };

  config = {
    validChar = mkChar "a";
    anotherValidChar = mkChar "z";
    invalidNotRonChar = "a";
    invalidTooLong = mkChar "ab";
    invalidEmpty = mkChar "";
  };
}
