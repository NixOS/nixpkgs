{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.tp-auto-kbbl;

in
{
  meta.maintainers = with lib.maintainers; [ sebtm ];

  options = {
    services.tp-auto-kbbl = {
      enable = lib.mkEnableOption "auto toggle keyboard back-lighting on Thinkpads (and maybe other laptops) for Linux";

      package = lib.mkPackageOption pkgs "tp-auto-kbbl" { };

      arguments = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = ''
          List of arguments appended to `./tp-auto-kbbl --device [device] [arguments]`
        '';
      };

      device = lib.mkOption {
        type = lib.types.str;
        default = "/dev/input/event0";
        description = "Device watched for activities.";
      };

    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.tp-auto-kbbl = {
      serviceConfig = {
        ExecStart = lib.concatStringsSep " " (
          [
            "${cfg.package}/bin/tp-auto-kbbl"
            "--device ${cfg.device}"
          ]
          ++ cfg.arguments
        );
        Restart = "always";
        Type = "simple";
      };

      unitConfig = {
        Description = "Auto toggle keyboard backlight";
        Documentation = "https://github.com/saibotd/tp-auto-kbbl";
        After = [ "dbus.service" ];
      };

      wantedBy = [ "multi-user.target" ];
    };
  };
}
