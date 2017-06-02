{ config, lib, pkgs, ... }:

with lib;

let
  wmcfg = config.services.xserver.windowManager;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.select = mkOption {
      type = with types; listOf (enum [ "mwm" ]);
    };
  };

  ###### implementation
  config = mkIf (elem "mwm" wmcfg.select) {
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
