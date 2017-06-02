{ config, lib, pkgs, ... }:

with lib;

let

  dmcfg = config.services.xserver.desktopManager;

in

{
  options = {

    services.xserver.desktopManager.select = mkOption {
      type = with types; listOf (enum [ "xterm" ]);
    };

  };

  config = mkIf (elem "xterm" dmcfg.select) {

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
