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
  options.services.xserver.windowManager.lwm = {
    enable = lib.mkEnableOption "lwm";
    package = lib.mkPackageOption pkgs "lwm" { };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "lwm";
      start = ''
        ${cfg.package}/bin/lwm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ cfg.package ];
  };
}
