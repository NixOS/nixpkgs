{ config, pkgs, ... }:

with pkgs.lib;

{
  options = {
    lib = mkOption {
      default = {};

      type = types.attrsOf types.attrs;

      description = ''
        This option allows modules to define helper functions, constants, etc.
      '';
    };

    dataPrefix = mkOption {
      default = "/var";
      type = types.path;
      visible = false;
      description = ''
        Default prefix for data files, used by some modules.
      '';
    };

  };
}
