{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.yeahwm;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.yeahwm.enable = mkEnableOption "yeahwm";
  };

  ###### implementation
  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "yeahwm";
      start = ''
        ${pkgs.yeahwm}/bin/yeahwm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.yeahwm ];
  };
}
