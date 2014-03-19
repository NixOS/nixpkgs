{ config, pkgs, ... }:

with pkgs.lib;

let
  cfg = config.programs.ibus;

in {
  options = {
    programs.ibus.enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "Enable Intelligent Input Bus (ibus)";
    };

    programs.ibus.engines = mkOption {
      type = types.listOf types.path;
      default = [];
      example = [ pkgs.ibus_chewing ];
      description = "A list of ibus engines to enable";
    };
  };

  config = mkIf cfg.enable {
    # Need to add dconf, or otherwise dbus will complain that it cannot find ca.desrt.dconf.service.
    environment.systemPackages = [ pkgs.ibus pkgs.gnome3.dconf ] ++ cfg.engines;
    environment.pathsToLink = [ "/share/ibus/component" ];
  };
}
