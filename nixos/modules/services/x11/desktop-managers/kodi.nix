{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.desktopManager.kodi;
in

{
  options = {
    services.xserver.desktopManager.kodi = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the kodi multimedia center.";
      };
    };
  };

  config = mkIf cfg.enable {
    services.xserver.desktopManager.session = [{
      name = "kodi";
      start = ''
        LIRC_SOCKET_PATH=/run/lirc/lircd ${pkgs.kodi}/bin/kodi --standalone &
        waitPID=$!
      '';
    }];

    environment.systemPackages = [ pkgs.kodi ];
  };
}
