{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.xserver.windowManager.pekwm;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.pekwm.enable = mkEnableOption "pekwm";
  };

  ###### implementation
  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "pekwm";
      start = ''
        ${pkgs.pekwm}/bin/pekwm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.pekwm ];
  };
}
