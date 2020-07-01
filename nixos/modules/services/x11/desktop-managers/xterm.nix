{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.xserver.desktopManager.xterm;
  xSessionEnabled = config.services.xserver.enable;

in

{
  options = {

    services.xserver.desktopManager.xterm.enable = mkOption {
      type = types.bool;
      default = (versionOlder config.system.stateVersion "19.09") && xSessionEnabled;
      defaultText = if versionOlder config.system.stateVersion "19.09" then "config.services.xserver.enable" else "false";
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
