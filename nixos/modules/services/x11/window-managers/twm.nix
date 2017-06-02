{ config, lib, pkgs, ... }:

with lib;

let

  wmcfg = config.services.xserver.windowManager;

in

{

  ###### interface

  options = {
    services.xserver.windowManager.select = mkOption {
      type = with types; listOf (enum [ "twm" ]);
    };
  };


  ###### implementation

  config = mkIf (elem "twm" wmcfg.select) {

    services.xserver.windowManager.session = singleton
      { name = "twm";
        start =
          ''
            ${pkgs.xorg.twm}/bin/twm &
            waitPID=$!
          '';
      };

    environment.systemPackages = [ pkgs.xorg.twm ];

  };

}
