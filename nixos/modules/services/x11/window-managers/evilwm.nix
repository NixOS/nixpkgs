{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.evilwm;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.evilwm.enable = mkEnableOption "evilwm";
  };

  ###### implementation
  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "evilwm";
      start = ''
        ${pkgs.evilwm}/bin/evilwm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.evilwm ];
  };
}
