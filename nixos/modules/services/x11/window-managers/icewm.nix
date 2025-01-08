{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.icewm;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.icewm.enable = lib.mkEnableOption "icewm";
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "icewm";
      start = ''
        ${pkgs.icewm}/bin/icewm-session &
        waitPID=$!
      '';
    };

    environment.systemPackages = [ pkgs.icewm ];
  };
}
