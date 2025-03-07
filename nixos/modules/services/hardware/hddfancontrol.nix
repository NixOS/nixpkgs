{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.hddfancontrol;
in

{
  meta.maintainers = with lib.maintainers; [ philipwilk ];

  imports = [
    (lib.mkRemovedOptionModule [
      "services"
      "hddfancontrol"
      "smartctl"
    ] "Smartctl is now automatically used when necessary, which makes this option redundant")
  ];

  options = {
    services.hddfancontrol.enable = lib.mkEnableOption "hddfancontrol daemon";

    services.hddfancontrol.disks = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      description = ''
        Drive(s) to get temperature from
      '';
      example = [ "/dev/sda" ];
    };

    services.hddfancontrol.pwmPaths = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      description = ''
        PWM filepath(s) to control fan speed (under /sys), followed by initial and fan-stop PWM values
      '';
      example = [ "/sys/class/hwmon/hwmon2/pwm1:30:10" ];
    };

    services.hddfancontrol.logVerbosity = lib.mkOption {
      type = lib.types.enum [
        "TRACE"
        "DEBUG"
        "INFO"
        "WARN"
        "ERROR"
      ];
      default = "INFO";
      description = ''
        Verbosity of the log level
      '';
    };

    services.hddfancontrol.extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Extra commandline arguments for hddfancontrol
      '';
      example = [
        "--min-fan-speed-prct=10"
        "--interval=1min"
      ];
    };
  };

  config = lib.mkIf cfg.enable (
    let
      args = lib.concatLists [
        [ "-d" ]
        cfg.disks
        [ "-p" ]
        cfg.pwmPaths
        cfg.extraArgs
      ];
    in
    {
      systemd.packages = [ pkgs.hddfancontrol ];

      hardware.sensor.hddtemp = {
        enable = true;
        drives = cfg.disks;
      };

      systemd.services.hddfancontrol = {
        wantedBy = [ "multi-user.target" ];
        environment = {
          HDDFANCONTROL_LOG_LEVEL = cfg.logVerbosity;
          HDDFANCONTROL_DAEMON_ARGS = lib.escapeShellArgs args;
        };
      };
    }
  );
}
