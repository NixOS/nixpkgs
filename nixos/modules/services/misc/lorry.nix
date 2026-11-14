{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.lorry;
  format = pkgs.formats.toml { };
  configFile = format.generate "lorry.toml" cfg.settings;
in
{
  meta.maintainers = with lib.maintainers; [ shymega ];

  options.services.lorry = {
    enable = lib.mkEnableOption "Lorry, a high performance software asset mirroring system";

    package = lib.mkPackageOption pkgs "lorry" { };

    openFirewall = lib.mkEnableOption "opening the firewall for the Lorry HTTP port";

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Environment file for the Lorry service, e.g. one setting
        `LORRY_GITLAB_PRIVATE_TOKEN`, `LORRY_GITHUB_PRIVATE_TOKEN` or
        `LORRY_SMTP_PASSWORD`.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = format.type;

        options = {
          port = lib.mkOption {
            type = lib.types.port;
            default = 3000;
            description = "Port on which Lorry listens for HTTP requests.";
          };

          statedb = lib.mkOption {
            type = lib.types.str;
            default = "/var/lib/lorry/lorry.sqlite3";
            description = "Path to the SQLite database used for mirror scheduling and history.";
          };

          working-area = lib.mkOption {
            type = lib.types.str;
            default = "/var/lib/lorry/working-area";
            description = ''
              Directory in which Lorry stores mirrored Git repositories and
              raw-file assets. Can be safely deleted, at the cost of having
              to re-mirror everything.
            '';
          };
        };
      };
      default = { };
      description = ''
        Configuration for Lorry, written to a TOML file. See
        <https://lorry.software/configuration/> for the full set of
        available options, such as `downstream` and `config-source`.
      '';
      example = {
        downstream = {
          kind = "local";
          base-dir = "/var/lib/lorry/mirrors";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.settings.port ];

    systemd.services.lorry = {
      description = "Lorry software asset mirroring system";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
        "network-online.target"
      ];
      wants = [ "network-online.target" ];
      restartTriggers = [ configFile ];

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} --config ${configFile}";
        WorkingDirectory = "/var/lib/lorry";
        DynamicUser = true;
        StateDirectory = "lorry";
        Restart = "on-failure";
        EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;

        NoNewPrivileges = true;
        ProtectHome = true;
        ProtectSystem = "strict";
      };
    };
  };
}
