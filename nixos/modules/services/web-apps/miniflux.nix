{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.miniflux;

  dbUser = "miniflux";
  dbPassword = "miniflux";
  dbHost = "localhost";
  dbName = "miniflux";
in

{
  options = {
    services.miniflux = {
      enable = mkEnableOption "miniflux";
      package = mkOption {
        type = types.package;
        default = pkgs.miniflux;
        defaultText = "pkgs.miniflux";
        description = "Which miniflux package to use.";
      };

      user = mkOption {
        type = types.str;
        default = "miniflux";
        example = "miniflux";
        description = ''
          User account under which miniflux runs.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "miniflux";
        example = "miniflux";
        description = ''
          User group under which miniflux runs.
        '';
      };

      listenAddress = mkOption {
        type = types.str;
        default = "localhost";
        description = ''
          The host the daemon will listen on.
        '';
      };

      listenPort = mkOption  {
        type = types.int;
        default = 8080;
        example = "8080";
        description = ''
          The port the daemon will listen on.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.postgresql.enable = mkDefault true;

    users = {
      users.miniflux = {
        name = cfg.user;
        group = cfg.group;
        description = "miniflux service user";
        isSystemUser = true;
        createHome = false;
      };
      groups.miniflux = {
        name = cfg.group;
      };
    };

    systemd.services.miniflux = let
      configFile = pkgs.writeText "miniflux.conf" ''
        LISTEN_ADDR=${cfg.listenAddress}:${toString cfg.listenPort}
        DATABASE_URL="postgresql://${dbUser}:${dbPassword}@${dbHost}/${dbName}?sslmode=disable"
        RUN_MIGRATIONS=1
      '';
    in {
      description = "Miniflux service";
      wantedBy = [ "multi-user.target" ];
      requires = [ "postgresql.service" ];
      after = [ "network.target" "postgresql.service" ];

      serviceConfig = {
        PermissionsStartOnly = true;
        Type = "simple";
        PrivateTmp = false;
        ExecStart = "${cfg.package}/bin/miniflux";
        EnvironmentFile = configFile;
        User = cfg.user;
      };

      preStart = let
        pgsu = "${pkgs.sudo}/bin/sudo -u ${config.services.postgresql.superUser}";
        pgbin = "${config.services.postgresql.package}/bin";
      in ''
        db_exists() {
          [ "$(${pgsu} ${pgbin}/psql -Atc "select 1 from pg_database where datname='$1'")" == "1" ]
        }
        if ! db_exists "${dbName}"; then
          ${pgsu} ${pgbin}/psql postgres -c "CREATE ROLE ${dbUser} WITH LOGIN NOCREATEDB NOCREATEROLE ENCRYPTED PASSWORD '${dbPassword}'"
          ${pgsu} ${pgbin}/createdb --owner "${dbUser}" "${dbName}"
          ${pgsu} ${pgbin}/psql "${dbName}" -c "CREATE EXTENSION IF NOT EXISTS hstore"
        fi
      '';
    };
  };
}
