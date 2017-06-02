
{ config, lib, pkgs, ... }:

with lib;

let
  wmcfg = config.services.xserver.windowManager;
in

{
  options = {
    services.xserver.windowManager.select = mkOption {
      type = with types; listOf (enum [ "spectrwm" ]);
    };
  };

  config = mkIf (elem "spectrwm" wmcfg.select) {
    services.xserver.windowManager = {
      session = [{
        name = "spectrwm";
        start = ''
          ${pkgs.spectrwm}/bin/spectrwm &
          waitPID=$!
        '';
      }];
    };
    environment.systemPackages = [ pkgs.spectrwm ];
  };
}
