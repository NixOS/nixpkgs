{ config, lib, pkgs, ... }:

with lib;

let

  dmcfg = config.services.xserver.desktopManager;

in

{

  config = mkIf (elem "xterm" dmcfg.enable) {

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
