{ config, lib, pkgs, ... }:

with lib;

let
  wmcfg = config.services.xserver.windowManager;
in

{
  options = {
    services.xserver.windowManager.select = mkOption {
      type = with types; listOf (enum [ "stumpwm" ]);
    };
  };

  config = mkIf (elem "stumpwm" wmcfg.select) {
    services.xserver.windowManager.session = singleton {
      name = "stumpwm";
      start = ''
        ${pkgs.stumpwm}/bin/stumpwm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.stumpwm ];
  };
}
