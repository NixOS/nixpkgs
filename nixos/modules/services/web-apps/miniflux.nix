{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.miniflux;

  dbUser = "miniflux";
  dbPassword = "miniflux";
  dbHost = "localhost";
  dbName = "miniflux";

  pgsu = "${pkgs.sudo}/bin/sudo -u ${config.services.postgresql.superUser}";
  pgbin = "${config.services.postgresql.package}/bin";
  preStart = pkgs.writeScript "miniflux-pre-start" ''
    #!${pkgs.runtimeShell}
    db_exists() {
      [ "$(${pgsu} ${pgbin}/psql -Atc "select 1 from pg_database where datname='$1'")" == "1" ]
    }
    if ! db_exists "${dbName}"; then
      ${pgsu} ${pgbin}/psql postgres -c "CREATE ROLE ${dbUser} WITH LOGIN NOCREATEDB NOCREATEROLE ENCRYPTED PASSWORD '${dbPassword}'"
      ${pgsu} ${pgbin}/createdb --owner "${dbUser}" "${dbName}"
      ${pgsu} ${pgbin}/psql "${dbName}" -c "CREATE EXTENSION IF NOT EXISTS hstore"
    fi
  '';
in

{
  options = {
    services.miniflux = {
      enable = mkEnableOption "miniflux";

      config = mkOption {
        type = types.attrsOf types.str;
        example = literalExample ''
          {
            CLEANUP_FREQUENCY = "48";
            LISTEN_ADDR = "localhost:8080";
          }
        '';
        description = ''
          Configuration for Miniflux, refer to
          <link xlink:href="http://docs.miniflux.app/en/latest/configuration.html"/>
          for documentation on the supported values.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    services.miniflux.config = {
      LISTEN_ADDR = mkDefault "localhost:8080";
      DATABASE_URL = "postgresql://${dbUser}:${dbPassword}@${dbHost}/${dbName}?sslmode=disable";
      RUN_MIGRATIONS = "1";
      CREATE_ADMIN = mkDefault "1";
    };

    services.postgresql.enable = true;

    systemd.services.miniflux = {
      description = "Miniflux service";
      wantedBy = [ "multi-user.target" ];
      requires = [ "postgresql.service" ];
      after = [ "network.target" "postgresql.service" ];

      serviceConfig = {
        ExecStart = "${pkgs.miniflux}/bin/miniflux";
        ExecStartPre = "+${preStart}";
        DynamicUser = true;
        RuntimeDirectory = "miniflux";
        RuntimeDirectoryMode = "0700";
      };

      environment = {
        ADMIN_USERNAME = mkIf (!(cfg.config ? ADMIN_USERNAME_FILE)) "admin";
        ADMIN_PASSWORD = mkIf (!(cfg.config ? ADMIN_PASSWORD_FILE)) "password";
      } // cfg.config;
    };
    environment.systemPackages = [ pkgs.miniflux ];
  };
}
