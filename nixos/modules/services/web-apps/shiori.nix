{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.shiori;
in
{
  options = {
    services.shiori = {
      enable = lib.mkEnableOption "Shiori simple bookmarks manager";

      package = lib.mkPackageOption pkgs "shiori" { };

      address = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          The IP address on which Shiori will listen.
          If empty, listens on all interfaces.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8080;
        description = "The port of the Shiori web application";
      };

      webRoot = lib.mkOption {
        type = lib.types.str;
        default = "/";
        example = "/shiori";
        description = "The root of the Shiori web application";
      };

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/path/to/environmentFile";
        description = ''
          Path to file containing environment variables.
          Useful for passing down secrets.
          <https://github.com/go-shiori/shiori/blob/master/docs/Configuration.md#overall-configuration>
        '';
      };

      databaseUrl = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "postgres:///shiori?host=/run/postgresql";
        description = "The connection URL to connect to MySQL or PostgreSQL";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.shiori = {
      description = "Shiori simple bookmarks manager";
      wantedBy = [ "multi-user.target" ];
      after = [
        "postgresql.service"
        "mysql.service"
      ];
      environment =
        {
          SHIORI_DIR = "/var/lib/shiori";
        }
        // lib.optionalAttrs (cfg.databaseUrl != null) {
          SHIORI_DATABASE_URL = cfg.databaseUrl;
        };

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/shiori server --address '${cfg.address}' --port '${toString cfg.port}' --webroot '${cfg.webRoot}'";

        DynamicUser = true;
        StateDirectory = "shiori";
        # As the RootDirectory
        RuntimeDirectory = "shiori";

        # Security options
        EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
        BindReadOnlyPaths =
          [
            "/nix/store"

            # For SSL certificates, and the resolv.conf
            "/etc"
          ]
          ++ lib.optional (
            config.services.postgresql.enable
            && cfg.databaseUrl != null
            && lib.strings.hasPrefix "postgres://" cfg.databaseUrl
          ) "/run/postgresql"
          ++ lib.optional (
            config.services.mysql.enable
            && cfg.databaseUrl != null
            && lib.strings.hasPrefix "mysql://" cfg.databaseUrl
          ) "/var/run/mysqld";

        CapabilityBoundingSet = "";

        DeviceAllow = "";

        LockPersonality = true;

        MemoryDenyWriteExecute = true;

        PrivateDevices = true;
        PrivateUsers = true;

        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;

        RestrictNamespaces = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictRealtime = true;
        RestrictSUIDSGID = true;

        RootDirectory = "/run/shiori";

        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = [
          "@system-service"
          "~@cpu-emulation"
          "~@debug"
          "~@keyring"
          "~@memlock"
          "~@obsolete"
          "~@privileged"
          "~@setuid"
        ];
      };
    };
  };

  meta.maintainers = with lib.maintainers; [
    minijackson
    CaptainJawZ
  ];
}
