{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.pekwm;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.pekwm.enable = lib.mkEnableOption "pekwm";
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "pekwm";
      start = ''
        ${pkgs.pekwm}/bin/pekwm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.pekwm ];
  };
}
