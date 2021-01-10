{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.miniflux;

  defaultCredentials = pkgs.writeText "miniflux-admin-credentials" ''
    ADMIN_USERNAME=admin
    ADMIN_PASSWORD=password
  '';

  pgbin = "${config.services.postgresql.package}/bin";
  preStart = pkgs.writeScript "miniflux-pre-start" ''
    #!${pkgs.runtimeShell}
    db_exists() {
      [ "$(${pgbin}/psql -Atc "select 1 from pg_database where datname='$1'")" == "1" ]
    }
    if ! db_exists "${cfg.database.name}"; then
      ${pgbin}/psql postgres -c "CREATE ROLE \"${cfg.database.user}\" WITH LOGIN NOCREATEDB NOCREATEROLE ENCRYPTED PASSWORD '${cfg.database.password}'"
      ${pgbin}/createdb --owner "${cfg.database.user}" "${cfg.database.name}"
      ${pgbin}/psql "${cfg.database.name}" -c "CREATE EXTENSION IF NOT EXISTS hstore"
    fi
  '';
in

{
  options = {
    services.miniflux = {
      enable = mkEnableOption "miniflux";

      database = {
        host = mkOption {
          type = types.str;
          default = "localhost";
          description = "Database host address.";
        };

        port = mkOption {
          type = types.port;
          default = 5432;
          description = "Database host port.";
        };

        name = mkOption {
          type = types.str;
          default = "miniflux";
          description = "Database name.";
        };

        user = mkOption {
          type = types.str;
          default = "miniflux";
          description = "Database user.";
        };

        password = mkOption {
          type = types.str;
          default = "miniflux";
          description = ''
            The password corresponding to <option>database.user</option>.
            Warning: this is stored in cleartext in the Nix store!
          '';
        };

        createLocally = mkOption {
          type = types.bool;
          default = true;
          description = "Create the database and database user locally.";
        };
      };

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
          <link xlink:href="https://miniflux.app/docs/configuration.html"/>
          for documentation on the supported values.
        '';
      };

      adminCredentialsFile = mkOption  {
        type = types.nullOr types.path;
        default = null;
        description = ''
          File containing the ADMIN_USERNAME, default is "admin", and
          ADMIN_PASSWORD (length >= 6), default is "password"; in the format of
          an EnvironmentFile=, as described by systemd.exec(5).
        '';
        example = "/etc/nixos/miniflux-admin-credentials";
      };
    };
  };

  config = mkIf cfg.enable {

    services.miniflux.config =  {
      LISTEN_ADDR = mkDefault "localhost:8080";
      DATABASE_URL = "postgresql://${cfg.database.user}:${cfg.database.password}@${cfg.database.host}:${toString cfg.database.port}/${cfg.database.name}?sslmode=disable";
      RUN_MIGRATIONS = "1";
      CREATE_ADMIN = "1";
    };

    services.postgresql = optionalAttrs cfg.database.createLocally {
      enable = true;
    };

    systemd.services.miniflux-dbsetup = {
      description = "Miniflux database setup";
      wantedBy = [ "multi-user.target" ];
      requires = [ "postgresql.service" ];
      after = [ "network.target" "postgresql.service" ];
      serviceConfig = {
        Type = "oneshot";
        User = config.services.postgresql.superUser;
        ExecStart = preStart;
      };
    };

    systemd.services.miniflux = {
      description = "Miniflux service";
      wantedBy = [ "multi-user.target" ];
      requires = optionals cfg.database.createLocally [ "postgresql.service" ];
      after = [ "network.target" ] ++ optionals cfg.database.createLocally [ "postgresql.service" "miniflux-dbsetup.service" ];

      serviceConfig = {
        ExecStart = "${pkgs.miniflux}/bin/miniflux";
        DynamicUser = true;
        RuntimeDirectory = "miniflux";
        RuntimeDirectoryMode = "0700";
        EnvironmentFile = if cfg.adminCredentialsFile == null
        then defaultCredentials
        else cfg.adminCredentialsFile;
      };

      environment = cfg.config;
    };
    environment.systemPackages = [ pkgs.miniflux ];
  };
}
