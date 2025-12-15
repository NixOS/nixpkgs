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
    (lib.mkRemovedOptionModule [
      "services"
      "hddfancontrol"
      "disks"
    ] "Disks should now be specified per hddfancontrol instance in its attrset")
    (lib.mkRemovedOptionModule [
      "services"
      "hddfancontrol"
      "pwmPaths"
    ] "Pwm Paths should now be specified per hddfancontrol instance in its attrset")
    (lib.mkRemovedOptionModule [
      "services"
      "hddfancontrol"
      "logVerbosity"
    ] "Log Verbosity should now be specified per hddfancontrol instance in its attrset")
    (lib.mkRemovedOptionModule [
      "services"
      "hddfancontrol"
      "extraArgs"
    ] "Extra Args should now be specified per hddfancontrol instance in its attrset")
  ];

  options = {
    services.hddfancontrol.enable = lib.mkEnableOption "hddfancontrol daemon";
    services.hddfancontrol.package = lib.mkPackageOption pkgs "hddfancontrol" { };

    services.hddfancontrol.settings = lib.mkOption {
      type = lib.types.attrsWith {
        placeholder = "drive-bay-name";
        elemType = (
          lib.types.submodule (
            { ... }:
            {
              options = {
                disks = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  default = [ ];
                  description = ''
                    Drive(s) to get temperature from

                    Can also use command substitution to automatically grab all matching drives; such as all scsi (sas) drives
                  '';
                  example = [
                    "/dev/sda"
                    "`find /dev/disk/by-id -name \"scsi*\" -and -not -name \"*-part*\" -printf \"%p \"`"
                  ];
                };

                pwmPaths = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  default = [ ];
                  description = ''
                    PWM filepath(s) to control fan speed (under /sys), followed by initial and fan-stop PWM values
                    Can also use command substitution to ensure the correct hwmonX is selected on every boot
                  '';
                  example = [
                    "/sys/class/hwmon/hwmon2/pwm1:30:10"
                    "`echo /sys/devices/platform/nct6775.656/hwmon/hwmon[[:print:]]`/pwm4:80:20"
                  ];
                };

                logVerbosity = lib.mkOption {
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

                extraArgs = lib.mkOption {
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
            }
          )
        );
      };
      default = { };
      description = ''
        Parameter-sets for each instance of hddfancontrol.
      '';
      example = lib.literalExpression ''
        {
          harddrives = {
            disks = [
              "/dev/sda"
              "/dev/sdb"
              "/dev/sdc"
            ];
            pwmPaths = [
              "/sys/class/hwmon/hwmon1/pwm1:25:10"
            ];
            logVerbosity = "DEBUG";
          };
          ssddrives = {
            disks = [
              "/dev/sdd"
              "/dev/sde"
              "/dev/sdf"
            ];
            pwmPaths = [
              "/sys/class/hwmon/hwmon1/pwm2:25:10"
            ];
            extraArgs = [
              "--interval=30s"
            ];
          };
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable (
    let
      args =
        cnf:
        lib.concatLists [
          [ "-d" ]
          cnf.disks
          [ "-p" ]
          cnf.pwmPaths
          cnf.extraArgs
        ];

      createService = cnf: {
        description = "HDD fan control";
        documentation = [ "man:hddfancontrol(1)" ];
        after = [ "hddtemp.service" ];
        wants = [ "hddtemp.service" ];
        script =
          let
            argString = lib.strings.concatStringsSep " " (args cnf);
          in
          "${lib.getExe cfg.package} -v ${cnf.logVerbosity} daemon ${argString}";
        serviceConfig = {
          CPUSchedulingPolicy = "rr";
          CPUSchedulingPriority = 49;

          ProtectSystem = "strict";
          PrivateTmp = true;
          ProtectHome = true;
          SystemCallArchitectures = "native";
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
        };
        wantedBy = [ "multi-user.target" ];
      };

      services = lib.attrsets.mergeAttrsList [
        (lib.attrsets.mapAttrs' (
          name: cnf: lib.nameValuePair "hddfancontrol-${name}" (createService cnf)
        ) cfg.settings)
        {
          "hddfancontrol".enable = false;
        }
      ];
    in
    {
      systemd.packages = [ cfg.package ];

      hardware.sensor.hddtemp = {
        enable = true;
        drives = lib.lists.flatten (lib.attrsets.catAttrs "disks" (lib.attrsets.attrValues cfg.settings));
      };

      systemd.services = services;
    }
  );
}
