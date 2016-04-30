
{ config, lib, pkgs, ... }:

with lib;

let
  wmcfg = config.services.xserver.windowManager;
  cfg = wmcfg.spectrwm;
in

{
  config = mkIf (elem "spectrwm" wmcfg.enable) {
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
