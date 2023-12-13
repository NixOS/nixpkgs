{ config, lib, pkgs, ... }:

with lib;
let
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
      enable = mkEnableOption (lib.mdDoc "miniflux and creates a local postgres database for it");

      package = mkPackageOption pkgs "miniflux" { };

      config = mkOption {
        type = types.attrsOf types.str;
        example = literalExpression ''
          {
            CLEANUP_FREQUENCY = "48";
            LISTEN_ADDR = "localhost:8080";
          }
        '';
        description = lib.mdDoc ''
          Configuration for Miniflux, refer to
          <https://miniflux.app/docs/configuration.html>
          for documentation on the supported values.

          Correct configuration for the database is already provided.
          By default, listens on ${defaultAddress}.
        '';
      };

      adminCredentialsFile = mkOption  {
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

    services.miniflux.config =  {
      LISTEN_ADDR = mkDefault defaultAddress;
      DATABASE_URL = "user=miniflux host=/run/postgresql dbname=miniflux";
      RUN_MIGRATIONS = "1";
      CREATE_ADMIN = "1";
    };

    services.postgresql = {
      enable = true;
      ensureUsers = [ {
        name = "miniflux";
        ensureDBOwnership = true;
      } ];
      ensureDatabases = [ "miniflux" ];
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
        ExecStart = "${cfg.package}/bin/miniflux";
        User = "miniflux";
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
        SystemCallFilter = [ "@system-service" "~@privileged" ];
        UMask = "0077";
      };

      environment = cfg.config;
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
      }
    '';
  };
}
