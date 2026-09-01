{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.kvrocks;

  format = pkgs.formats.keyValue {
    # Emit list values as repeated keys (e.g. rename-command), matching MultiStringField.
    listsAsDuplicateKeys = true;
    mkKeyValue = lib.generators.mkKeyValueDefault {
      mkValueString = v: if lib.isBool v then lib.boolToYesNo v else toString v;
    } " ";
  };

  defaultDir = "/var/lib/kvrocks";
  dataDir = cfg.settings.dir;
  isDefaultDir = dataDir == defaultDir;

  # Defaults match upstream Config field defaults (config.cc).
  # freeformType uses listsAsDuplicateKeys, so set values are singleton lists.
  workers = lib.head (cfg.settings.workers or [ 8 ]);
  maxBackgroundJobs = lib.head (cfg.settings."rocksdb.max_background_jobs" or [ 4 ]);
  maxclients = lib.head (cfg.settings.maxclients or [ 10240 ]);
  maxOpenFiles = lib.head (cfg.settings."rocksdb.max_open_files" or [ 8096 ]);

  # Thread inventory from server.cc ("Kvrocks threads list") + Server::Start:
  #   always-on: main, workers, task-runner (1), server-cron, compact-check,
  #              rocksdb background (bounded by max_background_jobs)
  #   optional:  master-repl (+ ≤4 parallel fetch via std::async on full sync),
  #              feed-slave per replica, slot-migrate (cluster)
  alwaysOnThreads = 1 + workers + 1 + 1 + 1 + maxBackgroundJobs;
  # 1 master-repl + 4 fetch + 1 slot-migrate + ~16 replicas + misc (jemalloc, …)
  dynamicThreadMargin = 32;

  # From Server::AdjustOpenFilesLimit:
  #   max_files = maxclients + rocksdb.max_open_files + min_reserved_fds
  #   min_reserved_fds = 128  (listen sockets, logs, persistence, misc)
  openFilesReserved = 128;

  hasUnixSocket = cfg.settings.unixsocket != "";
  hasTcp = lib.length cfg.settings.bind > 0;
  configFile = format.generate "kvrocks.conf" (
    {
      daemonize = "no";
      supervised = "systemd";
    }
    // (builtins.removeAttrs cfg.settings [
      "bind"
      "unixsocket"
    ])
    // lib.optionalAttrs (hasTcp && !cfg.socketActivation) {
      bind = lib.concatStringsSep " " cfg.settings.bind;
    }
    // lib.optionalAttrs hasUnixSocket {
      unixsocket = cfg.settings.unixsocket;
    }
    // lib.optionalAttrs cfg.socketActivation {
      socket-fd = 3;
    }
  );
in
{
  meta.maintainers = pkgs.kvrocks.meta.maintainers;

  options = {
    services.kvrocks = {
      enable = lib.mkEnableOption "the Kvrocks server";

      package = lib.mkPackageOption pkgs "kvrocks" { };

      user = lib.mkOption {
        type = lib.types.str;
        default = "kvrocks";
        description = "User account under which Kvrocks runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "kvrocks";
        description = "Group under which Kvrocks runs.";
      };

      socketActivation = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enable systemd socket activation for TCP.
          Requires exactly one address in {option}`services.kvrocks.settings.bind`.
        '';
      };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = format.type;

          options = {
            bind = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [
                "127.0.0.1"
                "::1"
              ];
              description = "The addresses to bind to.";
            };

            port = lib.mkOption {
              type = lib.types.port;
              default = 6666;
              description = "Accept connections on the specified port.";
            };

            unixsocket = lib.mkOption {
              type = lib.types.str;
              default = "";
              example = "/run/kvrocks/kvrocks.sock";
              description = "Unix socket path.";
            };

            dir = lib.mkOption {
              type = lib.types.str;
              default = defaultDir;
              description = "Directory for database files.";
            };
          };
        };
        default = { };
        example = {
          workers = 8;
          maxclients = 10000;
          rename-command = [
            "KEYS \"\""
            "FLUSHDB \"\""
          ];
        };
        description = ''
          Configuration for kvrocks.
          See <https://github.com/apache/kvrocks/blob/unstable/kvrocks.conf> for supported options.

          List values are emitted as repeated keys (for example `rename-command`),
          except {option}`services.kvrocks.settings.bind` which is space-separated
          on a single line.
        '';
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to open the firewall for the kvrocks port.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = hasTcp || hasUnixSocket;
        message = "services.kvrocks: set settings.bind and/or settings.unixsocket.";
      }
      {
        assertion = cfg.socketActivation -> builtins.length cfg.settings.bind == 1;
        message = "services.kvrocks.socketActivation requires exactly one settings.bind address.";
      }
    ];

    networking.firewall.allowedTCPPorts = lib.mkIf (cfg.openFirewall && hasTcp) [
      cfg.settings.port
    ];

    systemd.tmpfiles.settings."10-kvrocks" = lib.mkIf (!isDefaultDir) {
      ${dataDir}.d = {
        user = cfg.user;
        group = cfg.group;
        mode = "0700";
      };
    };

    systemd.sockets.kvrocks = lib.mkIf cfg.socketActivation {
      description = "Kvrocks socket";
      wantedBy = [ "sockets.target" ];
      listenStreams =
        let
          addr = builtins.head cfg.settings.bind;
          port = toString cfg.settings.port;
          listenStream = if lib.hasInfix ":" addr then "[${addr}]:${port}" else "${addr}:${port}";
        in
        lib.singleton listenStream;
      socketConfig = {
        Accept = false;
        SocketUser = cfg.user;
        SocketGroup = cfg.group;
      };
    };

    systemd.services.kvrocks = {
      description = "Kvrocks - Distributed key value database";
      documentation = [ "https://kvrocks.apache.org/" ];
      wantedBy = lib.mkIf (!cfg.socketActivation) [ "multi-user.target" ];
      after = [ "network.target" ] ++ lib.optionals cfg.socketActivation [ "kvrocks.socket" ];
      requires = lib.optionals cfg.socketActivation [ "kvrocks.socket" ];

      serviceConfig = {
        Type = "notify";
        ExecStart = "${lib.getExe cfg.package} -c ${configFile}";
        Restart = "on-failure";
        RestartSec = "10s";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = lib.mkIf isDefaultDir "kvrocks";
        StateDirectoryMode = "0700";
        RuntimeDirectory = "kvrocks";
        RuntimeDirectoryMode = "0755";
        BindPaths = lib.mkIf (!isDefaultDir) [ dataDir ];
        LimitNPROC = lib.mkDefault (alwaysOnThreads + dynamicThreadMargin);
        # When rocksdb.max_open_files is -1 (unlimited), fall back to a high limit.
        LimitNOFILE = lib.mkDefault (
          if maxOpenFiles < 0 then 1048576 else maxclients + maxOpenFiles + openFilesReserved
        );
        TimeoutSec = 300;
        NonBlocking = lib.mkIf cfg.socketActivation true;
        # Capabilities
        CapabilityBoundingSet = "";
        # Security
        NoNewPrivileges = true;
        # Sandboxing
        TemporaryFileSystem = [ "/:ro" ];
        BindReadOnlyPaths = [
          builtins.storeDir
          "/etc"
        ];
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        PrivateMounts = true;
        SocketBindDeny = [ "any" ];
        SocketBindAllow = lib.optionals (hasTcp && !cfg.socketActivation) [
          "tcp:${toString cfg.settings.port}"
        ];
        # System Call Filtering
        SystemCallArchitectures = "native";
        SystemCallFilter = "~@cpu-emulation @debug @keyring @memlock @mount @obsolete @privileged @resources @setuid";
      };
    };

    users = {
      users = lib.mkIf (cfg.user == "kvrocks") {
        kvrocks = {
          isSystemUser = true;
          group = cfg.group;
          description = "Kvrocks daemon user";
        };
      };
      groups = lib.mkIf (cfg.group == "kvrocks") {
        kvrocks = { };
      };
    };
  };
}
