{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.fan2go;
  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "config.yaml" cfg.settings;
in
{
  options.services.fan2go = {
    enable = lib.mkEnableOption "fan2go";

    package = lib.mkPackageOption pkgs "fan2go" { };

    settings = lib.mkOption {
      type = settingsFormat.type;
      example = {
        fans = [
          {
            id = "cpu";
            hwmon = {
              platform = "nct6798";
              rpmChannel = 1;
              pwmChannel = 1;
            };
            neverStop = true;
            curve = "cpu_curve";
          }
        ];
        sensors = [
          {
            id = "cpu_package";
            hwmon = {
              platform = "coretemp";
              index = 1;
            };
          }
        ];
        curves = [
          {
            id = "cpu_curve";
            linear = {
              sensor = "cpu_package";
              min = 40;
              max = 80;
            };
          }
        ];
      };
      description = ''
        Contents of the fan2go YAML config.
        Please refer to the [documentation](https://github.com/markusressel/fan2go/blob/master/README.md#configuration).
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.fan2go = {
      description = "fan2go daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''
          ${lib.getExe cfg.package} -c ${configFile}
        '';

        Restart = "always";
        RestartSec = "1s";
        Type = "simple";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ BonusPlay ];
}
