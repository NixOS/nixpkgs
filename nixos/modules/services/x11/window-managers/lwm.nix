{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.lwm;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.lwm.enable = mkEnableOption (lib.mdDoc "lwm");
  };

  ###### implementation
  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "lwm";
      start = ''
        ${pkgs.lwm}/bin/lwm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.lwm ];
  };
}
