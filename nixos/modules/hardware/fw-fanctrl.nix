{
  config,
  lib,
  pkgs,
  ...
}:
let
  configFormat = pkgs.formats.json { };
  cfg = config.hardware.fw-fanctrl;
in
{
  imports = [
    (lib.mkRemovedOptionModule
      [
        "hardware"
        "fw-fanctrl"
        "ectoolPackage"
      ]
      "The underlying tool has been changed from fw-ectool to framework-tool, which is now configurable via hardware.fw-fanctrl.frameworkToolPackage."
    )
  ];

  options.hardware.fw-fanctrl = {
    enable = lib.mkEnableOption "the fw-fanctrl systemd service and install the needed packages";

    package = lib.mkPackageOption pkgs "fw-fanctrl" { };

    frameworkToolPackage = lib.mkPackageOption pkgs "framework-tool" { };

    disableBatteryTempCheck = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Disable checking battery temperature sensor
      '';
    };

    config = lib.mkOption {
      default = { };
      description = ''
        Additional config entries for the fw-fanctrl service (documentation: <https://github.com/TamtamHero/fw-fanctrl/blob/main/doc/configuration.md>)
      '';
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf configFormat.type;
        options = {
          defaultStrategy = lib.mkOption {
            type = lib.types.str;
            default = "lazy";
            description = "Default strategy to use";
          };

          strategyOnDischarging = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Default strategy on discharging";
          };

          strategies = lib.mkOption {
            default = { };
            description = ''
              Additional strategies which can be used by fw-fanctrl
            '';
            type = lib.types.attrsOf (
              lib.types.submodule {
                options = {
                  fanSpeedUpdateFrequency = lib.mkOption {
                    type = lib.types.ints.unsigned;
                    default = 5;
                    description = "How often the fan speed should be updated in seconds";
                  };

                  movingAverageInterval = lib.mkOption {
                    type = lib.types.ints.unsigned;
                    default = 25;
                    description = "Interval (seconds) of the last temperatures to use to calculate the average temperature";
                  };

                  speedCurve = lib.mkOption {
                    default = [ ];
                    description = "How should the speed curve look like";
                    type = lib.types.listOf (
                      lib.types.submodule {
                        options = {
                          temp = lib.mkOption {
                            type = lib.types.int;
                            default = 0;
                            description = "Temperature in °C at which the fan speed should be changed";
                          };

                          speed = lib.mkOption {
                            type = lib.types.ints.between 0 100;
                            default = 0;
                            description = "Percent how fast the fan should run at";
                          };

                        };
                      }
                    );
                  };
                };
              }
            );
          };
        };
      };
    };
  };

  config =
    let
      defaultConfig = builtins.fromJSON (builtins.readFile "${cfg.package}/share/fw-fanctrl/config.json");
      finalConfig = lib.attrsets.recursiveUpdate defaultConfig cfg.config;
      configFile = configFormat.generate "custom.json" finalConfig;
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = [
        cfg.package
        cfg.frameworkToolPackage
      ];

      systemd.services.fw-fanctrl = {
        description = "Framework Fan Controller";
        after = [ "multi-user.target" ];
        serviceConfig = {
          Type = "simple";
          Restart = "always";
          ExecStart = "${lib.getExe cfg.package} --output-format JSON run --config ${configFile} --silent ${lib.optionalString cfg.disableBatteryTempCheck "--no-battery-sensors"}";
          ExecStopPost = "${lib.getExe cfg.frameworkToolPackage} --autofanctrl";
        };
        wantedBy = [ "multi-user.target" ];
      };

      systemd.services.fw-fanctrl-suspend = {
        description = "Framework Fan Controller sleep hook";
        before = [ "sleep.target" ];
        after = [ "fw-fanctrl.service" ];
        requires = [ "fw-fanctrl.service" ];
        wantedBy = [ "sleep.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${lib.getExe cfg.package} pause";
          ExecStop = "${lib.getExe cfg.package} resume";
        };
      };
    };

  meta = {
    maintainers = [ lib.maintainers.Svenum ];
  };
}
