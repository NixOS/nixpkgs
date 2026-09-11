{ lib, ... }:

{
  options = {
    value = lib.mkOption {
      type = lib.types.ints.unsigned;
    };
  };
}
