{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    types
    literalExpression
    mkIf
    mkDefault
    ;
  cfg = config.services.miniflux;

  defaultAddress = "localhost:8080";

  secretPathType = lib.types.pathWith {
    inStore = false;
    absolute = true;
  };
  pgbin = "${config.services.postgresql.package}/bin";
  preStart = pkgs.writeScript "miniflux-pre-start" ''
    #!${pkgs.runtimeShell}
    ${pgbin}/psql "miniflux" -c "CREATE EXTENSION IF NOT EXISTS hstore"
  '';
  runtimeDirectory = "miniflux";
in

{
  imports = [
    (lib.mkRemovedOptionModule [ "services" "miniflux" "adminCredentialsFile" ] ''
      Use `services.miniflux.adminUsernameFile` and `services.miniflux.adminPasswordFile` instead.
      Note that these new options are *not* EnvironmentFiles for systemd.
    '')
  ];

  options = {
    services.miniflux = {
      enable = mkEnableOption "miniflux";

      package = mkPackageOption pkgs "miniflux" { };

      createDatabaseLocally = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether a PostgreSQL database should be automatically created and
          configured on the local host. If set to `false`, you need provision a
          database yourself and make sure to create the hstore extension in it.
        '';
      };

      config = mkOption {
        type =
          with types;
          attrsOf (oneOf [
            str
            int
          ]);
        example = literalExpression ''
          {
            CLEANUP_FREQUENCY = 48;
            LISTEN_ADDR = "localhost:8080";
          }
        '';
        description = ''
          Configuration for Miniflux, refer to
          <https://miniflux.app/docs/configuration.html>
          for documentation on the supported values.

          Correct configuration for the database is already provided.
          By default, listens on ${defaultAddress}.
        '';
      };

      adminUsernameFile = mkOption {
        type = types.nullOr secretPathType;
        default = null;
        example = "/run/secrets/miniflux/admin-username";
        description = ''
          File containing the ADMIN_USERNAME.
        '';
      };

      adminPasswordFile = mkOption {
        type = types.nullOr secretPathType;
        default = null;
        example = "/run/secrets/miniflux/admin-password";
        description = ''
          File containing the ADMIN_PASSWORD (length >= 6).
        '';
      };

      oauth2ClientSecretFile = mkOption {
        type = types.nullOr secretPathType;
        default = null;
        example = "/run/secrets/miniflux/oauth2-client-secret";
        description = ''
          File containing the OAUTH2_CLIENT_SECRET.
        '';
      };

      pgpassFile = mkOption {
        type = types.nullOr secretPathType;
        default = null;
        example = "/run/secrets/miniflux/pgpass";
        description = ''
          The password to authenticate to PostgreSQL with.
          Not needed for peer or trust based authentication.

          The file must be a valid `.pgpass` file as described in:
          <https://www.postgresql.org/docs/current/libpq-pgpass.html>

          In most cases, the following will be enough:
          ```
          *:*:*:*:<password>
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = (cfg.config.CREATE_ADMIN == 1) -> (cfg.adminPasswordFile != null);
        message = "services.miniflux.adminPasswordFile must be set if services.miniflux.config.CREATE_ADMIN is 1";
      }
    ];
    services.miniflux.config = {
      LISTEN_ADDR = mkDefault defaultAddress;
      DATABASE_URL = lib.mkIf cfg.createDatabaseLocally "user=miniflux host=/run/postgresql dbname=miniflux";
      RUN_MIGRATIONS = 1;
      CREATE_ADMIN = lib.mkDefault 1;
      WATCHDOG = 1;
    };

    services.postgresql = lib.mkIf cfg.createDatabaseLocally {
      enable = true;
      ensureUsers = [
        {
          name = "miniflux";
          ensureDBOwnership = true;
        }
      ];
      ensureDatabases = [ "miniflux" ];
    };

    systemd.services.miniflux-dbsetup = lib.mkIf cfg.createDatabaseLocally {
      description = "Miniflux database setup";
      requires = [ "postgresql.target" ];
      after = [
        "network.target"
        "postgresql.target"
      ];
      serviceConfig = {
        Type = "oneshot";
        User = config.services.postgresql.superUser;
        ExecStart = preStart;
      };
    };

    systemd.services.miniflux = {
      description = "Miniflux service";
      wantedBy = [ "multi-user.target" ];
      requires = lib.optional cfg.createDatabaseLocally "miniflux-dbsetup.service";
      after = [
        "network.target"
      ]
      ++ lib.optionals cfg.createDatabaseLocally [
        "postgresql.target"
        "miniflux-dbsetup.service"
      ];

      serviceConfig = {
        Type = "notify";
        User = "miniflux";
        DynamicUser = true;
        RuntimeDirectory = runtimeDirectory;
        RuntimeDirectoryMode = "0750";
        WatchdogSec = 60;
        WatchdogSignal = "SIGKILL";
        Restart = "always";
        RestartSec = 5;
        Environment = lib.optional (cfg.pgpassFile != null) "PGPASSFILE=%t/${runtimeDirectory}/pgpass";
        LoadCredential =
          (lib.optional (cfg.adminUsernameFile != null) "adminUsername:${cfg.adminUsernameFile}")
          ++ (lib.optional (cfg.adminPasswordFile != null) "adminPassword:${cfg.adminPasswordFile}")
          ++ (lib.optional (
            cfg.oauth2ClientSecretFile != null
          ) "oauth2ClientSecret:${cfg.oauth2ClientSecretFile}")
          ++ (lib.optional (cfg.pgpassFile != null) "pgpass:${cfg.pgpassFile}");

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
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        UMask = "0077";
      };

      script = lib.concatStringsSep "\n" (
        (lib.optional (
          cfg.adminUsernameFile != null
        ) ''export ADMIN_USERNAME=$(< "$CREDENTIALS_DIRECTORY/adminUsername")'')
        ++ (lib.optional (
          cfg.adminPasswordFile != null
        ) ''export ADMIN_PASSWORD=$(< "$CREDENTIALS_DIRECTORY/adminPassword")'')
        ++ (lib.optional (
          cfg.oauth2ClientSecretFile != null
        ) ''export OAUTH2_CLIENT_SECRET=$(< "$CREDENTIALS_DIRECTORY/oauth2ClientSecret")'')
        ++ (lib.optional (cfg.pgpassFile != null)
          # Copy the pgpass file to different location, to have it report mode 0400.
          # See: https://github.com/systemd/systemd/issues/29435
          ''cp -f "$CREDENTIALS_DIRECTORY/pgpass" "$PGPASSFILE"''
        )
        ++ [ "exec ${lib.getExe cfg.package}" ]
      );

      environment = lib.mapAttrs (_: toString) cfg.config;
    };
    environment.systemPackages = [ cfg.package ];

    security.apparmor.policies."bin.miniflux".profile = ''
      include <tunables/global>
      ${cfg.package}/bin/miniflux {
        include <abstractions/base>
        include <abstractions/nameservice>
        include <abstractions/ssl_certs>
        include "${pkgs.apparmorRulesFromClosure { name = "miniflux"; } cfg.package}"
        r ${cfg.package}/bin/miniflux,
        r @{sys}/kernel/mm/transparent_hugepage/hpage_pmd_size,
        rw /run/miniflux/**,
      }
    '';
  };
}
