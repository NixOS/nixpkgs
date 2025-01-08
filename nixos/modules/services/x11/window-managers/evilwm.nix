{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.evilwm;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.evilwm.enable = lib.mkEnableOption "evilwm";
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "evilwm";
      start = ''
        ${pkgs.evilwm}/bin/evilwm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.evilwm ];
  };
}
