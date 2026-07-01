{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.xserver.desktopManager.emulationstation;

in
{
  options.services.xserver.desktopManager.emulationstation = {
    enable = mkEnableOption "EmulationStation";

    package = mkPackageOption pkgs "emulationstation" {
      example = "emulationstation";
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [
        "--force-kiosk"
        "--debug"
      ];
      description = "Extra arguments to pass to EmulationStation.";
    };
  };

  config = mkIf cfg.enable {
    services.xserver.desktopManager.session = [
      {
        name = "EmulationStation";
        start = ''
          ${cfg.package}/bin/emulationstation -f ${escapeShellArgs cfg.extraArgs} &
          waitPID=$!
        '';
      }
    ];

    environment.systemPackages = [ cfg.package ];
  };

  meta.maintainers = with maintainers; [ hlad ];
}
