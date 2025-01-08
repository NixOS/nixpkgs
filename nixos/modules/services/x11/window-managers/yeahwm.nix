{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.yeahwm;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.yeahwm.enable = lib.mkEnableOption "yeahwm";
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "yeahwm";
      start = ''
        ${pkgs.yeahwm}/bin/yeahwm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.yeahwm ];
  };
}
