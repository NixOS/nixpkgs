{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.redis;

  mkValueString = value:
    if value == true then "yes"
    else if value == false then "no"
    else generators.mkValueStringDefault { } value;

  redisConfig = settings: pkgs.writeText "redis.conf" (generators.toKeyValue {
    listsAsDuplicateKeys = true;
    mkKeyValue = generators.mkKeyValueDefault { inherit mkValueString; } " ";
  } settings);

  redisName = name: "redis" + optionalString (name != "") ("-"+name);
  enabledServers = filterAttrs (name: conf: conf.enable) config.services.redis.servers;

in {
  imports = [
    (mkRemovedOptionModule [ "services" "redis" "user" ] "The redis module now is hardcoded to the redis user.")
    (mkRemovedOptionModule [ "services" "redis" "dbpath" ] "The redis module now uses /var/lib/redis as data directory.")
    (mkRemovedOptionModule [ "services" "redis" "dbFilename" ] "The redis module now uses /var/lib/redis/dump.rdb as database dump location.")
    (mkRemovedOptionModule [ "services" "redis" "appendOnlyFilename" ] "This option was never used.")
    (mkRemovedOptionModule [ "services" "redis" "pidFile" ] "This option was removed.")
    (mkRemovedOptionModule [ "services" "redis" "extraConfig" ] "Use services.redis.servers.*.settings instead.")
    (mkRenamedOptionModule [ "services" "redis" "enable"] [ "services" "redis" "servers" "" "enable" ])
    (mkRenamedOptionModule [ "services" "redis" "port"] [ "services" "redis" "servers" "" "port" ])
    (mkRenamedOptionModule [ "services" "redis" "openFirewall"] [ "services" "redis" "servers" "" "openFirewall" ])
    (mkRenamedOptionModule [ "services" "redis" "bind"] [ "services" "redis" "servers" "" "bind" ])
    (mkRenamedOptionModule [ "services" "redis" "unixSocket"] [ "services" "redis" "servers" "" "unixSocket" ])
    (mkRenamedOptionModule [ "services" "redis" "unixSocketPerm"] [ "services" "redis" "servers" "" "unixSocketPerm" ])
    (mkRenamedOptionModule [ "services" "redis" "logLevel"] [ "services" "redis" "servers" "" "logLevel" ])
    (mkRenamedOptionModule [ "services" "redis" "logfile"] [ "services" "redis" "servers" "" "logfile" ])
    (mkRenamedOptionModule [ "services" "redis" "syslog"] [ "services" "redis" "servers" "" "syslog" ])
    (mkRenamedOptionModule [ "services" "redis" "databases"] [ "services" "redis" "servers" "" "databases" ])
    (mkRenamedOptionModule [ "services" "redis" "maxclients"] [ "services" "redis" "servers" "" "maxclients" ])
    (mkRenamedOptionModule [ "services" "redis" "save"] [ "services" "redis" "servers" "" "save" ])
    (mkRenamedOptionModule [ "services" "redis" "slaveOf"] [ "services" "redis" "servers" "" "slaveOf" ])
    (mkRenamedOptionModule [ "services" "redis" "masterAuth"] [ "services" "redis" "servers" "" "masterAuth" ])
    (mkRenamedOptionModule [ "services" "redis" "requirePass"] [ "services" "redis" "servers" "" "requirePass" ])
    (mkRenamedOptionModule [ "services" "redis" "requirePassFile"] [ "services" "redis" "servers" "" "requirePassFile" ])
    (mkRenamedOptionModule [ "services" "redis" "appendOnly"] [ "services" "redis" "servers" "" "appendOnly" ])
    (mkRenamedOptionModule [ "services" "redis" "appendFsync"] [ "services" "redis" "servers" "" "appendFsync" ])
    (mkRenamedOptionModule [ "services" "redis" "slowLogLogSlowerThan"] [ "services" "redis" "servers" "" "slowLogLogSlowerThan" ])
    (mkRenamedOptionModule [ "services" "redis" "slowLogMaxLen"] [ "services" "redis" "servers" "" "slowLogMaxLen" ])
    (mkRenamedOptionModule [ "services" "redis" "settings"] [ "services" "redis" "servers" "" "settings" ])
  ];

  ###### interface

  options = {

    services.redis = {
      package = mkOption {
        type = types.package;
        default = pkgs.redis;
        defaultText = literalExpression "pkgs.redis";
        description = lib.mdDoc "Which Redis derivation to use.";
      };

      vmOverCommit = mkEnableOption ''
        setting of vm.overcommit_memory to 1
        (Suggested for Background Saving: http://redis.io/topics/faq)
      '';

      servers = mkOption {
        type = with types; attrsOf (submodule ({config, name, ...}@args: {
          options = {
            enable = mkEnableOption ''
              Redis server.

              Note that the NixOS module for Redis disables kernel support
              for Transparent Huge Pages (THP),
              because this features causes major performance problems for Redis,
              e.g. (https://redis.io/topics/latency).
            '';

            user = mkOption {
              type = types.str;
              default = redisName name;
              defaultText = literalExpression ''
                if name == "" then "redis" else "redis-''${name}"
              '';
              description = lib.mdDoc "The username and groupname for redis-server.";
            };

            port = mkOption {
              type = types.port;
              default = if name == "" then 6379 else 0;
              defaultText = literalExpression ''if name == "" then 6379 else 0'';
              description = lib.mdDoc ''
                The TCP port to accept connections.
                If port 0 is specified Redis will not listen on a TCP socket.
              '';
            };

            openFirewall = mkOption {
              type = types.bool;
              default = false;
              description = lib.mdDoc ''
                Whether to open ports in the firewall for the server.
              '';
            };

            bind = mkOption {
              type = with types; nullOr str;
              default = "127.0.0.1";
              description = lib.mdDoc ''
                The IP interface to bind to.
                `null` means "all interfaces".
              '';
              example = "192.0.2.1";
            };

            unixSocket = mkOption {
              type = with types; nullOr path;
              default = "/run/${redisName name}/redis.sock";
              defaultText = literalExpression ''
                if name == "" then "/run/redis/redis.sock" else "/run/redis-''${name}/redis.sock"
              '';
              description = lib.mdDoc "The path to the socket to bind to.";
            };

            unixSocketPerm = mkOption {
              type = types.int;
              default = 660;
              description = lib.mdDoc "Change permissions for the socket";
              example = 600;
            };

            logLevel = mkOption {
              type = types.str;
              default = "notice"; # debug, verbose, notice, warning
              example = "debug";
              description = lib.mdDoc "Specify the server verbosity level, options: debug, verbose, notice, warning.";
            };

            logfile = mkOption {
              type = types.str;
              default = "/dev/null";
              description = lib.mdDoc "Specify the log file name. Also 'stdout' can be used to force Redis to log on the standard output.";
              example = "/var/log/redis.log";
            };

            syslog = mkOption {
              type = types.bool;
              default = true;
              description = lib.mdDoc "Enable logging to the system logger.";
            };

            databases = mkOption {
              type = types.int;
              default = 16;
              description = lib.mdDoc "Set the number of databases.";
            };

            maxclients = mkOption {
              type = types.int;
              default = 10000;
              description = lib.mdDoc "Set the max number of connected clients at the same time.";
            };

            save = mkOption {
              type = with types; listOf (listOf int);
              default = [ [900 1] [300 10] [60 10000] ];
              description = mdDoc ''
                The schedule in which data is persisted to disk, represented as a list of lists where the first element represent the amount of seconds and the second the number of changes.

                If set to the empty list (`[]`) then RDB persistence will be disabled (useful if you are using AOF or don't want any persistence).
              '';
            };

            slaveOf = mkOption {
              type = with types; nullOr (submodule ({ ... }: {
                options = {
                  ip = mkOption {
                    type = str;
                    description = lib.mdDoc "IP of the Redis master";
                    example = "192.168.1.100";
                  };

                  port = mkOption {
                    type = port;
                    description = lib.mdDoc "port of the Redis master";
                    default = 6379;
                  };
                };
              }));

              default = null;
              description = lib.mdDoc "IP and port to which this redis instance acts as a slave.";
              example = { ip = "192.168.1.100"; port = 6379; };
            };

            masterAuth = mkOption {
              type = with types; nullOr str;
              default = null;
              description = lib.mdDoc ''If the master is password protected (using the requirePass configuration)
              it is possible to tell the slave to authenticate before starting the replication synchronization
              process, otherwise the master will refuse the slave request.
              (STORED PLAIN TEXT, WORLD-READABLE IN NIX STORE)'';
            };

            requirePass = mkOption {
              type = with types; nullOr str;
              default = null;
              description = lib.mdDoc ''
                Password for database (STORED PLAIN TEXT, WORLD-READABLE IN NIX STORE).
                Use requirePassFile to store it outside of the nix store in a dedicated file.
              '';
              example = "letmein!";
            };

            requirePassFile = mkOption {
              type = with types; nullOr path;
              default = null;
              description = lib.mdDoc "File with password for the database.";
              example = "/run/keys/redis-password";
            };

            appendOnly = mkOption {
              type = types.bool;
              default = false;
              description = lib.mdDoc "By default data is only periodically persisted to disk, enable this option to use an append-only file for improved persistence.";
            };

            appendFsync = mkOption {
              type = types.str;
              default = "everysec"; # no, always, everysec
              description = lib.mdDoc "How often to fsync the append-only log, options: no, always, everysec.";
            };

            slowLogLogSlowerThan = mkOption {
              type = types.int;
              default = 10000;
              description = lib.mdDoc "Log queries whose execution take longer than X in milliseconds.";
              example = 1000;
            };

            slowLogMaxLen = mkOption {
              type = types.int;
              default = 128;
              description = lib.mdDoc "Maximum number of items to keep in slow log.";
            };

            settings = mkOption {
              # TODO: this should be converted to freeformType
              type = with types; attrsOf (oneOf [ bool int str (listOf str) ]);
              default = {};
              description = lib.mdDoc ''
                Redis configuration. Refer to
                <https://redis.io/topics/config>
                for details on supported values.
              '';
              example = literalExpression ''
                {
                  loadmodule = [ "/path/to/my_module.so" "/path/to/other_module.so" ];
                }
              '';
            };
          };
          config.settings = mkMerge [
            {
              port = config.port;
              daemonize = false;
              supervised = "systemd";
              loglevel = config.logLevel;
              logfile = config.logfile;
              syslog-enabled = config.syslog;
              databases = config.databases;
              maxclients = config.maxclients;
              save = if config.save == []
                then ''""'' # Disable saving with `save = ""`
                else map
                  (d: "${toString (builtins.elemAt d 0)} ${toString (builtins.elemAt d 1)}")
                  config.save;
              dbfilename = "dump.rdb";
              dir = "/var/lib/${redisName name}";
              appendOnly = config.appendOnly;
              appendfsync = config.appendFsync;
              slowlog-log-slower-than = config.slowLogLogSlowerThan;
              slowlog-max-len = config.slowLogMaxLen;
            }
            (mkIf (config.bind != null) { bind = config.bind; })
            (mkIf (config.unixSocket != null) {
              unixsocket = config.unixSocket;
              unixsocketperm = toString config.unixSocketPerm;
            })
            (mkIf (config.slaveOf != null) { slaveof = "${config.slaveOf.ip} ${toString config.slaveOf.port}"; })
            (mkIf (config.masterAuth != null) { masterauth = config.masterAuth; })
            (mkIf (config.requirePass != null) { requirepass = config.requirePass; })
          ];
        }));
        description = lib.mdDoc "Configuration of multiple `redis-server` instances.";
        default = {};
      };
    };

  };


  ###### implementation

  config = mkIf (enabledServers != {}) {

    assertions = attrValues (mapAttrs (name: conf: {
      assertion = conf.requirePass != null -> conf.requirePassFile == null;
      message = ''
        You can only set one services.redis.servers.${name}.requirePass
        or services.redis.servers.${name}.requirePassFile
      '';
    }) enabledServers);

    boot.kernel.sysctl = mkMerge [
      { "vm.nr_hugepages" = "0"; }
      ( mkIf cfg.vmOverCommit { "vm.overcommit_memory" = "1"; } )
    ];

    networking.firewall.allowedTCPPorts = concatMap (conf:
      optional conf.openFirewall conf.port
    ) (attrValues enabledServers);

    environment.systemPackages = [ cfg.package ];

    users.users = mapAttrs' (name: conf: nameValuePair (redisName name) {
      description = "System user for the redis-server instance ${name}";
      isSystemUser = true;
      group = redisName name;
    }) enabledServers;
    users.groups = mapAttrs' (name: conf: nameValuePair (redisName name) {
    }) enabledServers;

    systemd.services = mapAttrs' (name: conf: nameValuePair (redisName name) {
      description = "Redis Server - ${redisName name}";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/redis-server /run/${redisName name}/redis.conf";
        ExecStartPre = [("+"+pkgs.writeShellScript "${redisName name}-credentials" (''
            install -o '${conf.user}' -m 600 ${redisConfig conf.settings} /run/${redisName name}/redis.conf
          '' + optionalString (conf.requirePassFile != null) ''
            {
              printf requirePass' '
              cat ${escapeShellArg conf.requirePassFile}
            } >>/run/${redisName name}/redis.conf
          '')
        )];
        Type = "notify";
        # User and group
        User = conf.user;
        Group = conf.user;
        # Runtime directory and mode
        RuntimeDirectory = redisName name;
        RuntimeDirectoryMode = "0750";
        # State directory and mode
        StateDirectory = redisName name;
        StateDirectoryMode = "0700";
        # Access write directories
        UMask = "0077";
        # Capabilities
        CapabilityBoundingSet = "";
        # Security
        NoNewPrivileges = true;
        # Process Properties
        LimitNOFILE = mkDefault "${toString (conf.maxclients + 32)}";
        # Sandboxing
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
        RestrictAddressFamilies =
          optionals (conf.port != 0) ["AF_INET" "AF_INET6"] ++
          optional (conf.unixSocket != null) "AF_UNIX";
        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        PrivateMounts = true;
        # System Call Filtering
        SystemCallArchitectures = "native";
        SystemCallFilter = "~@cpu-emulation @debug @keyring @memlock @mount @obsolete @privileged @resources @setuid";
      };
    }) enabledServers;

  };
}
