{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.lwm;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.lwm.enable = lib.mkEnableOption "lwm";
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "lwm";
      start = ''
        ${pkgs.lwm}/bin/lwm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.lwm ];
  };
}
