{ lib, ... }:
let
  inherit (lib) types mkOption;
in
{
  options = {
    meta = lib.mkOption {
      apply = lib.filterAttrs (k: v: v != null);
      type = types.submodule {
        options = {
          maintainers = lib.mkOption {
            type = types.listOf types.raw;
            default = [];
          };
          timeout = lib.mkOption {
            type = types.nullOr types.int;
            default = null;
          };
          broken = lib.mkOption {
            type = types.bool;
            default = false;
          };
        };
      };
      default = {};
    };
  };
}
