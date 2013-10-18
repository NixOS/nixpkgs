{ config, pkgs, ... }:

{
  options = {
    lib = pkgs.lib.mkOption {
      default = {};

      type = pkgs.lib.types.attrsOf pkgs.lib.types.attrs;

      description = ''
        This option allows modules to define helper functions, constants, etc.
      '';
    };
  };
}
