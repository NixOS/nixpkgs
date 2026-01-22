{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.fvwm3;
in

{

  ###### interface

  options = {
    services.xserver.windowManager.fvwm3 = {
      enable = lib.mkEnableOption "Fvwm3 window manager";
      package = lib.mkPackageOption pkgs "fvwm3" { };
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "fvwm3";
      start = ''
        ${cfg.package}/bin/fvwm3 &
        waitPID=$!
      '';
    };

    environment.systemPackages = [ cfg.package ];
  };
}
