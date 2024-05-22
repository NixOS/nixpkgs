{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.fider;

  postgresqlPackage =
    if config.services.postgresql.enable then config.services.postgresql.package else pkgs.postgresql;
in
{
  options = {

    services.fider = {
      enable = lib.mkEnableOption "the Fider server";
      package = lib.mkPackageOption pkgs "fider" { };
      dataDir = lib.mkOption {
        type = lib.types.str;
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
      ] ++ lib.optionals (cfg.database.url == "local") [ "postgresql.service" ];
      requires = lib.optionals (cfg.database.url == "local") [ "postgresql.service" ];
      environment =
        let
          localPostgresqlUrl = "postgres://localhost/fider?host=/run/postgresql";
        in
        {
          DATABASE_URL = if (cfg.database.url == "local") then localPostgresqlUrl else cfg.database.url;
          JWT_SECRET = "not_so_secret";
          BASE_URL = "/";
          EMAIL_NOREPLY = "noreply@fider.io";
          EMAIL_SMTP_HOST = "mailhog";
          EMAIL_SMTP_PORT = "1025";
          BLOB_STORAGE_FS_PATH = "${cfg.dataDir}";
        };
      serviceConfig = {
        ExecStart = lib.getExe cfg.package;
        StateDirectory = "fider";
        DynamicUser = true;
        PrivateTmp = "yes";
        Restart = "on-failure";
        RuntimeDirectory = "fider";
        RuntimeDirectoryPreserve = true;
        CacheDirectory = "fider";
        WorkingDirectory = "${cfg.package}";
      };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ drupol ];
    # doc = ./fider.md;
  };
}
