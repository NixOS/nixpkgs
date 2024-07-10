{ lib, ... }:

{
  options = {
    value = lib.mkOption {
      type = lib.types.ints.between (-21) 43;
    };
  };
}
