{ lib, ... }:
{
  options.value = lib.mkOption {
    type = lib.types.either lib.types.int lib.types.str;
  };
}
