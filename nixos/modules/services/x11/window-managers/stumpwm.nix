{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.xserver.windowManager.stumpwm;
in

{
  options = {
    services.xserver.windowManager.stumpwm.enable = mkEnableOption "stumpwm";
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "stumpwm";
      start = ''
        ${pkgs.sbclPackages.stumpwm}/bin/stumpwm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.sbclPackages.stumpwm ];
  };
}
