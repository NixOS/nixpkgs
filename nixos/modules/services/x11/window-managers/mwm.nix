{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.mwm;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.mwm.enable = mkEnableOption (lib.mdDoc "mwm");
  };

  ###### implementation
  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "mwm";
      start = ''
        ${pkgs.motif}/bin/mwm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.motif ];
  };
}
