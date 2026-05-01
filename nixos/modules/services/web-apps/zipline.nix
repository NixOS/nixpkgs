{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.zipline;
in
{
  meta.maintainers = with lib.maintainers; [ defelo ];

  options.services.zipline = {
    enable = lib.mkEnableOption "Zipline";

    package = lib.mkPackageOption pkgs "zipline" { };

    settings = lib.mkOption {
      description = ''
        Configuration of Zipline. See <https://zipline.diced.sh/docs/config> for more information.
      '';
      default = { };
      example = {
        DATABASE_URL = "postgres://postgres:postgres@postgres/postgres";
        CORE_SECRET = "changethis";
        CORE_HOSTNAME = "0.0.0.0";
        CORE_PORT = "3000";
        DATASOURCE_TYPE = "local";
        DATASOURCE_LOCAL_DIRECTORY = "/var/lib/zipline/uploads";
      };

      type = lib.types.submodule {
        freeformType =
          with lib.types;
          attrsOf (oneOf [
            str
            int
          ]);

        options = {
          CORE_HOSTNAME = lib.mkOption {
            type = lib.types.str;
            description = "The hostname to listen on.";
            default = "127.0.0.1";
            example = "0.0.0.0";
          };

          CORE_PORT = lib.mkOption {
            type = lib.types.port;
            description = "The port to listen on.";
            default = 3000;
            example = 8000;
          };
        };
      };
    };

    environmentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      example = [ "/run/secrets/zipline.env" ];
      description = ''
        Files to load environment variables from (in addition to [](#opt-services.zipline.settings)). This is useful to avoid putting secrets into the nix store. See <https://zipline.diced.sh/docs/config> for more information.
      '';
    };

    database.createLocally = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to enable and configure a local PostgreSQL database server.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.zipline.settings = {
      DATABASE_URL = lib.mkIf cfg.database.createLocally "postgresql://zipline@localhost/zipline?host=/run/postgresql";
      DATASOURCE_TYPE = lib.mkDefault "local";
      DATASOURCE_LOCAL_DIRECTORY = lib.mkDefault "/var/lib/zipline/uploads"; # created automatically by zipline
    };

    services.postgresql = lib.mkIf cfg.database.createLocally {
      enable = true;
      ensureUsers = lib.singleton {
        name = "zipline";
        ensureDBOwnership = true;
      };
      ensureDatabases = [ "zipline" ];
    };

    systemd.services.zipline = {
      wantedBy = [ "multi-user.target" ];

      wants = [ "network-online.target" ];
      after = [ "network-online.target" ] ++ lib.optional cfg.database.createLocally "postgresql.target";
      requires = lib.optional cfg.database.createLocally "postgresql.target";

      environment = lib.mapAttrs (_: value: toString value) cfg.settings;

      serviceConfig = {
        User = "zipline";
        Group = "zipline";
        DynamicUser = true;
        StateDirectory = "zipline";
        EnvironmentFile = cfg.environmentFiles;
        ExecStart = lib.getExe cfg.package;

        # Hardening
        AmbientCapabilities = "";
        CapabilityBoundingSet = [ "" ];
        DevicePolicy = "closed";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
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
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [ "AF_INET AF_INET6 AF_UNIX AF_NETLINK" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
          "@chown"
        ];
        UMask = "0077";
      };
    };
  };
}
