{ lib, ... }:

{
  options = {
    value = lib.mkOption {
      default = 42;
      type = lib.types.coercedTo lib.types.int builtins.toString lib.types.str;
    };
  };
}
