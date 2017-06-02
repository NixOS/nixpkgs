{ config, lib, pkgs, ... }:

with lib;

let
  wmcfg = config.services.xserver.windowManager;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.select = mkOption {
      type = with types; listOf (enum [ "pekwm" ]);
    };
  };

  ###### implementation
  config = mkIf (elem "pekwm" wmcfg.select) {
    services.xserver.windowManager.session = singleton {
      name = "pekwm";
      start = ''
        ${pkgs.pekwm}/bin/pekwm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.pekwm ];
  };
}
