{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.atlantis;
in
{
  options.services.atlantis = {
    enable = lib.mkEnableOption "Atlantis service";

    package = lib.mkPackageOption pkgs "atlantis" { };

    serverArgs = lib.mkOption {
      description = ''
        Arguments passed to Atlantis server.

        See the docs for details:
        <https://www.runatlantis.io/docs/server-configuration.html>
      '';
      example = lib.literalExpression ''
        {
          atlantis-url = "https://atlantis.example.com";
          gh-user = "github_user";
          gh-token = "github_token";
          gh-webhook-secret = "webhook_secret";
          repo-allowlist = "github.com/yourorg/yourrepo";
          default-tf-version = "1.12.2";
        }
      '';
      type = lib.types.attrs;
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/atlantis";
      description = ''
        Environment file to inject e.g. secrets into the configuration.
      '';
    };

    dataDir = lib.mkOption {
      description = "Data directory for Atlantis.";
      default = "/var/lib/atlantis";
      type = lib.types.path;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd = lib.mkMerge [
      {
        services.atlantis = {
          description = "Atlantis service";
          after = [ "network.target" ];
          wants = [ "network.target" ];
          serviceConfig = {
            User = "atlantis";
            Group = "atlantis";
            EnvironmentFile = cfg.environmentFile;
            ExecStart = ''
              ${cfg.package}/bin/atlantis server ${
                lib.concatStringsSep " " (
                  lib.mapAttrsToList (name: value: "--${name}='${toString value}'") cfg.serverArgs
                )
              }
            '';
            Restart = "on-failure";
          };
          wantedBy = [ "multi-user.target" ];
        };
      }
      (lib.mkIf (cfg.environmentFile != null) {
        # The service will not restart if the env file has
        # been changed. This can cause stale env vars.
        paths.atlantis-env-file = {
          wantedBy = [ "multi-user.target" ];

          pathConfig = {
            PathChanged = [ cfg.environmentFile ];
            Unit = "atlantis-restart.service";
          };
        };

        services.atlantis-restart = {
          description = "Restart Atlantis";

          script = ''
            systemctl restart atlantis.service
          '';

          serviceConfig = {
            Type = "oneshot";
            Restart = "on-failure";
            RestartSec = 5;
          };
        };
      })
    ];

    users.users.atlantis = {
      description = "Atlantis user";
      home = cfg.dataDir;
      createHome = true;
      group = "atlantis";
      isSystemUser = true;
    };
    users.groups.atlantis = { };
  };
}
