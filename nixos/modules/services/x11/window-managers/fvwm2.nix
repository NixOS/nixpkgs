{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.fvwm2;
  fvwm2 = cfg.package.override { enableGestures = cfg.gestures; };
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

      package = lib.mkPackageOption pkgs "fvwm2" { };

      gestures = lib.mkEnableOption "libstroke for gesture support";
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
