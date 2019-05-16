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
        description = "Enable the kodi multimedia center.";
      };
    };
  };

  config = mkIf cfg.enable {
    services.xserver.desktopManager.session = [{
      name = "kodi";
      start = ''
        ${pkgs.kodi}/bin/kodi --lircdev /run/lirc/lircd --standalone &
        waitPID=$!
      '';
    }];

    environment.systemPackages = [ pkgs.kodi ];
  };
}
