# This module defines global configuration for the shells.

{ config, pkgs, ... }:

with pkgs.lib;

{
  options = {
    environment.shellAliases = mkOption {
      type = types.attrs; # types.attrsOf types.stringOrPath;
      default = {};
      example = {
        ll = "ls -lh";
      };
      description = ''
        An attribute set that maps aliases (the top level attribute names in
        this option) to command strings or directly to build outputs. The
        aliases are added to all users' shells.
      '';
    };
  };

  config = {
  };
}
