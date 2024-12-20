{ lib, ... }:

{
  options = {
    value = lib.mkOption {
      type = lib.types.coercedTo lib.types.int builtins.toString lib.types.str;
    };
  };
}
