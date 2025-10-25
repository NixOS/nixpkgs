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
    validRed = lib.mkOption {
      type = lib.types.ronEnum [
        "Red"
        "Green"
        "Blue"
      ];
    };

    validGreen = lib.mkOption {
      type = lib.types.ronEnum [
        "Red"
        "Green"
        "Blue"
      ];
    };

    invalidVariant = lib.mkOption {
      type = lib.types.ronEnum [
        "Red"
        "Green"
        "Blue"
      ];
    };

    invalidWithValues = lib.mkOption {
      type = lib.types.ronEnum [
        "Point"
        "Line"
      ];
    };

    invalidNotRonEnum = lib.mkOption {
      type = lib.types.ronEnum [
        "Red"
        "Green"
        "Blue"
      ];
    };
  };

  config = {
    validRed = mkEnum { variant = "Red"; };
    validGreen = mkEnum { variant = "Green"; };
    invalidVariant = mkEnum { variant = "Yellow"; };
    invalidWithValues = mkEnum {
      variant = "Point";
      values = [
        10
        20
      ];
    };
    invalidNotRonEnum = "Red";
  };
}
