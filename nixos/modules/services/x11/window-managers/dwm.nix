{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.xserver.windowManager.dwm;

in

{

  ###### interface

  options = {
    services.xserver.windowManager.dwm.enable = mkEnableOption (lib.mdDoc "dwm");
  };


  ###### implementation

  config = mkIf cfg.enable {

    services.xserver.windowManager.session = singleton
      { name = "dwm";
        start =
          ''
            dwm &
            waitPID=$!
          '';
      };

    environment.systemPackages = [ pkgs.dwm ];

  };

}
