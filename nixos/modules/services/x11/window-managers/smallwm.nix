{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.smallwm;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.smallwm.enable = mkEnableOption (lib.mdDoc "smallwm");
  };

  ###### implementation
  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "smallwm";
      start = ''
        ${pkgs.smallwm}/bin/smallwm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.smallwm ];
  };
}
