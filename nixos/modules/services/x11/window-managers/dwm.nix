{ config, lib, pkgs, ... }:

with lib;

let

  wmcfg = config.services.xserver.windowManager;
  cfg = wmcfg.dwm;

in

{

  ###### implementation

  config = mkIf (elem "dwm" wmcfg.enable) {

    services.xserver.windowManager.session = singleton
      { name = "dwm";
        start =
          ''
            ${pkgs.dwm}/bin/dwm &
            waitPID=$!
          '';
      };

    environment.systemPackages = [ pkgs.dwm ];

  };

}
