{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.xserver.desktopManager.gnome;
  gnome = pkgs.gnome;

in

{

  options = {

    services.xserver.desktopManager.gnome.enable = mkOption {
      default = false;
      example = true;
      description = "Enable a gnome terminal as a desktop manager.";
    };

  };

  config = mkIf cfg.enable {

    services.xserver.desktopManager.session = singleton
      { name = "gnome";
        start = ''
          ${gnome.gnometerminal}/bin/gnome-terminal -ls &
          waitPID=$!
        '';
      };

    environment.systemPackages =
      [ gnome.gnometerminal
        gnome.GConf
        gnome.gconfeditor
      ];

  };

}
