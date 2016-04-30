{ config, lib, pkgs, ... }:

with lib;

let
  dmcfg = config.services.xserver.desktopManager;
in

{
  config = mkIf (elem "kodi" dmcfg.enable) {
    services.xserver.desktopManager.session = [{
      name = "kodi";
      start = ''
        ${pkgs.kodi}/bin/kodi --lircdev /var/run/lirc/lircd --standalone &
        waitPID=$!
      '';
    }];

    environment.systemPackages = [ pkgs.kodi ];
  };
}
