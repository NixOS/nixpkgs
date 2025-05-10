{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.hardware.smfc;
in
let
  smConfig = pkgs.writeText "smfc.conf" (
    lib.generators.toINI { } {
      "Ipmi" = cfg.ipmi;
      "CPU zone" = cfg.cpuZone // {
        count = (length cfg.cpuZone.hwmon_path or 0);
        hwmon_path = (lib.strings.concatStringsSep "\n " cfg.cpuZone.hwmon_path);
      };
      "HD zone" = cfg.hdZone // {
        count = (length cfg.hdZone.hd_names or 0);
        hd_names = (lib.strings.concatStringsSep "\n " cfg.hdZone.hd_names);
      };
    }
  );
in
{
  meta.maintainers = with maintainers; [ poelzi ];

  options.hardware.smfc = {
    enable = mkEnableOption "fan control for servermicro mainboards";
    package = mkPackageOption pkgs "smfc" { };

    restartMc = mkOption {
      default = false;
      type = types.bool;
      description = "Restart managment controller before starting fan control";
    };

    extraArgs = mkOption {
      description = "Additional arguments passed to the daemon.";
      type = types.listOf types.str;
      default = [ ];
    };

    debug = mkOption {
      description = "Debug level. 0-NONE, 1-ERROR(default), 2-CONFIG, 3-INFO, 4-DEBUG";
      type = types.int;
      default = 1;
    };

    ipmi = mkOption {
      description = "IPMI / general settings";
      type = types.attrs;
      default = { };
      example = literalExpression ''
        {
          # Delay time after changing IPMI fan mode (int, seconds, default=10)
          fan_mode_delay = 10;
          # Delay time after changing IPMI fan level (int, seconds, default=2)
          fan_level_delay = 2;
          # CPU and HD zones are swapped (bool, default=0).
          swapped_zones = 0;
        }
      '';
    };
    cpuZone = mkOption {
      description = "CPU temperature configuration";
      type = types.attrs;
      default = { };
      example = literalExpression ''
        {
          # Fan controller enabled (bool, default=0)
          enabled = 1;
          # Calculation method for CPU temperatures (int, [0-minimum, 1-average, 2-maximum], default=1)
          temp_calc = 1;
          # Discrete steps in mapping of temperatures to fan level (int, default=6)
          steps = 6;
          # Threshold in temperature change before the fan controller reacts (float, C, default=3.0)
          sensitivity = 3.0;
          # Polling time interval for reading temperature (int, sec, default=2)
          polling = 2;
          # Minimum CPU temperature (float, C, default=30.0)
          min_temp = 30.0;
          # Maximum CPU temperature (float, C, default=60.0)
          max_temp = 60.0;
          # Minimum CPU fan level (int, %, default=35)
          min_level = 35;
          # Maximum CPU fan level (int, %, default=100)
          max_level = 100;
          # Path for CPU sys/hwmon file(s) (str multi-line list, default=/sys/devices/platform/coretemp.0/hwmon/hwmon*/temp1_input)
          # It will be automatically generated for Intel CPUs and must be specified for AMD CPUs.
          hwmon_path=[ "/sys/devices/platform/coretemp.0/hwmon/hwmon*/temp1_input"
                       "/sys/devices/platform/coretemp.1/hwmon/hwmon*/temp1_input"];
          # for AMD
          # hwmon_path=/sys/bus/pci/drivers/k10temp/0000*/hwmon/hwmon*/temp1_input
        }
      '';
    };
    hdZone = mkOption {
      description = "List of controllers with their configurations.";
      type = types.attrs;
      default = { };
      example = literalExpression ''
        {
          # Fan controller enabled (bool, default=0)
          enabled = 1;
          # Calculation of HD temperatures (int, [0-minimum, 1-average, 2-maximum], default=1)
          temp_calc = 1;
          # Discrete steps in mapping of temperatures to fan level (int, default=4)
          steps = 4;
          # Threshold in temperature change before the fan controller reacts (float, C, default=2.0)
          sensitivity = 2.0;
          # Polling interval for reading temperature (int, sec, default=10)
          polling = 10;
          # Minimum HD temperature (float, C, default=32.0)
          min_temp = 32.0;
          # Maximum HD temperature (float, C, default=46.0)
          max_temp = 46.0;
          # Minimum HD fan level (int, %, default=35)
          min_level = 35;
          # Maximum HD fan level (int, %, default=100)
          max_level = 100;
          # Names of the HDs (str multi-line list, default=)
          # These names MUST BE specified in '/dev/disk/by-id/...' form!
          hd_names= [ "" ]
          # List of files in /sys/hwmon file system or 'hddtemp' (str multi-line list, default=)
          # It will be automatically generated for SATA disks based on the disk names.
          # Use `hddtemp` for SCSI disk or for other disks incompatible with `drivetemp` module.
          # hwmon_path=[ "/sys/class/scsi_disk/0:0:0:0/device/hwmon/hwmon*/temp1_input"
          #              "/sys/class/scsi_disk/1:0:0:0/device/hwmon/hwmon*/temp1_input"
          #              "hddtemp" ];
          # Standby guard feature for RAID arrays (bool, default=0)
          standby_guard_enabled = 0;
          # Number of HDs already in STANDBY state before the full RAID array will be forced to it (int, default=1)
          standby_hd_limit = 1;
        }
      '';
    };
  };

  config = mkIf cfg.enable {
    # environment.etc."smfc/smfc.conf".text
    # smConfig = pkgs.writeText "smfc.conf" (lib.generators.toINI {
    #   mkKeyValue = k: v:
    #     let mkKeyValue = mkKeyValueDefault { inherit mkValueString; } " = " k;
    #     in concatStringsSep "\n" (map (kv: "\t" + mkKeyValue kv) (toList v));
    # } {
    environment.systemPackages = [ cfg.package ];

    systemd = {
      # packages = [ cfg.package ];
      # targets.multi-user.wants = [ "switcheroo-control.service" ];
      services.smfc = {
        wantedBy = [ "multi-user.target" ];
        description = "Supermicro fan control";
        serviceConfig = {
          Type = "exec";
          ExecStartPre = lib.strings.optionalString cfg.restartMc ''
            echo 1 | ${cfg.package}/bin/ipmi_bmc_reset.sh
          '';
          ExecStart = "${cfg.package}/bin/smfc -o 1 -l ${toString cfg.debug} -c ${smConfig} ${lib.escapeShellArgs cfg.extraArgs}";
          Restart = "on-failure";
          RestartSec = 5;
        };
        # disksup requires bash
        path = [ cfg.package ];
      };
    };
    # services.udev.packages = [ cfg.package ];
  };
}
