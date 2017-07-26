{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.fvwm;
  fvwm = pkgs.fvwm.override { gestures = cfg.gestures; };
in

{

  ###### interface

  options = {
    services.xserver.windowManager.fvwm = {
      enable = mkEnableOption "Fvwm window manager";

      gestures = mkOption {
        default = false;
        type = types.bool;
        description = "Whether or not to enable libstroke for gesture support";
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {
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
