{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.desktopManager.kodi;
in

{
  options = {
    services.xserver.desktopManager.kodi = {
      enable = mkOption {
        default = false;
        example = true;
        description = "Enable the kodi multimedia center.";
      };
    };
  };

  config = mkIf cfg.enable {
    services.xserver.desktopManager.session = [{
      name = "kodi";
      start = ''
        ${pkgs.kodi}/bin/kodi --lircdev /var/run/lirc/lircd --standalone &
        waitPID=$!
      '';
    }];
    services.xserver.displayManager.desktopManagerHandlesLidAndPower = true;

    environment.systemPackages = [ pkgs.kodi ];
  };
}
