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
  options.services.xserver.windowManager.spectrwm = {
    enable = lib.mkEnableOption "spectrwm";
    package = lib.mkPackageOption pkgs "spectrwm" { };
  };

  config = lib.mkIf cfg.enable {
    services.xserver.windowManager = {
      session = [
        {
          name = "spectrwm";
          start = ''
            ${cfg.package}/bin/spectrwm &
            waitPID=$!
          '';
        }
      ];
    };
    environment.systemPackages = [ cfg.package ];
  };
}
