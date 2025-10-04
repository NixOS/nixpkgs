{ lib, ... }:
{
  options.value = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.str.extend (final: prev: { emptyValue.value = "empty"; }));
    default = { };
  };
}
