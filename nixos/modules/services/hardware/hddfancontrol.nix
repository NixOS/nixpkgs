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

    services.hddfancontrol.settings = lib.mkOption {
      type = lib.types.attrsWith {
        placeholder = "drive-bay-name";
        elemType = (
          lib.types.submodule (
            { ... }:
            {
              options = {
                disks = lib.mkOption {
                  type = lib.types.listOf lib.types.path;
                  default = [ ];
                  description = ''
                    Drive(s) to get temperature from
                  '';
                  example = [ "/dev/sda" ];
                };

                pwmPaths = lib.mkOption {
                  type = lib.types.listOf lib.types.path;
                  default = [ ];
                  description = ''
                    PWM filepath(s) to control fan speed (under /sys), followed by initial and fan-stop PWM values
                  '';
                  example = [ "/sys/class/hwmon/hwmon2/pwm1:30:10" ];
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
        serviceConfig = {
          ExecStart = "${lib.getExe pkgs.hddfancontrol} -v ${cnf.logVerbosity} daemon ${lib.escapeShellArgs (args cnf)}";

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
      systemd.packages = [ pkgs.hddfancontrol ];

      hardware.sensor.hddtemp = {
        enable = true;
        drives = lib.lists.flatten (lib.attrsets.catAttrs "disks" (lib.attrsets.attrValues cfg.settings));
      };

      systemd.services = services;
    }
  );
}
