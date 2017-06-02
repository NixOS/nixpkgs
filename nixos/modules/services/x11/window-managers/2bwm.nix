{ config, lib, pkgs, ... }:

with lib;

let

  wmcfg = config.services.xserver.windowManager;

in

{

  ###### interface

  options = {
    services.xserver.windowManager.select = mkOption {
      type = with types; listOf (enum [ "2bwm" ]);
    };
  };


  ###### implementation

  config = mkIf (elem "2bwm" wmcfg.select) {

    services.xserver.windowManager.session = singleton
      { name = "2bwm";
        start =
          ''
            ${pkgs."2bwm"}/bin/2bwm &
            waitPID=$!
          '';
      };

    environment.systemPackages = [ pkgs."2bwm" ];

  };

}
