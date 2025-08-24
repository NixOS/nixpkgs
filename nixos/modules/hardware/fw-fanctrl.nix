{
  config,
  lib,
  pkgs,
  ...
}:
let
  configFormat = pkgs.formats.json { };
  cfg = config.hardware.fw-fanctrl;

  # Validate temperature string format and range
  isValidTemperatureString =
    s:
    builtins.match "^[0-9]+(\\.[0-9]{1,2})?$" s != null
    && (builtins.fromJSON s) >= 0
    && (builtins.fromJSON s) <= 100;

  # Temperature type that accepts integers or strings with up to 2 decimal places
  # Strings are automatically converted to numbers using coercedTo
  temperatureType =
    lib.types.either (lib.types.ints.between 0 100) (
      lib.types.coercedTo (lib.types.addCheck lib.types.str isValidTemperatureString) (
        s: builtins.fromJSON s
      ) lib.types.number
    )
    // {
      description = "temperature in °C between 0 and 100 (integer or decimal string like \"34.56\")";
    };
in
{
  options.hardware.fw-fanctrl = {
    enable = lib.mkEnableOption "the fw-fanctrl systemd service and install the needed packages";

    package = lib.mkPackageOption pkgs "fw-fanctrl" { };

    ectoolPackage = lib.mkPackageOption pkgs "fw-ectool" { };

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
        Additional config entries for the fw-fanctrl service (documentation: https://github.com/TamtamHero/fw-fanctrl/blob/main/doc/configuration.md)
      '';
      type = lib.types.submodule {
        freeformType = configFormat.type;
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
                            type = temperatureType;
                            default = 0;
                            description = "Temperature in °C between 0-100 (integer or string with up to 2 decimal places, e.g., 35 or \"34.56\")";
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
        cfg.ectoolPackage
      ];

      systemd.services.fw-fanctrl = {
        description = "Framework Fan Controller";
        after = [ "multi-user.target" ];
        serviceConfig = {
          Type = "simple";
          Restart = "always";
          ExecStart = "${lib.getExe cfg.package} --output-format JSON run --config ${configFile} --silent ${lib.optionalString cfg.disableBatteryTempCheck "--no-battery-sensors"}";
          ExecStopPost = "${lib.getExe cfg.ectoolPackage} autofanctrl";
        };
        wantedBy = [ "multi-user.target" ];
      };

      # Create suspend config
      environment.etc."systemd/system-sleep/fw-fanctrl-suspend.sh".source =
        "${cfg.package}/share/fw-fanctrl/fw-fanctrl-suspend";
    };

  meta = {
    maintainers = [ lib.maintainers.Svenum ];
  };
}
