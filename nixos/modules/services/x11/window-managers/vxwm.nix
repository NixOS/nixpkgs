{
  lib,
  pkgs,
  config,
  ...
}:

with lib;

let
  cfg = config.services.xserver.windowManager.vxwm;
in
{
  options = {
    services.xserver.windowManager.vxwm.enable = mkEnableOption "vxwm";
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "vxwm";
      start = ''
        ${pkgs.vxwm}/bin/vxwm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.vxwm ];
  };
}
