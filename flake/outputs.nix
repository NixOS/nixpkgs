{ lib, ... }:
{
  options.outputs = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.unspecified;
  };
}
