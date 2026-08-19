{ lib, ... }:

{
  options = {
    value = lib.mkOption {
      default = "12";
      type = lib.types.coercedTo lib.types.str lib.toInt lib.types.ints.s8;
    };
  };
}
