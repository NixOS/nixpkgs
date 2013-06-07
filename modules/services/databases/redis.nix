{ config, pkgs, ... }:

with pkgs.lib;

let
  cfg = config.services.redis;
  redisBool = b: if b then "yes" else "no";
  condOption = name: value: if value != null then "${name} ${toString value}" else "";

  redisConfig = pkgs.writeText "redis.conf" ''
    pidfile ${cfg.pidFile}
    port ${toString cfg.port}
    ${condOption "bind" cfg.bind}
    ${condOption "unixsocket" cfg.unixSocket}
    ${condOption "unixsocketperm" cfg.unixSocketPerm}
    timeout ${toString cfg.timeout}
    tcp-keepalive ${toString cfg.tcpKeepAlive}
    loglevel ${cfg.logLevel}
    logfile ${cfg.logfile}
    databases ${toString cfg.databases}
    ${concatMapStrings (d: "save ${toString (builtins.elemAt d 0)} ${toString (builtins.elemAt d 1)}\n") cfg.save}
    stop-writes-on-bgsave-error ${redisBool cfg.stopWritesOnBgSaveError}
    rdbcompression ${redisBool cfg.rdbCompression}
    rdbchecksum ${redisBool cfg.rdbChecksum}
    dbfilename ${cfg.dbFilename}
    dir ${toString cfg.dbpath}
    ${if cfg.slaveOf != null then "slaveof ${cfg.slaveOf.ip} ${toString cfg.slaveOf.port}" else ""}
    ${condOption "masterauth" cfg.masterAuth}
    slave-serve-stale-data ${redisBool cfg.slaveServeStaleData}
    slave-read-only ${redisBool cfg.slaveReadOnly}
    repl-ping-slave-period ${toString cfg.replPingSlavePeriod}
    repl-timeout ${toString cfg.replTimeout}
    repl-disable-tcp-nodelay ${redisBool cfg.replDisableTcpNodelay}
    slave-priority ${toString cfg.slavePriority}
    ${condOption "requirepass" cfg.requirePass}
    ${concatMapStrings (c: "rename-command ${c} ${getAttr c cfg.renameCommand}\"\n") (attrNames cfg.renameCommand)}
    maxclients ${toString cfg.maxClients}
    ${condOption "maxmemory" cfg.maxMemory}
    maxmemory-policy ${cfg.maxMemoryPolicy}
    appendOnly ${redisBool cfg.appendOnly}
    appendfsync ${cfg.appendFsync}
    no-appendfsync-on-rewrite ${redisBool cfg.noAppendFsyncOnRewrite}
    auto-aof-rewrite-percentage ${toString cfg.autoAofRewritePercentage}
    auto-aof-rewrite-min-size ${toString cfg.autoAofRewriteMinSize}
    lua-time-limit ${toString cfg.luaTimeLimit}
    slowlog-log-slower-than ${toString cfg.slowLogLogSlowerThan}
    slowlog-max-len ${toString cfg.slowLogMaxLen}
  '';
in
{

  ###### interface

  options = {

    services.redis = {

      enable = mkOption {
        default = false;
        description = "Whether to enable the Redis server.";
      };

      package = mkOption {
        default = pkgs.redis;
        description = "Which Redis derivation to use.";
      };

      user = mkOption {
        default = "redis";
        description = "User account under which Redis runs";
      };

      pidFile = mkOption {
        default = "/var/lib/redis/redis.pid";
        description = "";
      };

      port = mkOption {
        default = 6379;
        description = "The port for Redis to listen to";
        type = with types; int;
      };

      bind = mkOption {
        default = null; # All interfaces
        description = "The IP interface to bind to";
        example = "127.0.0.1";
      };

      unixSocket = mkOption {
        default = null;
        description = "The path to the socket to bind to";
        example = "/var/run/redis.sock";
      };

      unixSocketPerm = mkOption {
        default = null;
        description = "Permissions for the socket";
      };

      timeout = mkOption {
        default = 0;
        description = "Close the connection after a client is idle for N seconds (0 to disable)";
        type = with types; int;
      };

      tcpKeepAlive = mkOption {
        default = 0;
        description = "If non-zero, use SO_KEEPALIVE to send TCP ACKs to clients in absence of communication.";
        example = 60;
        type = with types; int;
      };

      logLevel = mkOption {
        default = "notice"; # debug, verbose, notice, warning
        example = "debug";
        description = "Specify the server verbosity level, options: debug, verbose, notice, warning";
        type = with types; string;
      };

      logfile = mkOption {
        default = "stdout";
        description = "Specify the log file name. Also 'stdout' can be used to force Redis to log on the standard output.";
        example = "/var/log/redis.log";
        type = with types; string;
      };

      databases = mkOption {
        default = 16;
        description = "Set the number of databases.";
        type = with types; int;
      };

      save = mkOption {
        default = [ [900 1] [300 10] [60 10000] ];
        description = "The schedule in which data is persisted to disk, represented as a list of lists where the first element represent the amount of seconds and the second the number of changes.";
        example = [ [900 1] [300 10] [60 10000] ];
      };

      stopWritesOnBgSaveError = mkOption {
        default = true;
        description = "This will make the user aware (in an hard way) that data is not persisting on disk properly, otherwise chances are that no one will notice and some disaster will happen.";
      };

      rdbCompression = mkOption {
        default = true;
        description = "Compress string objects using LZF when dump .rdb databases";
        type = with types; bool;
      };

      rdbChecksum = mkOption {
        default = true;
        description = "This makes the format more resistant to corruption but there is a performance hit to pay (around 10%) when saving and loading RDB files";
        type = with types; bool;
      };

      dbFilename = mkOption {
        default = "dump.rdb";
        description = "The filename where to dump the DB";
        type = with types; string;
      };

      dbpath = mkOption {
        default = "/var/lib/redis";
        description = "The DB will be written inside this directory, with the filename specified using the 'dbFilename' configuration";
        type = with types; string;
      };

      slaveOf = mkOption {
        default = null; # { ip, port }
        description = "An attribute set with two attributes: ip and port to which this redis instance acts as a slave";
        example = { ip = "192.168.1.100"; port = 6379; };
      };

      masterAuth = mkOption {
        default = null;
        description = ''If the master is password protected (using the requirePass configuration)
        it is possible to tell the slave to authenticate before starting the replication synchronization
        process, otherwise the master will refuse the slave request.'';
      };

      slaveServeStaleData = mkOption {
        default = true;
        description = "Whether or not to serve data (as a slave) when data is still (not yet in sync)";
        type = with types; bool;
      };

      slaveReadOnly = mkOption {
        default = true;
        description = "Configure whether this slave instance should accept writes or not";
        type = with types; bool;
      };

      replPingSlavePeriod = mkOption {
        default = 10;
        description = "Slaves send PINGs to server in a predefined interval, configure the number of seconds that this PING should occur.";
        type = with types; int;
      };

      replTimeout = mkOption {
        default = 60;
        description = "Sets a timeout for both Bulk transfer I/O timeout and master data or ping response timeout";
        type = with types; int;
      };

      replDisableTcpNodelay = mkOption {
        default = false;
        description = "Disable TCP_NODELAY on the slave socket after SYNC";
        type = with types; bool;
      };

      slavePriority = mkOption {
        default = 100;
        description = "Priority to be promoted to new master by Redis sentinel";
        type = with types; int;
      };

      requirePass = mkOption {
        default = null;
        description = "Password for database";
        example = "letmein!";
      };

      renameCommand = mkOption {
        default = {}; # oldname = newname
        description = "Attribute set to rename commands e.g. for security reasons.";
        example = { config = "123haefhahefconfig"; };
      };

      maxClients = mkOption {
        default = 10000;
        description = "Maximum number of concurrent clients.";
        type = with types; int;
      };

      maxMemory = mkOption {
        default = null; # in bytes
        description = "Maximum number of bytes of memory to use";
      };

      maxMemoryPolicy = mkOption {
        default = "volatile-lru";
        description = "Policy to handle running out of memory, options: allkeys-lru, volatile-random, allkeys-random, volatile-ttl, noeviction";
        type = with types; string;
      };

      appendOnly = mkOption {
        default = false;
        description = "By default data is only periodically persisted to disk, enable this option to use an append-only file for improved persistence.";
        type = with types; bool;
      };

      appendOnlyFilename = mkOption {
        default = "appendonly.aof";
        description = "Filename for the append-only file (stored inside of dbpath)";
        type = with types; string;
      };

      appendFsync = mkOption {
        default = "everysec"; # no, always, everysec
        description = "How often to fsync the append-only log, options: no, always, everysec";
        type = with types; string;
      };

      noAppendFsyncOnRewrite = mkOption {
        default = false;
        description = "Do not allow fsyncing of append-only log during rewrites";
        type = with types; bool;
      };

      autoAofRewritePercentage = mkOption {
        default = 100;
        description = "Automatically rewrite (= reduce size) of append-only file when file grows with this percentage.";
        type = with types; int;
      };

      autoAofRewriteMinSize = mkOption {
        default = "64mb";
        description = "Minimal size to start rewriting.";
        type = with types; string;
      };

      luaTimeLimit = mkOption {
        default = 5000;
        description = "Maximum execution time for Lua scripts in milliseconds";
        type = with types; int;
      };

      slowLogLogSlowerThan = mkOption {
        default = 10000;
        description = "Log queries whose execution take longer than X in milliseconds";
        example = 1000;
        type = with types; int;
      };

      slowLogMaxLen = mkOption {
        default = 128;
        description = "Maximum number of items to keep in slow log";
        type = with types; int;
      };
    };

  };


  ###### implementation

  config = mkIf config.services.redis.enable {

    users.extraUsers = singleton
      { name = cfg.user;
        description = "Redis database user";
      };

    environment.systemPackages = [ pkgs.redis ];

    systemd.services.redis_init =
      { description = "Redis server initialisation";

        wantedBy = [ "redis.service" ];
        before = [ "redis.service" ];

        serviceConfig.Type = "oneshot";

        script = ''
          if ! test -e ${cfg.dbpath}; then
              install -d -m0700 -o ${cfg.user} ${cfg.dbpath}
          fi
        '';
      };

    systemd.services.redis =
      { description = "Redis server";

        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        serviceConfig = {
          ExecStart = "${pkgs.redis}/bin/redis-server ${redisConfig}";
          User = cfg.user;
        };
      };

  };

}
