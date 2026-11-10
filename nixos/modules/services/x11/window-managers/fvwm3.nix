{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.xserver.windowManager.fvwm3;
  inherit (pkgs) fvwm3;
in

{

  ###### interface

  options = {
    services.xserver.windowManager.fvwm3 = {
      enable = mkEnableOption "Fvwm3 window manager";
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "fvwm3";
      start = ''
        ${fvwm3}/bin/fvwm3 &
        waitPID=$!
      '';
    };

    environment.systemPackages = [ fvwm3 ];
  };
}
