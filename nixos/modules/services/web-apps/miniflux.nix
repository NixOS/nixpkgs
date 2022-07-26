{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.miniflux;

  defaultAddress = "localhost:8080";

  dbUser = "miniflux";
  dbName = "miniflux";

  pgbin = "${config.services.postgresql.package}/bin";
  preStart = pkgs.writeScript "miniflux-pre-start" ''
    #!${pkgs.runtimeShell}
    ${pgbin}/psql "${dbName}" -c "CREATE EXTENSION IF NOT EXISTS hstore"
  '';
in

{
  options = {
    services.miniflux = {
      enable = mkEnableOption "miniflux and creates a local postgres database for it";

      config = mkOption {
        type = types.attrsOf types.str;
        example = literalExpression ''
          {
            CLEANUP_FREQUENCY = "48";
            LISTEN_ADDR = "localhost:8080";
          }
        '';
        description = ''
          Configuration for Miniflux, refer to
          <link xlink:href="https://miniflux.app/docs/configuration.html"/>
          for documentation on the supported values.

          Correct configuration for the database is already provided.
          By default, listens on ${defaultAddress}.
        '';
      };

      adminCredentialsFile = mkOption  {
        type = types.path;
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

    services.miniflux.config =  {
      LISTEN_ADDR = mkDefault defaultAddress;
      DATABASE_URL = "user=${dbUser} host=/run/postgresql dbname=${dbName}";
      RUN_MIGRATIONS = "1";
      CREATE_ADMIN = "1";
    };

    services.postgresql = {
      enable = true;
      ensureUsers = [ {
        name = dbUser;
        ensurePermissions = {
          "DATABASE ${dbName}" = "ALL PRIVILEGES";
        };
      } ];
      ensureDatabases = [ dbName ];
    };

    systemd.services.miniflux-dbsetup = {
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
      requires = [ "miniflux-dbsetup.service" ];
      after = [ "network.target" "postgresql.service" "miniflux-dbsetup.service" ];

      serviceConfig = {
        ExecStart = "${pkgs.miniflux}/bin/miniflux";
        User = dbUser;
        DynamicUser = true;
        RuntimeDirectory = "miniflux";
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

      environment = cfg.config;
    };
    environment.systemPackages = [ pkgs.miniflux ];
  };
}
