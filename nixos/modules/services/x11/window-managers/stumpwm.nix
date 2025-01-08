{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.stumpwm;
in

{
  options = {
    services.xserver.windowManager.stumpwm.enable = lib.mkEnableOption "stumpwm";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "stumpwm";
      start = ''
        ${pkgs.sbclPackages.stumpwm}/bin/stumpwm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.sbclPackages.stumpwm ];
  };
}
