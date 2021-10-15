{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.redis;

  ulimitNofile = cfg.maxclients + 32;

  mkValueString = value:
    if value == true then "yes"
    else if value == false then "no"
    else generators.mkValueStringDefault { } value;

  redisConfig = pkgs.writeText "redis.conf" (generators.toKeyValue {
    listsAsDuplicateKeys = true;
    mkKeyValue = generators.mkKeyValueDefault { inherit mkValueString; } " ";
  } cfg.settings);

in {
  imports = [
    (mkRemovedOptionModule [ "services" "redis" "user" ] "The redis module now is hardcoded to the redis user.")
    (mkRemovedOptionModule [ "services" "redis" "dbpath" ] "The redis module now uses /var/lib/redis as data directory.")
    (mkRemovedOptionModule [ "services" "redis" "dbFilename" ] "The redis module now uses /var/lib/redis/dump.rdb as database dump location.")
    (mkRemovedOptionModule [ "services" "redis" "appendOnlyFilename" ] "This option was never used.")
    (mkRemovedOptionModule [ "services" "redis" "pidFile" ] "This option was removed.")
    (mkRemovedOptionModule [ "services" "redis" "extraConfig" ] "Use services.redis.settings instead.")
  ];

  ###### interface

  options = {

    services.redis = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the Redis server. Note that the NixOS module for
          Redis disables kernel support for Transparent Huge Pages (THP),
          because this features causes major performance problems for Redis,
          e.g. (https://redis.io/topics/latency).
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.redis;
        defaultText = literalExpression "pkgs.redis";
        description = "Which Redis derivation to use.";
      };

      port = mkOption {
        type = types.port;
        default = 6379;
        description = "The port for Redis to listen to.";
      };

      vmOverCommit = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Set vm.overcommit_memory to 1 (Suggested for Background Saving: http://redis.io/topics/faq)
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to open ports in the firewall for the server.
        '';
      };

      bind = mkOption {
        type = with types; nullOr str;
        default = "127.0.0.1";
        description = ''
          The IP interface to bind to.
          <literal>null</literal> means "all interfaces".
        '';
        example = "192.0.2.1";
      };

      unixSocket = mkOption {
        type = with types; nullOr path;
        default = null;
        description = "The path to the socket to bind to.";
        example = "/run/redis/redis.sock";
      };

      unixSocketPerm = mkOption {
        type = types.int;
        default = 750;
        description = "Change permissions for the socket";
        example = 700;
      };

      logLevel = mkOption {
        type = types.str;
        default = "notice"; # debug, verbose, notice, warning
        example = "debug";
        description = "Specify the server verbosity level, options: debug, verbose, notice, warning.";
      };

      logfile = mkOption {
        type = types.str;
        default = "/dev/null";
        description = "Specify the log file name. Also 'stdout' can be used to force Redis to log on the standard output.";
        example = "/var/log/redis.log";
      };

      syslog = mkOption {
        type = types.bool;
        default = true;
        description = "Enable logging to the system logger.";
      };

      databases = mkOption {
        type = types.int;
        default = 16;
        description = "Set the number of databases.";
      };

      maxclients = mkOption {
        type = types.int;
        default = 10000;
        description = "Set the max number of connected clients at the same time.";
      };

      save = mkOption {
        type = with types; listOf (listOf int);
        default = [ [900 1] [300 10] [60 10000] ];
        description = "The schedule in which data is persisted to disk, represented as a list of lists where the first element represent the amount of seconds and the second the number of changes.";
      };

      slaveOf = mkOption {
        type = with types; nullOr (submodule ({ ... }: {
          options = {
            ip = mkOption {
              type = str;
              description = "IP of the Redis master";
              example = "192.168.1.100";
            };

            port = mkOption {
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

      masterAuth = mkOption {
        type = with types; nullOr str;
        default = null;
        description = ''If the master is password protected (using the requirePass configuration)
        it is possible to tell the slave to authenticate before starting the replication synchronization
        process, otherwise the master will refuse the slave request.
        (STORED PLAIN TEXT, WORLD-READABLE IN NIX STORE)'';
      };

      requirePass = mkOption {
        type = with types; nullOr str;
        default = null;
        description = ''
          Password for database (STORED PLAIN TEXT, WORLD-READABLE IN NIX STORE).
          Use requirePassFile to store it outside of the nix store in a dedicated file.
        '';
        example = "letmein!";
      };

      requirePassFile = mkOption {
        type = with types; nullOr path;
        default = null;
        description = "File with password for the database.";
        example = "/run/keys/redis-password";
      };

      appendOnly = mkOption {
        type = types.bool;
        default = false;
        description = "By default data is only periodically persisted to disk, enable this option to use an append-only file for improved persistence.";
      };

      appendFsync = mkOption {
        type = types.str;
        default = "everysec"; # no, always, everysec
        description = "How often to fsync the append-only log, options: no, always, everysec.";
      };

      slowLogLogSlowerThan = mkOption {
        type = types.int;
        default = 10000;
        description = "Log queries whose execution take longer than X in milliseconds.";
        example = 1000;
      };

      slowLogMaxLen = mkOption {
        type = types.int;
        default = 128;
        description = "Maximum number of items to keep in slow log.";
      };

      settings = mkOption {
        type = with types; attrsOf (oneOf [ bool int str (listOf str) ]);
        default = {};
        description = ''
          Redis configuration. Refer to
          <link xlink:href="https://redis.io/topics/config"/>
          for details on supported values.
        '';
        example = literalExpression ''
          {
            loadmodule = [ "/path/to/my_module.so" "/path/to/other_module.so" ];
          }
        '';
      };
    };

  };


  ###### implementation

  config = mkIf config.services.redis.enable {
    assertions = [{
      assertion = cfg.requirePass != null -> cfg.requirePassFile == null;
      message = "You can only set one services.redis.requirePass or services.redis.requirePassFile";
    }];
    boot.kernel.sysctl = (mkMerge [
      { "vm.nr_hugepages" = "0"; }
      ( mkIf cfg.vmOverCommit { "vm.overcommit_memory" = "1"; } )
    ]);

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    users.users.redis = {
      description = "Redis database user";
      group = "redis";
      isSystemUser = true;
    };
    users.groups.redis = {};

    environment.systemPackages = [ cfg.package ];

    services.redis.settings = mkMerge [
      {
        port = cfg.port;
        daemonize = false;
        supervised = "systemd";
        loglevel = cfg.logLevel;
        logfile = cfg.logfile;
        syslog-enabled = cfg.syslog;
        databases = cfg.databases;
        maxclients = cfg.maxclients;
        save = map (d: "${toString (builtins.elemAt d 0)} ${toString (builtins.elemAt d 1)}") cfg.save;
        dbfilename = "dump.rdb";
        dir = "/var/lib/redis";
        appendOnly = cfg.appendOnly;
        appendfsync = cfg.appendFsync;
        slowlog-log-slower-than = cfg.slowLogLogSlowerThan;
        slowlog-max-len = cfg.slowLogMaxLen;
      }
      (mkIf (cfg.bind != null) { bind = cfg.bind; })
      (mkIf (cfg.unixSocket != null) { unixsocket = cfg.unixSocket; unixsocketperm = "${toString cfg.unixSocketPerm}"; })
      (mkIf (cfg.slaveOf != null) { slaveof = "${cfg.slaveOf.ip} ${toString cfg.slaveOf.port}"; })
      (mkIf (cfg.masterAuth != null) { masterauth = cfg.masterAuth; })
      (mkIf (cfg.requirePass != null) { requirepass = cfg.requirePass; })
    ];

    systemd.services.redis = {
      description = "Redis Server";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      preStart = ''
        install -m 600 ${redisConfig} /run/redis/redis.conf
      '' + optionalString (cfg.requirePassFile != null) ''
        password=$(cat ${escapeShellArg cfg.requirePassFile})
        echo "requirePass $password" >> /run/redis/redis.conf
      '';

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/redis-server /run/redis/redis.conf";
        Type = "notify";
        # User and group
        User = "redis";
        Group = "redis";
        # Runtime directory and mode
        RuntimeDirectory = "redis";
        RuntimeDirectoryMode = "0750";
        # State directory and mode
        StateDirectory = "redis";
        StateDirectoryMode = "0700";
        # Access write directories
        UMask = "0077";
        # Capabilities
        CapabilityBoundingSet = "";
        # Security
        NoNewPrivileges = true;
        # Process Properties
        LimitNOFILE = "${toString ulimitNofile}";
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
        RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
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
    };
  };
}
