{ lib, ... }:
let
  # Mock mkRaw since lib.ron doesn't exist in this branch yet
  mkRaw = value: {
    _type = "ron-raw";
    inherit value;
  };
in
{
  options = {
    validRaw = lib.mkOption {
      type = lib.types.rawRon;
    };

    anotherValidRaw = lib.mkOption {
      type = lib.types.rawRon;
    };

    invalidNotRonRaw = lib.mkOption {
      type = lib.types.rawRon;
    };
  };

  config = {
    validRaw = mkRaw "raw_value";
    anotherValidRaw = mkRaw "MyEnum::Variant(1)";
    invalidNotRonRaw = "plain_string";
  };
}
