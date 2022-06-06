{ lib, ... }:
let
  inherit (lib) types mkOption;
in
{
  options = {
    meta.maintainers = lib.mkOption {
      type = types.listOf types.raw;
      default = [];
    };
  };
}
