{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hardware.fw-fanctrl;
  defaultConfig = builtins.fromJSON (
    builtins.readFile "${pkgs.fw-fanctrl}/share/fw-fanctrl/config.json"
  );
in
{
  options.hardware.fw-fanctrl = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable fw-fanctrl systemd service and install the needed packages.
      '';
    };
    disableBatteryTempCheck = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Disable checking battery temperature sensor
      '';
    };
    config = {
      defaultStrategy = lib.mkOption {
        type = lib.types.str;
        default = defaultConfig.defaultStrategy;
        description = "Default strategy to use";
      };
      strategyOnDischarging = lib.mkOption {
        type = lib.types.str;
        default = defaultConfig.strategyOnDischarging;
        description = "Default strategy on discharging";
      };
      batteryChargingStatusPath = lib.mkOption {
        type = lib.types.str;
        default = "/sys/class/power_supply/BAT1/status";
        description = "Path to battery status device";
      };
      strategies = lib.mkOption {
        default = defaultConfig.strategies;
        type = lib.types.attrsOf (
          lib.types.submodule (
            { options, name, ... }:
            {
              options = {
                fanSpeedUpdateFrequency = lib.mkOption {
                  type = lib.types.int;
                  default = 5;
                  description = "How often the fan speed should be updated in seconds";
                };
                movingAverageInterval = lib.mkOption {
                  type = lib.types.int;
                  default = 25;
                  description = "Interval (seconds) of the last temperatures to use to calculate the average temperature";
                };
                speedCurve = lib.mkOption {
                  default = [ ];
                  description = "How should the speed curve look like";
                  type = lib.types.listOf (
                    lib.types.submodule (
                      { options, ... }:
                      {
                        options = {
                          temp = lib.mkOption {
                            type = lib.types.int;
                            default = 0;
                            description = "Temperature at which the fan speed should be changed";
                          };
                          speed = lib.mkOption {
                            type = lib.types.int;
                            default = 0;
                            description = "Percent how fast the fan should run at";
                          };
                        };
                      }
                    )
                  );
                };
              };
            }
          )
        );
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Install package
    environment.systemPackages = with pkgs; [
      fw-fanctrl
      fw-ectool
    ];

    # Create config
    environment.etc."fw-fanctrl/config.json" = {
      text = builtins.toJSON cfg.config;
    };

    # Create Service
    systemd.services.fw-fanctrl = {
      description = "Framework Fan Controller";
      after = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        ExecStart = "${pkgs.fw-fanctrl}/bin/fw-fanctrl --output-format \"JSON\" run --config \"/etc/fw-fanctrl/config.json\" --silent ${lib.strings.optionalString cfg.disableBatteryTempCheck "--no-battery-sensors"}";
        ExecStopPost = "${pkgs.fw-ectool}/bin/ectool autofanctrl";
      };
      enable = true;
      wantedBy = [ "multi-user.target" ];
    };

    # Create suspend config
    environment.etc."systemd/system-sleep/fw-fanctrl-suspend.sh".source =
      pkgs.writeShellScript "fw-fanctrl-suspend"
        (
          builtins.replaceStrings
            [ ''/usr/bin/python3 "%PREFIX_DIRECTORY%/bin/fw-fanctrl"'' "/bin/bash" ]
            [ "${pkgs.fw-fanctrl}/bin/fw-fanctrl" "" ]
            (builtins.readFile ../services/system-sleep/fw-fanctrl-suspend)
        );
  };

  meta = {
    maintainers = pkgs.fw-fanctrl.meta.maintainers;
  };
}
