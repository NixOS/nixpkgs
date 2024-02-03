{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.xserver.windowManager."2bwm";

in

{

  ###### interface

  options = {
    services.xserver.windowManager."2bwm".enable = mkEnableOption (lib.mdDoc "2bwm");
  };


  ###### implementation

  config = mkIf cfg.enable {

    services.xserver.windowManager.session = singleton
      { name = "2bwm";
        start =
          ''
            ${pkgs._2bwm}/bin/2bwm &
            waitPID=$!
          '';
      };

    environment.systemPackages = [ pkgs._2bwm ];

  };

}
