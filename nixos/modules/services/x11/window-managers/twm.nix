{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.xserver.windowManager.twm;

in

{

  ###### interface

  options = {
    services.xserver.windowManager.twm.enable = mkEnableOption (lib.mdDoc "twm");
  };


  ###### implementation

  config = mkIf cfg.enable {

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
