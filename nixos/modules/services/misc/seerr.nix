{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.seerr;
  # 26.05 introduced a breaking change which is guarded behind stateVersion to avoid
  # breaking users.
  useNewConfigLocation = lib.versionAtLeast config.system.stateVersion "26.05";
  usePostgresql = cfg.database.type == "postgres";
  localPostgresql = usePostgresql && cfg.database.createLocally;
in
{
  imports = [
    (lib.mkRenamedOptionModule [ "services" "jellyseerr" ] [ "services" "seerr" ])
  ];

  meta.maintainers = with lib.maintainers; [
    camillemndn
    fallenbagel
  ];

  options.services.seerr = {
    enable = lib.mkEnableOption "Seerr, a requests manager for Jellyfin";
    package = lib.mkPackageOption pkgs "seerr" { };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open port in the firewall for the Seerr web interface.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 5055;
      description = "The port which the Seerr web UI should listen to.";
    };

    configDir = lib.mkOption {
      type = lib.types.path;
      default = if useNewConfigLocation then "/var/lib/seerr/" else "/var/lib/jellyseerr/config";
      description = "Config data directory";
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/seerr.env";
      description = ''
        Path to an environment file (see {manpage}`systemd.exec(5)`) loaded by the
        service. Use it to pass secrets such as `DB_PASS` (the PostgreSQL password
        for TCP authentication) without writing them to the world-readable Nix
        store. Not needed when {option}`services.seerr.database.socketPath` is used
        with peer authentication.
      '';
    };

    database = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to automatically create a local PostgreSQL database and user.
        '';
      };

      type = lib.mkOption {
        type = lib.types.enum [
          "sqlite"
          "postgres"
        ];
        default = "sqlite";
        description = ''
          Database engine Seerr should use. With `sqlite` (the default) Seerr keeps
          its data in a file under {option}`services.seerr.configDir`. With
          `postgres` it connects to an external PostgreSQL server, which must be
          provisioned separately (for example via {option}`services.postgresql`).
        '';
      };

      host = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "127.0.0.1";
        description = ''
          PostgreSQL host to connect to over TCP. Ignored when
          {option}`services.seerr.database.socketPath` is set.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 5432;
        description = "PostgreSQL TCP port. Ignored when {option}`services.seerr.database.socketPath` is set.";
      };

      socketPath = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = if cfg.database.createLocally then "/run/postgresql" else null;
        defaultText = lib.literalExpression ''
          if config.services.seerr.database.createLocally then "/run/postgresql" else null
        '';
        example = "/run/postgresql";
        description = ''
          Directory of the PostgreSQL Unix-domain socket to connect through. When
          set it takes precedence over {option}`services.seerr.database.host` and
          enables passwordless peer authentication for a local PostgreSQL server.
        '';
      };

      name = lib.mkOption {
        type = lib.types.str;
        default = "seerr";
        description = "PostgreSQL database name.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "seerr";
        example = "seerr";
        description = "PostgreSQL user name.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.database.createLocally -> usePostgresql;
        message = "services.seerr.database.createLocally requires services.seerr.database.type to be \"postgres\".";
      }
      {
        assertion = usePostgresql -> (cfg.database.socketPath != null || cfg.database.host != null);
        message = "services.seerr.database: set either socketPath (peer authentication) or host when type is \"postgres\".";
      }
      {
        assertion = localPostgresql -> cfg.database.user == "seerr";
        message = "services.seerr.database.user must be \"seerr\" when services.seerr.database.createLocally is true.";
      }
    ];

    services.postgresql = lib.mkIf localPostgresql {
      enable = true;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensureDBOwnership = true;
        }
      ];
    };

    systemd.services.seerr = {
      description = "Seerr, a requests manager for Jellyfin";
      after = [ "network.target" ] ++ lib.optional localPostgresql "postgresql.target";
      requires = lib.optional localPostgresql "postgresql.target";
      wantedBy = [ "multi-user.target" ];
      environment = {
        PORT = toString cfg.port;
        CONFIG_DIRECTORY = cfg.configDir;
      }
      // lib.optionalAttrs usePostgresql (
        {
          DB_TYPE = "postgres";
          DB_NAME = cfg.database.name;
          DB_USER = cfg.database.user;
        }
        // (
          if cfg.database.socketPath != null then
            { DB_SOCKET_PATH = cfg.database.socketPath; }
          else
            {
              DB_HOST = cfg.database.host;
              DB_PORT = toString cfg.database.port;
            }
        )
      );
      serviceConfig = {
        Type = "exec";
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
        # Note: this should be a parent of configDir.
        StateDirectory = if useNewConfigLocation then "seerr" else "jellyseerr";
        DynamicUser = true;
        ExecStart = lib.getExe cfg.package;
        Restart = "on-failure";
        ProtectHome = true;
        ProtectSystem = "strict";
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        NoNewPrivileges = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        PrivateMounts = true;
      };
      unitConfig.RequiresMountsFor = [ cfg.configDir ];
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };
}
