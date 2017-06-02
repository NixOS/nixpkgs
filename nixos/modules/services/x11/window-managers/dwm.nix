{ config, lib, pkgs, ... }:

with lib;

let

  wmcfg = config.services.xserver.windowManager;

in

{

  ###### interface

  options = {
    services.xserver.windowManager.select = mkOption {
      type = with types; listOf (enum [ "dwm" ]);
    };
  };


  ###### implementation

  config = mkIf (elem "bspwm" wmcfg.select) {

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
