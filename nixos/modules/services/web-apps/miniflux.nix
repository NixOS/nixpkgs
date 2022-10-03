{ config, lib, options, pkgs, ... }:

with lib;
let
  cfg = config.services.miniflux;

  databaseUrl = "";

  appConfig = {
    LISTEN_ADDR = cfg.listenAddress;
    DATABASE_URL = dbconnectionString;
    RUN_MIGRATIONS = "1";
    CREATE_ADMIN = "1";
  } // cfg.settings;

  dbPassword =
    if cfg.database.passwordFile != null
    then "$(cat $(cfg.database.passwordFile))"
    else cfg.database.password;

  dbconnectionString =
    if cfg.database.createLocally then
      if cfg.database.socket != null
      # Socket connection
      then "user=${cfg.database.user} dbname=${cfg.database.name} host=${cfg.database.socket}"
      # TCP connection
      else "user=${cfg.database.user} password=${dbPassword} host=${cfg.database.host} port=${toString cfg.database.port}"
    else
      cfg.database.connectionString;

  pgbin = "${config.services.postgresql.package}/bin";
  preStart = pkgs.writeScript "miniflux-pre-start" ''
    #!${pkgs.runtimeShell}
    ${pgbin}/psql "${dbconnectionString}" -c "CREATE EXTENSION IF NOT EXISTS hstore"
  '';
in
{
  options = {
    services.miniflux = {
      enable = mkEnableOption (lib.mdDoc "miniflux and creates a local postgres database for it");

      user = mkOption {
        type = types.str;
        default = "miniflux";
        description = lib.mdDoc "User account under which miniflux runs.";
      };

      listenAddress = mkOption {
        default = "localhost:8080";
        type = types.str;
        description = lib.mdDoc ''
          IP address and port of the server.
        '';
      };

      settings = mkOption {
        type = types.attrsOf types.str;
        example = literalExpression ''
          {
            CLEANUP_FREQUENCY_HOURS = "48";
          }
        '';
        default = {
          RUN_MIGRATIONS = "1";
          CREATE_ADMIN = "1";
        };
        defaultText = literalExpression ''
          {
            RUN_MIGRATIONS = "1";
            CREATE_ADMIN = "1";
          }
        '';
        description = lib.mdDoc ''
          Configuration for Miniflux, refer to
          <https://miniflux.app/docs/configuration.html>
          for documentation on the supported values.
        '';
      };

      database = {
        host = mkOption {
          type = types.str;
          default = "localhost";
          defaultText = literalExpression ''"localhost"'';
          description = lib.mdDoc ''
            Database host address.
          '';
        };

        port = mkOption {
          type = types.port;
          default = config.services.postgresql.port;
          defaultText = literalExpression ''
            config.${options.services.postgresql.port}
          '';
          description = lib.mdDoc ''
            Database host port.
          '';
        };

        name = mkOption {
          type = types.str;
          default = "miniflux";
          defaultText = literalExpression ''"miniflux'';
          description = lib.mdDoc ''
            Database name.
          '';
        };

        user = mkOption {
          type = types.str;
          default = "miniflux";
          defaultText = literalExpression ''"miniflux'';
          description = lib.mdDoc ''
            Database user.
          '';
        };

        password = mkOption {
          type = types.str;
          default = "miniflux";
          defaultText = literalExpression ''"miniflux'';
          description = lib.mdDoc ''
            Database password.
          '';
        };

        passwordFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          defaultText = literalExpression "null";
          example = "/run/secrets/miniflux-password";
          description = lib.mdDoc ''
            A file containing the password corresponding to
            {option}`database.user`.
          '';
        };

        socket = mkOption {
          type = types.nullOr types.path;
          default = if cfg.database.createLocally then "/run/postgresql" else null;
          defaultText = literalExpression "null";
          example = "/run/postgresql";
          description = lib.mdDoc ''
            Path to the unix socket file to use for the database authentication.
          '';
        };

        createLocally = mkOption {
          type = types.bool;
          default = false;
          defaultText = literalExpression "false";
          description = lib.mdDoc ''
            Whether to create a local database automatically.
          '';
        };

        connectionString = mkOption {
          type = types.nullOr types.str;
          default = null;
          defaultText = literalExpression "null";
          description = lib.mdDoc ''
            Database connection string.
          '';
        };
      };

      package = mkOption {
        type = types.package;
        default = pkgs.miniflux;
        defaultText = literalExpression "pkgs.miniflux";
        description = lib.mdDoc ''
          Which miniflux package to use for the running server.
        '';
      };

      adminCredentialsFile = mkOption {
        type = types.path;
        description = lib.mdDoc ''
          File containing the ADMIN_USERNAME and
          ADMIN_PASSWORD (length >= 6) in the format of
          an EnvironmentFile=, as described by systemd.exec(5).
        '';
        example = "/etc/nixos/miniflux-admin-credentials";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions =
      let
      in
      [
        {
          assertion = cfg.database.createLocally -> cfg.database.connectionString == null;
          message = "services.miniflux.database.connectionString cannot be set if services.miniflux.database.createLocally is true;";
        }
        {
          assertion = !cfg.database.createLocally -> cfg.database.connectionString == null;
          message = "services.miniflux.database.connectionString cannot be null if services.miniflux.database.createLocally is false;";
        }
      ];

    users.users."${cfg.user}" = {
      description = "Miniflux Service";
      group = cfg.user;
      createHome = false;
      isSystemUser = true;
      useDefaultShell = true;
    };

    services.postgresql = mkIf cfg.database.createLocally {
      enable = mkDefault true;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensurePermissions = {
            "DATABASE ${cfg.database.name}" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    systemd.services.miniflux-dbsetup = {
      description = "Miniflux database setup";
      requires = [ "postgresql.service" ];
      after = [ "network.target" "postgresql.service" ];
      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        ExecStart = preStart;
      };
    };

    systemd.services.miniflux = {
      description = "Miniflux service";
      wantedBy = [ "multi-user.target" ];
      requires = [ "miniflux-dbsetup.service" ];
      after = [ "network.target" "postgresql.service" "miniflux-dbsetup.service" ];
      environment = appConfig;

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/miniflux";
        User = cfg.user;
        RuntimeDirectory = cfg.user;
        RuntimeDirectoryMode = "0700";
        EnvironmentFile = cfg.adminCredentialsFile;
        # Hardening
        CapabilityBoundingSet = [ "" ];
        DeviceAllow = [ "" ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" "~@privileged" "~@resources" ];
        UMask = "0077";
      };
    };
  };
}
