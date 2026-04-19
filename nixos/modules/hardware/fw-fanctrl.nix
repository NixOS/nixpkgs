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
  finalConfig =
    if cfg.keepDefaultStrategies then
      pkgs.runCommand "config.json" { } ''
        ${lib.getExe pkgs.jq} -s '.[0] * .[1]' ${cfg.package}/share/fw-fanctrl/config.json ${userConfig} >$out
      ''
    else
      userConfig;
  fw-fanctrl =
    if cfg.frameworkToolPackage == pkgs.framework-tool then
      cfg.package
    else
      cfg.package.override { inherit (cfg) frameworkToolPackage; };
in
{
  imports = [
    (lib.mkRemovedOptionModule
      [
        "hardware"
        "fw-fanctrl"
        "ectoolPackage"
      ]
      "This option was removed due to depency changes. Use `hardware.fw-fanctrl.frameworkToolPackage` instead."
    )
    (lib.mkRenamedOptionModule
      [ "hardware" "fw-fanctrl" "config" ]
      [ "hardware" "fw-fanctrl" "settings" ]
    )
  ];

  options.hardware.fw-fanctrl = {
    enable = lib.mkEnableOption "the fw-fanctrl systemd service and install the needed packages";

    package = lib.mkPackageOption pkgs "fw-fanctrl" { };
    frameworkToolPackage = lib.mkPackageOption pkgs "framework-tool" { };

    disableBatteryTempCheck = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Disable checking battery temperature sensor
      '';
    };

    keepDefaultStrategies = mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Keep the default strategies of the fw-fanctrl package.
        Set this to false if you only want to see your own strategies defined with `hardware.fw-fanctrl.config.strategies`
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
                            type = types.either types.float types.int;
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
          ExecStart = "${lib.getExe fw-fanctrl} --output-format JSON run --config ${finalConfig} --silent ${lib.optionalString cfg.disableBatteryTempCheck "--no-battery-sensors"}";
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
