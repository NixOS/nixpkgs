{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.spectrwm;
in

{
  options = {
    services.xserver.windowManager.spectrwm.enable = lib.mkEnableOption "spectrwm";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.windowManager = {
      session = [
        {
          name = "spectrwm";
          start = ''
            ${pkgs.spectrwm}/bin/spectrwm &
            waitPID=$!
          '';
        }
      ];
    };
    environment.systemPackages = [ pkgs.spectrwm ];
  };
}
