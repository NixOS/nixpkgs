{ config, lib, pkgs, ... }:

with lib;

let
  dmcfg = config.services.xserver.desktopManager;
in

{
  options = {
    services.xserver.desktopManager.select = mkOption {
      type = with types; listOf (enum [ "kodi" ]);
    };
  };

  config = mkIf (elem "kodi" dmcfg.select) {
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
