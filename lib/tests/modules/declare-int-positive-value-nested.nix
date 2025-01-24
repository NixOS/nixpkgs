{ lib, ... }:

{
  options.set = {
    value = lib.mkOption {
      type = lib.types.ints.positive;
    };
  };
}
