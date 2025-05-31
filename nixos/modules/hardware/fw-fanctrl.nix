{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hardware.fw-fanctrl;
in
{
  options.hardware.fw-fanctrl = {
    enable = lib.mkEnableOption "the fw-fanctrl systemd service and install the needed packages";

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
        Config for the fw-fanctrl service (documentation: https://github.com/TamtamHero/fw-fanctrl/blob/main/doc/configuration.md)
      '';
      type = lib.types.submodule {
        options = {
          defaultStrategy = lib.mkOption {
            type = lib.types.str;
            default = "";
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
              Strategies which can be used by fw-fanctrl
            '';
            type = lib.types.attrsOf (
              lib.types.submodule (
                { name, ... }:
                {
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
              )
            );
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      fw-fanctrl
      fw-ectool
    ];

    environment.etc."fw-fanctrl/config.json" = {
      text = lib.mkIf (cfg.config != { }) (builtins.toJSON cfg.config);
      source = lib.mkIf (cfg.config == { }) "${pkgs.fw-fanctrl}/share/fw-fanctrl/config.json";
    };

    systemd.services.fw-fanctrl = {
      path = [ pkgs.fw-ectool ];
      description = "Framework Fan Controller";
      after = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        ExecStart = "${lib.getExe pkgs.fw-fanctrl} --output-format JSON run --config /etc/fw-fanctrl/config.json --silent ${lib.optionalString cfg.disableBatteryTempCheck "--no-battery-sensors"}";
        ExecStopPost = "${lib.getExe pkgs.fw-ectool} autofanctrl";
      };
      wantedBy = [ "multi-user.target" ];
    };

    # Create suspend config
    environment.etc."systemd/system-sleep/fw-fanctrl-suspend.sh".source =
      "${pkgs.fw-fanctrl}/share/fw-fanctrl/fw-fanctrl-suspend";
  };

  meta = {
    maintainers = pkgs.fw-fanctrl.meta.maintainers;
  };
}
