{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkPackageOption mkOption types literalExpression mkIf mkDefault;
  cfg = config.services.miniflux;

  defaultAddress = "localhost:8080";

  pgbin = "${config.services.postgresql.package}/bin";
  preStart = pkgs.writeScript "miniflux-pre-start" ''
    #!${pkgs.runtimeShell}
    ${pgbin}/psql "miniflux" -c "CREATE EXTENSION IF NOT EXISTS hstore"
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
          database yourself and make sure to create the hstore extension in it.
        '';
      };

      config = mkOption {
        type = with types; attrsOf (oneOf [ str int ]);
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

      adminCredentialsFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          File containing the ADMIN_USERNAME and
          ADMIN_PASSWORD (length >= 6) in the format of
          an EnvironmentFile=, as described by systemd.exec(5).
        '';
        example = "/etc/nixos/miniflux-admin-credentials";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      { assertion = cfg.config.CREATE_ADMIN == 0 || cfg.adminCredentialsFile != null;
        message = "services.miniflux.adminCredentialsFile must be set if services.miniflux.config.CREATE_ADMIN is 1";
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
      ensureUsers = [ {
        name = "miniflux";
        ensureDBOwnership = true;
      } ];
      ensureDatabases = [ "miniflux" ];
    };

    systemd.services.miniflux-dbsetup = lib.mkIf cfg.createDatabaseLocally {
      description = "Miniflux database setup";
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
      requires = lib.optional cfg.createDatabaseLocally "miniflux-dbsetup.service";
      after = [ "network.target" ]
        ++ lib.optionals cfg.createDatabaseLocally [ "postgresql.service" "miniflux-dbsetup.service" ];

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
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" "~@privileged" ];
        UMask = "0077";
      };

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
