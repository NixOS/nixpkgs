{ config, lib, pkgs, ... }:
let
  cfg = config.services.redis;

  mkValueString = value:
    if value == true then "yes"
    else if value == false then "no"
    else lib.generators.mkValueStringDefault { } value;

  redisConfig = settings: pkgs.writeText "redis.conf" (lib.generators.toKeyValue {
    listsAsDuplicateKeys = true;
    mkKeyValue = lib.generators.mkKeyValueDefault { inherit mkValueString; } " ";
  } settings);

  redisName = name: "redis" + lib.optionalString (name != "") ("-"+name);
  enabledServers = lib.filterAttrs (name: conf: conf.enable) config.services.redis.servers;

in {
  imports = [
    (lib.mkRemovedOptionModule [ "services" "redis" "user" ] "The redis module now is hardcoded to the redis user.")
    (lib.mkRemovedOptionModule [ "services" "redis" "dbpath" ] "The redis module now uses /var/lib/redis as data directory.")
    (lib.mkRemovedOptionModule [ "services" "redis" "dbFilename" ] "The redis module now uses /var/lib/redis/dump.rdb as database dump location.")
    (lib.mkRemovedOptionModule [ "services" "redis" "appendOnlyFilename" ] "This option was never used.")
    (lib.mkRemovedOptionModule [ "services" "redis" "pidFile" ] "This option was removed.")
    (lib.mkRemovedOptionModule [ "services" "redis" "extraConfig" ] "Use services.redis.servers.*.settings instead.")
    (lib.mkRenamedOptionModule [ "services" "redis" "enable"] [ "services" "redis" "servers" "" "enable" ])
    (lib.mkRenamedOptionModule [ "services" "redis" "port"] [ "services" "redis" "servers" "" "port" ])
    (lib.mkRenamedOptionModule [ "services" "redis" "openFirewall"] [ "services" "redis" "servers" "" "openFirewall" ])
    (lib.mkRenamedOptionModule [ "services" "redis" "bind"] [ "services" "redis" "servers" "" "bind" ])
    (lib.mkRenamedOptionModule [ "services" "redis" "unixSocket"] [ "services" "redis" "servers" "" "unixSocket" ])
    (lib.mkRenamedOptionModule [ "services" "redis" "unixSocketPerm"] [ "services" "redis" "servers" "" "unixSocketPerm" ])
    (lib.mkRenamedOptionModule [ "services" "redis" "logLevel"] [ "services" "redis" "servers" "" "logLevel" ])
    (lib.mkRenamedOptionModule [ "services" "redis" "logfile"] [ "services" "redis" "servers" "" "logfile" ])
    (lib.mkRenamedOptionModule [ "services" "redis" "syslog"] [ "services" "redis" "servers" "" "syslog" ])
    (lib.mkRenamedOptionModule [ "services" "redis" "databases"] [ "services" "redis" "servers" "" "databases" ])
    (lib.mkRenamedOptionModule [ "services" "redis" "maxclients"] [ "services" "redis" "servers" "" "maxclients" ])
    (lib.mkRenamedOptionModule [ "services" "redis" "save"] [ "services" "redis" "servers" "" "save" ])
    (lib.mkRenamedOptionModule [ "services" "redis" "slaveOf"] [ "services" "redis" "servers" "" "slaveOf" ])
    (lib.mkRenamedOptionModule [ "services" "redis" "masterAuth"] [ "services" "redis" "servers" "" "masterAuth" ])
    (lib.mkRenamedOptionModule [ "services" "redis" "requirePass"] [ "services" "redis" "servers" "" "requirePass" ])
    (lib.mkRenamedOptionModule [ "services" "redis" "requirePassFile"] [ "services" "redis" "servers" "" "requirePassFile" ])
    (lib.mkRenamedOptionModule [ "services" "redis" "appendOnly"] [ "services" "redis" "servers" "" "appendOnly" ])
    (lib.mkRenamedOptionModule [ "services" "redis" "appendFsync"] [ "services" "redis" "servers" "" "appendFsync" ])
    (lib.mkRenamedOptionModule [ "services" "redis" "slowLogLogSlowerThan"] [ "services" "redis" "servers" "" "slowLogLogSlowerThan" ])
    (lib.mkRenamedOptionModule [ "services" "redis" "slowLogMaxLen"] [ "services" "redis" "servers" "" "slowLogMaxLen" ])
    (lib.mkRenamedOptionModule [ "services" "redis" "settings"] [ "services" "redis" "servers" "" "settings" ])
  ];

  ###### interface

  options = {

    services.redis = {
      package = lib.mkPackageOption pkgs "redis" { };

      vmOverCommit = lib.mkEnableOption ''
        set `vm.overcommit_memory` sysctl to 1
        (Suggested for Background Saving: <https://redis.io/docs/get-started/faq/>)
      '' // { default = true; };

      servers = lib.mkOption {
        type = with lib.types; attrsOf (submodule ({ config, name, ... }: {
          options = {
            enable = lib.mkEnableOption "Redis server";

            user = lib.mkOption {
              type = types.str;
              default = redisName name;
              defaultText = lib.literalExpression ''
                if name == "" then "redis" else "redis-''${name}"
              '';
              description = ''
                User account under which this instance of redis-server runs.

                ::: {.note}
                If left as the default value this user will automatically be
                created on system activation, otherwise you are responsible for
                ensuring the user exists before the redis service starts.
              '';
            };

            group = lib.mkOption {
              type = types.str;
              default = config.user;
              defaultText = lib.literalExpression "config.user";
              description = ''
                Group account under which this instance of redis-server runs.

                ::: {.note}
                If left as the default value this group will automatically be
                created on system activation, otherwise you are responsible for
                ensuring the group exists before the redis service starts.
              '';
            };

            port = lib.mkOption {
              type = types.port;
              default = if name == "" then 6379 else 0;
              defaultText = lib.literalExpression ''if name == "" then 6379 else 0'';
              description = ''
                The TCP port to accept connections.
                If port 0 is specified Redis will not listen on a TCP socket.
              '';
            };

            openFirewall = lib.mkOption {
              type = types.bool;
              default = false;
              description = ''
                Whether to open ports in the firewall for the server.
              '';
            };

            extraParams = lib.mkOption {
              type = with types; listOf str;
              default = [];
              description = "Extra parameters to append to redis-server invocation";
              example = [ "--sentinel" ];
            };

            bind = lib.mkOption {
              type = with types; nullOr str;
              default = "127.0.0.1";
              description = ''
                The IP interface to bind to.
                `null` means "all interfaces".
              '';
              example = "192.0.2.1";
            };

            unixSocket = lib.mkOption {
              type = with types; nullOr path;
              default = "/run/${redisName name}/redis.sock";
              defaultText = lib.literalExpression ''
                if name == "" then "/run/redis/redis.sock" else "/run/redis-''${name}/redis.sock"
              '';
              description = "The path to the socket to bind to.";
            };

            unixSocketPerm = lib.mkOption {
              type = types.int;
              default = 660;
              description = "Change permissions for the socket";
              example = 600;
            };

            logLevel = lib.mkOption {
              type = types.str;
              default = "notice"; # debug, verbose, notice, warning
              example = "debug";
              description = "Specify the server verbosity level, options: debug, verbose, notice, warning.";
            };

            logfile = lib.mkOption {
              type = types.str;
              default = "/dev/null";
              description = "Specify the log file name. Also 'stdout' can be used to force Redis to log on the standard output.";
              example = "/var/log/redis.log";
            };

            syslog = lib.mkOption {
              type = types.bool;
              default = true;
              description = "Enable logging to the system logger.";
            };

            databases = lib.mkOption {
              type = types.int;
              default = 16;
              description = "Set the number of databases.";
            };

            maxclients = lib.mkOption {
              type = types.int;
              default = 10000;
              description = "Set the max number of connected clients at the same time.";
            };

            save = lib.mkOption {
              type = with types; listOf (listOf int);
              default = [ [900 1] [300 10] [60 10000] ];
              description = ''
                The schedule in which data is persisted to disk, represented as a list of lists where the first element represent the amount of seconds and the second the number of changes.

                If set to the empty list (`[]`) then RDB persistence will be disabled (useful if you are using AOF or don't want any persistence).
              '';
            };

            slaveOf = lib.mkOption {
              type = with types; nullOr (submodule ({ ... }: {
                options = {
                  ip = lib.mkOption {
                    type = str;
                    description = "IP of the Redis master";
                    example = "192.168.1.100";
                  };

                  port = lib.mkOption {
                    type = port;
                    description = "port of the Redis master";
                    default = 6379;
                  };
                };
              }));

              default = null;
              description = "IP and port to which this redis instance acts as a slave.";
              example = { ip = "192.168.1.100"; port = 6379; };
            };

            masterAuth = lib.mkOption {
              type = with types; nullOr str;
              default = null;
              description = ''If the master is password protected (using the requirePass configuration)
              it is possible to tell the slave to authenticate before starting the replication synchronization
              process, otherwise the master will refuse the slave request.
              (STORED PLAIN TEXT, WORLD-READABLE IN NIX STORE)'';
            };

            requirePass = lib.mkOption {
              type = with types; nullOr str;
              default = null;
              description = ''
                Password for database (STORED PLAIN TEXT, WORLD-READABLE IN NIX STORE).
                Use requirePassFile to store it outside of the nix store in a dedicated file.
              '';
              example = "letmein!";
            };

            requirePassFile = lib.mkOption {
              type = with types; nullOr path;
              default = null;
              description = "File with password for the database.";
              example = "/run/keys/redis-password";
            };

            appendOnly = lib.mkOption {
              type = types.bool;
              default = false;
              description = "By default data is only periodically persisted to disk, enable this option to use an append-only file for improved persistence.";
            };

            appendFsync = lib.mkOption {
              type = types.str;
              default = "everysec"; # no, always, everysec
              description = "How often to fsync the append-only log, options: no, always, everysec.";
            };

            slowLogLogSlowerThan = lib.mkOption {
              type = types.int;
              default = 10000;
              description = "Log queries whose execution take longer than X in milliseconds.";
              example = 1000;
            };

            slowLogMaxLen = lib.mkOption {
              type = types.int;
              default = 128;
              description = "Maximum number of items to keep in slow log.";
            };

            settings = lib.mkOption {
              # TODO: this should be converted to freeformType
              type = with types; attrsOf (oneOf [ bool int str (listOf str) ]);
              default = {};
              description = ''
                Redis configuration. Refer to
                <https://redis.io/topics/config>
                for details on supported values.
              '';
              example = lib.literalExpression ''
                {
                  loadmodule = [ "/path/to/my_module.so" "/path/to/other_module.so" ];
                }
              '';
            };
          };
          config.settings = lib.mkMerge [
            {
              inherit (config) port logfile databases maxclients appendOnly;
              daemonize = false;
              supervised = "systemd";
              loglevel = config.logLevel;
              syslog-enabled = config.syslog;
              save = if config.save == []
                then ''""'' # Disable saving with `save = ""`
                else map
                  (d: "${toString (builtins.elemAt d 0)} ${toString (builtins.elemAt d 1)}")
                  config.save;
              dbfilename = "dump.rdb";
              dir = "/var/lib/${redisName name}";
              appendfsync = config.appendFsync;
              slowlog-log-slower-than = config.slowLogLogSlowerThan;
              slowlog-max-len = config.slowLogMaxLen;
            }
            (lib.mkIf (config.bind != null) { inherit (config) bind; })
            (lib.mkIf (config.unixSocket != null) {
              unixsocket = config.unixSocket;
              unixsocketperm = toString config.unixSocketPerm;
            })
            (lib.mkIf (config.slaveOf != null) { slaveof = "${config.slaveOf.ip} ${toString config.slaveOf.port}"; })
            (lib.mkIf (config.masterAuth != null) { masterauth = config.masterAuth; })
            (lib.mkIf (config.requirePass != null) { requirepass = config.requirePass; })
          ];
        }));
        description = "Configuration of multiple `redis-server` instances.";
        default = {};
      };
    };

  };


  ###### implementation

  config = lib.mkIf (enabledServers != {}) {

    assertions = lib.attrValues (lib.mapAttrs (name: conf: {
      assertion = conf.requirePass != null -> conf.requirePassFile == null;
      message = ''
        You can only set one services.redis.servers.${name}.requirePass
        or services.redis.servers.${name}.requirePassFile
      '';
    }) enabledServers);

    boot.kernel.sysctl = lib.mkIf cfg.vmOverCommit {
      "vm.overcommit_memory" = "1";
    };

    networking.firewall.allowedTCPPorts = lib.concatMap (conf:
      lib.optional conf.openFirewall conf.port
    ) (lib.attrValues enabledServers);

    environment.systemPackages = [ cfg.package ];

    users.users = lib.mapAttrs' (name: conf: lib.nameValuePair (redisName name) {
      description = "System user for the redis-server instance ${name}";
      isSystemUser = true;
      group = redisName name;
    }) enabledServers;
    users.groups = lib.mapAttrs' (name: conf: lib.nameValuePair (redisName name) {
    }) enabledServers;

    systemd.services = lib.mapAttrs' (name: conf: lib.nameValuePair (redisName name) {
      description = "Redis Server - ${redisName name}";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/${cfg.package.serverBin or "redis-server"} /var/lib/${redisName name}/redis.conf ${lib.escapeShellArgs conf.extraParams}";
        ExecStartPre = "+"+pkgs.writeShellScript "${redisName name}-prep-conf" (let
          redisConfVar = "/var/lib/${redisName name}/redis.conf";
          redisConfRun = "/run/${redisName name}/nixos.conf";
          redisConfStore = redisConfig conf.settings;
        in ''
          touch "${redisConfVar}" "${redisConfRun}"
          chown '${conf.user}':'${conf.group}' "${redisConfVar}" "${redisConfRun}"
          chmod 0600 "${redisConfVar}" "${redisConfRun}"
          if [ ! -s ${redisConfVar} ]; then
            echo 'include "${redisConfRun}"' > "${redisConfVar}"
          fi
          echo 'include "${redisConfStore}"' > "${redisConfRun}"
          ${lib.optionalString (conf.requirePassFile != null) ''
            {
              echo -n "requirepass "
              cat ${lib.escapeShellArg conf.requirePassFile}
            } >> "${redisConfRun}"
          ''}
        '');
        Type = "notify";
        # User and group
        User = conf.user;
        Group = conf.group;
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
        LimitNOFILE = lib.mkDefault "${toString (conf.maxclients + 32)}";
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
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
        RestrictNamespaces = true;
        LockPersonality = true;
        # we need to disable MemoryDenyWriteExecute for keydb
        MemoryDenyWriteExecute = cfg.package.pname != "keydb";
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
