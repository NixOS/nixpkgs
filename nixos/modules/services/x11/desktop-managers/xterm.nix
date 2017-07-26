{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.xserver.desktopManager.xterm;

in

{
  options = {

    services.xserver.desktopManager.xterm.enable = mkOption {
      default = true;
      description = "Enable a xterm terminal as a desktop manager.";
    };

  };

  config = mkIf (config.services.xserver.enable && cfg.enable) {

    services.xserver.desktopManager.session = singleton
      { name = "xterm";
        start = ''
          ${pkgs.xterm}/bin/xterm -ls &
          waitPID=$!
        '';
      };

    environment.systemPackages = [ pkgs.xterm ];

  };

}
