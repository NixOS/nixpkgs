{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types mkOption;

  settingsFormat = pkgs.formats.json { };
  cfg = config.hardware.fw-fanctrl;

  userConfig = settingsFormat.generate "user.json" cfg.settings;
  finalConfig = pkgs.runCommand "config.json" { } ''
    ${lib.getExe pkgs.jq} -s '.[0] * .[1]' ${cfg.package}/share/fw-fanctrl/config.json ${userConfig} >$out
  '';
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [ "hardware" "fw-fanctrl" "config" ]
      [ "hardware" "fw-fanctrl" "settings" ]
    )
  ];

  options.hardware.fw-fanctrl = {
    enable = lib.mkEnableOption "the fw-fanctrl systemd service and install the needed packages";

    package = lib.mkPackageOption pkgs "fw-fanctrl" { };

    ectoolPackage = lib.mkPackageOption pkgs "fw-ectool" { };

    disableBatteryTempCheck = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Disable checking battery temperature sensor
      '';
    };

    settings = mkOption {
      default = { };
      description = ''
        Additional config entries for the fw-fanctrl service (documentation: <https://github.com/TamtamHero/fw-fanctrl/blob/main/doc/configuration.md>)
      '';
      type = types.submodule {
        freeformType = types.attrsOf settingsFormat.type;
        options = {
          defaultStrategy = mkOption {
            type = types.str;
            default = "lazy";
            description = "Default strategy to use";
          };

          strategyOnDischarging = mkOption {
            type = types.str;
            default = "";
            description = "Default strategy on discharging";
          };

          strategies = mkOption {
            default = { };
            description = ''
              Additional strategies which can be used by fw-fanctrl
            '';
            type = types.attrsOf (
              types.submodule {
                freeformType = types.attrsOf settingsFormat.type;
                options = {
                  fanSpeedUpdateFrequency = mkOption {
                    type = types.ints.unsigned;
                    default = 5;
                    description = "How often the fan speed should be updated in seconds";
                  };

                  movingAverageInterval = mkOption {
                    type = types.ints.unsigned;
                    default = 25;
                    description = "Interval (seconds) of the last temperatures to use to calculate the average temperature";
                  };

                  speedCurve = mkOption {
                    default = [ ];
                    description = "How should the speed curve look like";
                    type = types.listOf (
                      types.submodule {
                        freeformType = types.attrsOf settingsFormat.type;
                        options = {
                          temp = mkOption {
                            type = types.int;
                            default = 0;
                            description = "Temperature in °C at which the fan speed should be changed";
                          };

                          speed = mkOption {
                            type = types.ints.between 0 100;
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

  config = lib.mkIf cfg.enable {
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
        ExecStart = "${lib.getExe cfg.package} --output-format JSON run --config ${finalConfig} --silent ${lib.optionalString cfg.disableBatteryTempCheck "--no-battery-sensors"}";
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
