{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.xserver.desktopManager.xterm;
  xserverEnabled = config.services.xserver.enable;

in

{
  options = {

    services.xserver.desktopManager.xterm.enable = mkOption {
      type = types.bool;
      default = xserverEnabled;
      defaultText = "config.services.xserver.enable";
      description = "Enable a xterm terminal as a desktop manager.";
    };

  };

  config = mkIf cfg.enable {

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
