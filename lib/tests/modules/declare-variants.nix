{ lib, moduleType, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.variants = mkOption {
    type = types.lazyAttrsOf moduleType;
    default = { };
  };
}
