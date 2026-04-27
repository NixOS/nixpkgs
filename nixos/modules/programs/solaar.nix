{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.solaar;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    maintainers
    mkPackageOption
    ;
in
{
  options.programs.solaar = {
    enable = mkEnableOption "Solaar, the open source driver for Logitech devices.";

    package = mkPackageOption pkgs "solaar" { };

    userService = {
      enable = mkEnableOption "Enable the solaar systemd service for each user.";

      window = mkOption {
        type = types.enum [
          "show"
          "hide"
          "only"
        ];
        default = "hide";
        description = ''
          Start with window showing / hidden / only (no tray icon).
        '';
      };

      batteryIcons = mkOption {
        type = types.enum [
          "regular"
          "symbolic"
          "solaar"
        ];
        default = "regular";
        description = ''
          Prefer regular battery / symbolic battery / solaar icons.
        '';
      };

      extraArgs = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "--restart-on-wake-up" ];
        description = ''
          Extra arguments to pass to Solaar.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    hardware.logitech.wireless.enable = true;
    environment.systemPackages = [ cfg.package ];

    systemd.user.services.solaar = mkIf cfg.userService.enable {
      description = "Solaar, the open source driver for Logitech devices";
      wantedBy = [ "graphical-session.target" ];
      after = [ "dbus.service" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getExe cfg.package} --window ${cfg.window} --battery-icons ${cfg.batteryIcons} ${lib.strings.join " " cfg.extraArgs}";
        Restart = "on-failure";
        RestartSec = "5";
      };
    };
  };

  meta = {
    maintainers = [ maintainers.Svenum ];
  };
}
