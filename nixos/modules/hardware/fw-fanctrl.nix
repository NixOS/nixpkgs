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
    (lib.mkRemovedOptionModule [
      "hardware"
      "fw-fanctrl"
      "ectoolPackage"
    ] "This option was removed. Use `hardware.fw-fanctrl.frameworkToolPackage` instead.")
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

    keepDefaultStrategies = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Keep the default strategies of the fw-fanctrl package.
        Set this to false if you only want to see your own strategies defined with `hardware.fw-fanctrl.config.strategies`
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
                            type = lib.types.either lib.types.float lib.types.int;
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
      defaultConfig =
        if cfg.keepDefaultStrategies then
          builtins.fromJSON (builtins.readFile "${cfg.package}/share/fw-fanctrl/config.json")
        else
          { };
      finalConfig = lib.attrsets.recursiveUpdate defaultConfig cfg.config;
      configFile = configFormat.generate "custom.json" finalConfig;

      fw-fanctrl =
        if cfg.frameworkToolPackage == pkgs.framework-tool then
          cfg.package
        else
          cfg.package.override { inherit (cfg) frameworkToolPackage; };
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = [
        fw-fanctrl
        cfg.frameworkToolPackage
      ];

      systemd.services = {
        fw-fanctrl = {
          description = "Framework Fan Controller";
          after = [ "multi-user.target" ];
          serviceConfig = {
            Type = "simple";
            Restart = "always";
            ExecStart = "${lib.getExe fw-fanctrl} --output-format JSON run --config ${configFile} --silent ${lib.optionalString cfg.disableBatteryTempCheck "--no-battery-sensors"}";
            ExecStopPost = "${lib.getExe cfg.frameworkToolPackage} --autofanctrl";
          };
          wantedBy = [ "multi-user.target" ];
        };

        fw-fanctrl-suspend = {
          description = "Framework Fan Controller sleep hook";
          before = [ "sleep.target" ];
          unitConfig = {
            StopWhenUnneeded = "yes";
          };
          requires = [ "fw-fanctrl.service" ];
          after = [ "fw-fanctrl.service" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = "yes";
            ExecStart = "${lib.getExe fw-fanctrl} pause";
            ExecStop = "${lib.getExe fw-fanctrl} resume";
          };
          wantedBy = [ "sleep.target" ];
        };
      };
    };

  meta = {
    maintainers = [ lib.maintainers.Svenum ];
  };
}
