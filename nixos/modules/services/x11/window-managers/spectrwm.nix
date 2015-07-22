
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.spectrwm;
in

{
  options = {
    services.xserver.windowManager.spectrwm = {
      enable = mkOption {
        default = false;
        example = true;
        description = "Enable the spectrwm window manager.";
      };
    };
  };

  config = mkIf cfg.enable {
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
