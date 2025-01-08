{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.fvwm3;
  inherit (pkgs) fvwm3;
in

{

  ###### interface

  options = {
    services.xserver.windowManager.fvwm3 = {
      enable = lib.mkEnableOption "Fvwm3 window manager";
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "fvwm3";
      start = ''
        ${fvwm3}/bin/fvwm3 &
        waitPID=$!
      '';
    };

    environment.systemPackages = [ fvwm3 ];
  };
}
