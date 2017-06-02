{ config, lib, pkgs, ... }:

with lib;

let
  wmcfg = config.services.xserver.windowManager;
  cfg = config.services.xserver.windowManager.fvwm;
  fvwm = pkgs.fvwm.override { gestures = cfg.gestures; };
in

{

  ###### interface

  options = {
    services.xserver.windowManager.select = mkOption {
      type = with types; listOf (enum [ "fvwm" ]);
    };

    services.xserver.windowManager.fvwm = {
      gestures = mkOption {
        default = false;
        type = types.bool;
        description = "Whether or not to enable libstroke for gesture support";
      };
    };
  };


  ###### implementation

  config = mkIf (elem "fvwm" wmcfg.select) {
    services.xserver.windowManager.session = singleton
      { name = "fvwm";
        start =
          ''
            ${fvwm}/bin/fvwm &
            waitPID=$!
          '';
      };

    environment.systemPackages = [ fvwm ];
  };
}
