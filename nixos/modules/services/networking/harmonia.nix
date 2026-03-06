{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.harmonia;
  cacheCfg = cfg.cache;
  daemonCfg = cfg.daemon;

  format = pkgs.formats.toml { };

  signKeyPaths =
    cacheCfg.signKeyPaths ++ (if cacheCfg.signKeyPath != null then [ cacheCfg.signKeyPath ] else [ ]);
  credentials = lib.imap0 (i: signKeyPath: {
    id = "sign-key-${toString i}";
    path = signKeyPath;
  }) signKeyPaths;
in
{
  imports = [
    # Renamed options for flat harmonia -> harmonia.cache
    (lib.mkRenamedOptionModule
      [ "services" "harmonia" "enable" ]
      [ "services" "harmonia" "cache" "enable" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "harmonia" "signKeyPath" ]
      [ "services" "harmonia" "cache" "signKeyPath" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "harmonia" "signKeyPaths" ]
      [ "services" "harmonia" "cache" "signKeyPaths" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "harmonia" "settings" ]
      [ "services" "harmonia" "cache" "settings" ]
    )
    # Note: package stays at the top level
  ];

  options = {
    services.harmonia = {
      package = lib.mkPackageOption pkgs "harmonia" { };

      cache = {
        enable = lib.mkEnableOption "Harmonia: Nix binary cache written in Rust";

        signKeyPath = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "DEPRECATED: Use `services.harmonia-dev.cache.signKeyPaths` instead. Path to the signing key to use for signing the cache";
        };

        signKeyPaths = lib.mkOption {
          type = lib.types.listOf lib.types.path;
          default = [ ];
          description = "Paths to the signing keys to use for signing the cache";
        };

        settings = lib.mkOption {
          inherit (format) type;
          default = { };
          description = ''
            Settings to merge with the default configuration.
            For the list of the default configuration, see <https://github.com/nix-community/harmonia/tree/master#configuration>.
          '';
        };
      };

      daemon = {
        enable = lib.mkEnableOption "Harmonia daemon: Nix daemon protocol implementation";

        socketPath = lib.mkOption {
          type = lib.types.str;
          default = "/run/harmonia-daemon/socket";
          description = "Path where the daemon socket will be created";
        };

        storeDir = lib.mkOption {
          type = lib.types.str;
          default = "/nix/store";
          description = "Path to the Nix store directory";
        };

        dbPath = lib.mkOption {
          type = lib.types.str;
          default = "/nix/var/nix/db/db.sqlite";
          description = "Path to the Nix database";
        };

        logLevel = lib.mkOption {
          type = lib.types.str;
          default = "info";
          description = "Log level for the daemon";
        };
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cacheCfg.enable {
      warnings =
        if cacheCfg.signKeyPath != null then
          [
            "`services.harmonia.cache.signKeyPath` is deprecated, use `services.harmonia.cache.signKeyPaths` instead"
          ]
        else
          [ ];

      nix.settings.extra-allowed-users = [ "harmonia" ];
      users.users.harmonia = {
        isSystemUser = true;
        group = "harmonia";
      };
      users.groups.harmonia = { };

      services.harmonia.cache.settings = builtins.mapAttrs (_: v: lib.mkDefault v) (
        {
          bind = "[::]:5000";
          workers = 4;
          max_connection_rate = 256;
          priority = 50;
        }
        // lib.optionalAttrs daemonCfg.enable {
          daemon_socket = daemonCfg.socketPath;
        }
      );

      systemd.services.harmonia = {
        description = "harmonia binary cache service";

        requires = if daemonCfg.enable then [ "harmonia-daemon.service" ] else [ "nix-daemon.socket" ];
        after = [ "network.target" ] ++ lib.optional daemonCfg.enable "harmonia-daemon.service";
        wantedBy = [ "multi-user.target" ];

        environment = {
          CONFIG_FILE = format.generate "harmonia.toml" cacheCfg.settings;
          SIGN_KEY_PATHS = lib.strings.concatMapStringsSep " " (
            credential: "%d/${credential.id}"
          ) credentials;
          # Note: it's important to set this for nix-store, because it wants to use
          # $HOME in order to use a temporary cache dir. bizarre failures will occur
          # otherwise
          HOME = "/run/harmonia";
        };

        serviceConfig = {
          ExecStart = lib.getExe cfg.package;
          User = "harmonia";
          Group = "harmonia";
          Restart = "on-failure";
          PrivateUsers = true;
          DeviceAllow = [ "" ];
          UMask = "0066";
          RuntimeDirectory = "harmonia";
          LoadCredential = map (credential: "${credential.id}:${credential.path}") credentials;
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
            "~@resources"
          ];
          CapabilityBoundingSet = "";
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectControlGroups = true;
          ProtectKernelLogs = true;
          ProtectHostname = true;
          ProtectClock = true;
          RestrictRealtime = true;
          MemoryDenyWriteExecute = true;
          ProcSubset = "pid";
          ProtectProc = "invisible";
          RestrictNamespaces = true;
          SystemCallArchitectures = "native";
          PrivateNetwork = false;
          PrivateTmp = true;
          PrivateDevices = true;
          PrivateMounts = true;
          NoNewPrivileges = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          LockPersonality = true;
          RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6";
          LimitNOFILE = 65536;
        };
      };
    })

    (lib.mkIf daemonCfg.enable {
      systemd.services.harmonia-daemon =
        let
          daemonConfig = {
            socket_path = daemonCfg.socketPath;
            store_dir = daemonCfg.storeDir;
            db_path = daemonCfg.dbPath;
            log_level = daemonCfg.logLevel;
          };
          daemonConfigFile = format.generate "harmonia-daemon.toml" daemonConfig;
        in
        {
          description = "Harmonia Nix daemon protocol server";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];

          environment = {
            RUST_LOG = daemonCfg.logLevel;
            RUST_BACKTRACE = "1";
            HARMONIA_DAEMON_CONFIG = daemonConfigFile;
          };

          serviceConfig = {
            Type = "simple";
            ExecStart = lib.getExe' cfg.package "harmonia-daemon";
            Restart = "on-failure";
            RestartSec = 5;

            # Socket will be created at runtime
            RuntimeDirectory = "harmonia-daemon";

            # Run as root to access the Nix database
            # Note: The Nix database is owned by root and requires root access
            NoNewPrivileges = true;
            PrivateTmp = true;
            ProtectSystem = "strict";
            ProtectHome = true;
            # SQLite needs write access for WAL mode
            ReadWritePaths = [
              (builtins.dirOf daemonCfg.dbPath) # Need write access for WAL and SHM files
            ];
            ReadOnlyPaths = [
              daemonCfg.storeDir
            ];

            # System call filtering
            SystemCallFilter = [
              "@system-service"
              "~@privileged"
              "@chown" # for sockets
              "~@resources"
            ];
            SystemCallArchitectures = "native";

            # Capabilities
            CapabilityBoundingSet = "";

            # Device access
            DeviceAllow = [ "" ];
            PrivateDevices = true;

            # Kernel protection
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ProtectControlGroups = true;
            ProtectKernelLogs = true;
            ProtectHostname = true;
            ProtectClock = true;

            # Memory protection
            MemoryDenyWriteExecute = true;
            LockPersonality = true;

            # Process visibility
            ProcSubset = "pid";
            ProtectProc = "invisible";

            # Namespace restrictions
            RestrictNamespaces = true;
            PrivateMounts = true;

            # Network restrictions
            RestrictAddressFamilies = "AF_UNIX";
            PrivateNetwork = false;

            # Resource limits
            LimitNOFILE = 65536;
            RestrictRealtime = true;

            # Misc restrictions
            UMask = "0077";
          };
        };
    })
  ];
}
