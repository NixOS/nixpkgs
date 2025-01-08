{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.fvwm2;
  fvwm2 = pkgs.fvwm2.override { enableGestures = cfg.gestures; };
in

{

  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "xserver" "windowManager" "fvwm" ]
      [ "services" "xserver" "windowManager" "fvwm2" ]
    )
  ];

  ###### interface

  options = {
    services.xserver.windowManager.fvwm2 = {
      enable = lib.mkEnableOption "Fvwm2 window manager";

      gestures = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether or not to enable libstroke for gesture support";
      };
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "fvwm2";
      start = ''
        ${fvwm2}/bin/fvwm &
        waitPID=$!
      '';
    };

    environment.systemPackages = [ fvwm2 ];
  };
}
