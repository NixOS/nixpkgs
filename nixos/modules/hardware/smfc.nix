{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware.smfc;
  format = pkgs.formats.ini {
    listToValue = lib.concatMapStringsSep "\n " toString;
  };
  configFile = format.generate "smfc.conf" cfg.settings;
  debugLevels = {
    "none" = 0;
    "error" = 1;
    "config" = 2;
    "info" = 3;
    "debug" = 4;
  };
in
{
  meta.maintainers = with lib.maintainers; [ poelzi ];

  options.hardware.smfc = {
    enable = lib.mkEnableOption "fan control for Supermicro mainboards";
    package = lib.mkPackageOption pkgs "smfc" { };

    restartMc = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Restart management controller before starting fan control.";
    };

    extraArgs = lib.mkOption {
      description = "Additional arguments passed to the daemon.";
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };

    debug = lib.mkOption {
      description = "Log level: `\"none\"` (0), `\"error\"` (1), `\"config\"` (2), `\"info\"` (3), `\"debug\"` (4).";
      type = lib.types.enum [
        "none"
        "error"
        "config"
        "info"
        "debug"
      ];
      default = "error";
    };

    settings = lib.mkOption {
      description = ''
        Configuration for smfc, written to `smfc.conf` in INI format.
        See <https://github.com/petersulyok/smfc> for available options.
      '';
      default = { };
      type = lib.types.submodule {
        freeformType = format.type;
        options = {
          Ipmi = {
            command = lib.mkOption {
              type = lib.types.str;
              default = lib.getExe pkgs.ipmitool;
              defaultText = lib.literalExpression "lib.getExe pkgs.ipmitool";
              description = "Path for ipmitool command.";
            };
            fan_mode_delay = lib.mkOption {
              type = lib.types.int;
              default = 10;
              description = "Delay time after changing IPMI fan mode (seconds).";
            };
            fan_level_delay = lib.mkOption {
              type = lib.types.int;
              default = 2;
              description = "Delay time after changing IPMI fan level (seconds).";
            };
          };

          "CPU zone" = {
            enabled = lib.mkOption {
              type = lib.types.int;
              default = 0;
              description = "Fan controller enabled (0=no, 1=yes).";
            };
            ipmi_zone = lib.mkOption {
              type = lib.types.str;
              default = "0";
              description = "IPMI zone(s) (comma- or space-separated list of int).";
            };
            temp_calc = lib.mkOption {
              type = lib.types.enum [
                0
                1
                2
              ];
              default = 1;
              description = "Calculation method for CPU temperatures (0=minimum, 1=average, 2=maximum).";
            };
            steps = lib.mkOption {
              type = lib.types.int;
              default = 6;
              description = "Discrete steps in mapping of temperatures to fan level.";
            };
            sensitivity = lib.mkOption {
              type = lib.types.float;
              default = 3.0;
              description = "Threshold in temperature change before the fan controller reacts (C).";
            };
            polling = lib.mkOption {
              type = lib.types.int;
              default = 2;
              description = "Polling time interval for reading temperature (seconds).";
            };
            min_temp = lib.mkOption {
              type = lib.types.float;
              default = 30.0;
              description = "Minimum CPU temperature (C).";
            };
            max_temp = lib.mkOption {
              type = lib.types.float;
              default = 60.0;
              description = "Maximum CPU temperature (C).";
            };
            min_level = lib.mkOption {
              type = lib.types.int;
              default = 35;
              description = "Minimum CPU fan level (%).";
            };
            max_level = lib.mkOption {
              type = lib.types.int;
              default = 100;
              description = "Maximum CPU fan level (%).";
            };
          };

          "HD zone" = {
            enabled = lib.mkOption {
              type = lib.types.int;
              default = 0;
              description = "Fan controller enabled (0=no, 1=yes).";
            };
            ipmi_zone = lib.mkOption {
              type = lib.types.str;
              default = "1";
              description = "IPMI zone(s) (comma- or space-separated list of int).";
            };
            temp_calc = lib.mkOption {
              type = lib.types.enum [
                0
                1
                2
              ];
              default = 1;
              description = "Calculation of HD temperatures (0=minimum, 1=average, 2=maximum).";
            };
            steps = lib.mkOption {
              type = lib.types.int;
              default = 4;
              description = "Discrete steps in mapping of temperatures to fan level.";
            };
            sensitivity = lib.mkOption {
              type = lib.types.float;
              default = 2.0;
              description = "Threshold in temperature change before the fan controller reacts (C).";
            };
            polling = lib.mkOption {
              type = lib.types.int;
              default = 10;
              description = "Polling interval for reading temperature (seconds).";
            };
            min_temp = lib.mkOption {
              type = lib.types.float;
              default = 32.0;
              description = "Minimum HD temperature (C).";
            };
            max_temp = lib.mkOption {
              type = lib.types.float;
              default = 46.0;
              description = "Maximum HD temperature (C).";
            };
            min_level = lib.mkOption {
              type = lib.types.int;
              default = 35;
              description = "Minimum HD fan level (%).";
            };
            max_level = lib.mkOption {
              type = lib.types.int;
              default = 100;
              description = "Maximum HD fan level (%).";
            };
            smartctl_path = lib.mkOption {
              type = lib.types.str;
              default = lib.getExe pkgs.smartmontools;
              defaultText = lib.literalExpression "lib.getExe pkgs.smartmontools";
              description = "Path for smartctl command.";
            };
            standby_guard_enabled = lib.mkOption {
              type = lib.types.int;
              default = 0;
              description = "Standby guard feature for RAID arrays (0=no, 1=yes).";
            };
            standby_hd_limit = lib.mkOption {
              type = lib.types.int;
              default = 1;
              description = "Number of HDs already in STANDBY state before the full RAID array will be forced to it.";
            };
          };

          "GPU zone" = {
            enabled = lib.mkOption {
              type = lib.types.int;
              default = 0;
              description = "Fan controller enabled (0=no, 1=yes).";
            };
            ipmi_zone = lib.mkOption {
              type = lib.types.str;
              default = "1";
              description = "IPMI zone(s) (comma- or space-separated list of int).";
            };
            temp_calc = lib.mkOption {
              type = lib.types.enum [
                0
                1
                2
              ];
              default = 1;
              description = "Calculation of GPU temperatures (0=minimum, 1=average, 2=maximum).";
            };
            steps = lib.mkOption {
              type = lib.types.int;
              default = 5;
              description = "Discrete steps in mapping of temperatures to fan level.";
            };
            sensitivity = lib.mkOption {
              type = lib.types.float;
              default = 2.0;
              description = "Threshold in temperature change before the fan controller reacts (C).";
            };
            polling = lib.mkOption {
              type = lib.types.int;
              default = 2;
              description = "Polling interval for reading temperature (seconds).";
            };
            min_temp = lib.mkOption {
              type = lib.types.float;
              default = 40.0;
              description = "Minimum GPU temperature (C).";
            };
            max_temp = lib.mkOption {
              type = lib.types.float;
              default = 70.0;
              description = "Maximum GPU temperature (C).";
            };
            min_level = lib.mkOption {
              type = lib.types.int;
              default = 35;
              description = "Minimum GPU zone fan level (%).";
            };
            max_level = lib.mkOption {
              type = lib.types.int;
              default = 100;
              description = "Maximum GPU zone fan level (%).";
            };
            gpu_device_ids = lib.mkOption {
              type = lib.types.str;
              default = "0";
              description = "GPU device IDs (comma- or space-separated list of int). Indices in nvidia-smi temperature report.";
            };
            nvidia_smi_path = lib.mkOption {
              type = lib.types.str;
              default = "/run/current-system/sw/bin/nvidia-smi";
              description = ''
                Path for nvidia-smi command.
                Defaults to the system-wide nvidia-smi path since the nvidia driver is typically
                installed via `hardware.nvidia` and not available as a standalone package.
              '';
            };
          };

          "CONST zone" = {
            enabled = lib.mkOption {
              type = lib.types.int;
              default = 0;
              description = "Fan controller enabled (0=no, 1=yes).";
            };
            ipmi_zone = lib.mkOption {
              type = lib.types.str;
              default = "1";
              description = "IPMI zone(s) (comma- or space-separated list of int).";
            };
            polling = lib.mkOption {
              type = lib.types.int;
              default = 30;
              description = "Polling interval for checking/resetting level if needed (seconds).";
            };
            level = lib.mkOption {
              type = lib.types.int;
              default = 50;
              description = "Constant fan level (%).";
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.smfc = {
      wantedBy = [ "multi-user.target" ];
      description = "Supermicro fan control";
      serviceConfig = {
        Type = "exec";
        ExecStartPre = lib.mkIf cfg.restartMc "${cfg.package}/bin/ipmi_bmc_reset.sh";
        ExecStart = "${lib.getExe cfg.package} -o 2 -l ${
          toString debugLevels.${cfg.debug}
        } -c ${configFile} ${lib.escapeShellArgs cfg.extraArgs}";
        Restart = "on-failure";
        RestartSec = 5;
      };
      path = [ cfg.package ];
    };
  };
}
