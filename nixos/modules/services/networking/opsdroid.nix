{ config, lib, pkgs, ... }:

with lib;

let
  inherit (lib) mkEnableOption mkPackageOption mkOption;
  cfg = config.services.opsdroid;
  yaml = pkgs.formats.yaml { };
  settingsFile = yaml.generate "opsdroid.yaml" cfg.settings;
in
{
  meta.maintainers = [ lib.maintainers.raitobezarius ];
  options.services.opsdroid = {
    enable = mkEnableOption "opsdroid, bot framework";
    package = mkPackageOption pkgs "opsdroid" { };
    secretsFile = mkOption {
      type = types.path;
      description = ''
        A file containing multiple environment variable
        declarations that contains secrets which will
        be substituted in the YAML configuration file.
      '';
    };

    settings = mkOption {
      type = yaml.type;
      default = {};
      description = ''
        Configuration for the Opsdroid bot framework.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.opsdroid = {
      description = "opsdroid - a general chat bot framework written in Python";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      preStart = ''
        umask 0077
        ${lib.getExe pkgs.envsubst} -i ${settingsFile} -o ''${RUNTIME_DIRECTORY}/config.yml
      '';

      serviceConfig = {
        EnvironmentFile = [ cfg.secretsFile ];
        ExecStart = "${cfg.package}/bin/opsdroid start -f  \${RUNTIME_DIRECTORY}/config.yml";
        DynamicUser = true;
        StateDirectory = "opsdroid";
        RuntimeDirectory = "opsdroid";
        Restart = "on-failure";
        RestartSec = "30s";
      };
    };
  };
}
