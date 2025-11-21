{ lib, ... }:
{
  options.value = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.str // { emptyValue.value = "empty"; });
    default = { };
  };
}
