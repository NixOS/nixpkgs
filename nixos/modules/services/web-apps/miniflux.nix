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

  boolToInt = b: if b then 1 else 0;

  pgbin = "${config.services.postgresql.package}/bin";
  # The hstore extension is no longer needed as of v2.2.14
  # and would prevent Miniflux from starting.
  preStart = pkgs.writeScript "miniflux-pre-start" ''
    #!${pkgs.runtimeShell}
    ${pgbin}/psql "miniflux" -c "DROP EXTENSION IF EXISTS hstore"
  '';
in

{
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
          database yourself.
        '';
      };

      config = mkOption {
        type = types.submodule {
          freeformType =
            with types;
            attrsOf (oneOf [
              str
              int
            ]);
          options = {
            LISTEN_ADDR = mkOption {
              type = types.str;
              default = "localhost:8080";
              description = ''
                Address to listen on. Use absolute path for a Unix socket.
                Multiple addresses can be specified, separated by commas.
              '';
              example = "127.0.0.1:8080, 127.0.0.1:8081";
            };
            DATABASE_URL = mkOption {
              type = types.nullOr types.str;
              defaultText = literalExpression ''
                if createDatabaseLocally then "user=miniflux host=/run/postgresql dbname=miniflux" else null
              '';
              default =
                if cfg.createDatabaseLocally then "user=miniflux host=/run/postgresql dbname=miniflux" else null;

              description = ''
                Postgresql connection parameters.
                See [lib/pq](https://pkg.go.dev/github.com/lib/pq#hdr-Connection_String_Parameters) for more details.
              '';
            };
            RUN_MIGRATIONS = mkOption {
              type = with types; coercedTo bool boolToInt int;
              default = true;
              description = "Run database migrations.";
            };
            CREATE_ADMIN = mkOption {
              type = with types; coercedTo bool boolToInt int;
              default = true;
              description = "Create an admin user from environment variables.";
            };
            WATCHDOG = mkOption {
              type = with types; coercedTo bool boolToInt int;
              default = true;
              description = "Enable or disable Systemd watchdog.";
            };
          };
        };
        default = { };
        description = ''
          Configuration for Miniflux, refer to
          <https://miniflux.app/docs/configuration.html>
          for documentation on the supported values.
        '';
      };

      adminCredentialsFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          File containing the ADMIN_USERNAME and
          ADMIN_PASSWORD (length >= 6) in the format of
          an EnvironmentFile=, as described by {manpage}`systemd.exec(5)`.
        '';
        example = "/etc/nixos/miniflux-admin-credentials";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.config.CREATE_ADMIN == 0 || cfg.adminCredentialsFile != null;
        message = "services.miniflux.adminCredentialsFile must be set if services.miniflux.config.CREATE_ADMIN is 1";
      }
    ];

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
        ExecStart = lib.getExe cfg.package;
        User = "miniflux";
        DynamicUser = true;
        RuntimeDirectory = "miniflux";
        RuntimeDirectoryMode = "0750";
        EnvironmentFile = lib.mkIf (cfg.adminCredentialsFile != null) cfg.adminCredentialsFile;
        WatchdogSec = 60;
        WatchdogSignal = "SIGKILL";
        Restart = "always";
        RestartSec = 5;

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

      environment = lib.mapAttrs (_: toString) (lib.filterAttrs (_: v: v != null) cfg.config);
    };
    environment.systemPackages = [ cfg.package ];

    security.apparmor.policies."bin.miniflux".profile = ''
      abi <abi/4.0>,
      include <tunables/global>

      profile ${cfg.package}/bin/miniflux {
        include <abstractions/base>
        include <abstractions/nameservice>
        include <abstractions/ssl_certs>
        include <abstractions/golang>
        include "${pkgs.apparmorRulesFromClosure { name = "miniflux"; } cfg.package}"
        ${cfg.package}/bin/miniflux r,
        /run/miniflux/** rw,
        include if exists <local/bin.miniflux>
      }
    '';
  };
}
