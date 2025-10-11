{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.fider;
  fiderCmd = lib.getExe cfg.package;
in
{
  options = {

    services.fider = {
      enable = lib.mkEnableOption "the Fider server";
      package = lib.mkPackageOption pkgs "fider" { };

      dataDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/fider";
        description = "Default data folder for Fider.";
        example = "/mnt/fider";
      };

      database = {
        url = lib.mkOption {
          type = lib.types.str;
          default = "local";
          description = ''
            URI to use for the main PostgreSQL database. If this needs to include
            credentials that shouldn't be world-readable in the Nix store, set an
            environment file on the systemd service and override the
            `DATABASE_URL` entry. Pass the string
            `local` to setup a database on the local server.
          '';
        };
      };

      environment = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        example = {
          PORT = "31213";
          BASE_URL = "https://fider.example.com";
          EMAIL = "smtp";
          EMAIL_NOREPLY = "fider@example.com";
          EMAIL_SMTP_USERNAME = "fider@example.com";
          EMAIL_SMTP_HOST = "mail.example.com";
          EMAIL_SMTP_PORT = "587";
          BLOB_STORAGE = "fs";
        };
        description = ''
          Environment variables to set for the service. Secrets should be
          specified using {option}`environmentFiles`.
          Refer to <https://github.com/getfider/fider/blob/stable/.example.env>
          and <https://github.com/getfider/fider/blob/stable/app/pkg/env/env.go>
          for available options.
        '';
      };

      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
        example = "/run/secrets/fider.env";
        description = ''
          Files to load environment variables from. Loaded variables override
          values set in {option}`environment`.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.postgresql = lib.mkIf (cfg.database.url == "local") {
      enable = true;
      ensureUsers = [
        {
          name = "fider";
          ensureDBOwnership = true;
        }
      ];
      ensureDatabases = [ "fider" ];
    };

    systemd.services.fider = {
      description = "Fider server";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
      ]
      ++ lib.optionals (cfg.database.url == "local") [ "postgresql.target" ];
      requires = lib.optionals (cfg.database.url == "local") [ "postgresql.target" ];
      environment =
        let
          localPostgresqlUrl = "postgres:///fider?host=/run/postgresql";
        in
        {
          DATABASE_URL = if (cfg.database.url == "local") then localPostgresqlUrl else cfg.database.url;
          BLOB_STORAGE_FS_PATH = "${cfg.dataDir}";
        }
        // cfg.environment;
      serviceConfig = {
        ExecStartPre = "${fiderCmd} migrate";
        ExecStart = fiderCmd;
        StateDirectory = "fider";
        DynamicUser = true;
        PrivateTmp = "yes";
        Restart = "on-failure";
        RuntimeDirectory = "fider";
        RuntimeDirectoryPreserve = true;
        CacheDirectory = "fider";
        WorkingDirectory = "${cfg.package}";
        EnvironmentFile = cfg.environmentFiles;
      };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [
      niklaskorz
    ];
    # doc = ./fider.md;
  };
}
