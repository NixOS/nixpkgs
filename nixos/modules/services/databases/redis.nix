{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.redis;
  redisBool = b: if b then "yes" else "no";
  condOption = name: value: if value != null then "${name} ${toString value}" else "";

  redisConfig = pkgs.writeText "redis.conf" ''
    pidfile ${cfg.pidFile}
    port ${toString cfg.port}
    ${condOption "bind" cfg.bind}
    ${condOption "unixsocket" cfg.unixSocket}
    loglevel ${cfg.logLevel}
    logfile ${cfg.logfile}
    syslog-enabled ${redisBool cfg.syslog}
    databases ${toString cfg.databases}
    ${concatMapStrings (d: "save ${toString (builtins.elemAt d 0)} ${toString (builtins.elemAt d 1)}\n") cfg.save}
    dbfilename ${cfg.dbFilename}
    dir ${toString cfg.dbpath}
    ${if cfg.slaveOf != null then "slaveof ${cfg.slaveOf.ip} ${toString cfg.slaveOf.port}" else ""}
    ${condOption "masterauth" cfg.masterAuth}
    ${condOption "requirepass" cfg.requirePass}
    appendOnly ${redisBool cfg.appendOnly}
    appendfsync ${cfg.appendFsync}
    slowlog-log-slower-than ${toString cfg.slowLogLogSlowerThan}
    slowlog-max-len ${toString cfg.slowLogMaxLen}
    ${cfg.extraConfig}
  '';
in
{

  ###### interface

  options = {

    services.redis = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the Redis server.";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.redis;
        defaultText = "pkgs.redis";
        description = "Which Redis derivation to use.";
      };

      user = mkOption {
        type = types.str;
        default = "redis";
        description = "User account under which Redis runs.";
      };

      pidFile = mkOption {
        type = types.path;
        default = "/var/lib/redis/redis.pid";
        description = "";
      };

      port = mkOption {
        type = types.int;
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
        default = null; # All interfaces
        description = "The IP interface to bind to.";
        example = "127.0.0.1";
      };

      unixSocket = mkOption {
        type = with types; nullOr path;
        default = null;
        description = "The path to the socket to bind to.";
        example = "/run/redis.sock";
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

      save = mkOption {
        type = with types; listOf (listOf int);
        default = [ [900 1] [300 10] [60 10000] ];
        description = "The schedule in which data is persisted to disk, represented as a list of lists where the first element represent the amount of seconds and the second the number of changes.";
        example = [ [900 1] [300 10] [60 10000] ];
      };

      dbFilename = mkOption {
        type = types.str;
        default = "dump.rdb";
        description = "The filename where to dump the DB.";
      };

      dbpath = mkOption {
        type = types.path;
        default = "/var/lib/redis";
        description = "The DB will be written inside this directory, with the filename specified using the 'dbFilename' configuration.";
      };

      slaveOf = mkOption {
        default = null; # { ip, port }
        description = "An attribute set with two attributes: ip and port to which this redis instance acts as a slave.";
        example = { ip = "192.168.1.100"; port = 6379; };
      };

      masterAuth = mkOption {
        default = null;
        description = ''If the master is password protected (using the requirePass configuration)
        it is possible to tell the slave to authenticate before starting the replication synchronization
        process, otherwise the master will refuse the slave request.
        (STORED PLAIN TEXT, WORLD-READABLE IN NIX STORE)'';
      };

      requirePass = mkOption {
        type = with types; nullOr str;
        default = null;
        description = "Password for database (STORED PLAIN TEXT, WORLD-READABLE IN NIX STORE)";
        example = "letmein!";
      };

      appendOnly = mkOption {
        type = types.bool;
        default = false;
        description = "By default data is only periodically persisted to disk, enable this option to use an append-only file for improved persistence.";
      };

      appendOnlyFilename = mkOption {
        type = types.str;
        default = "appendonly.aof";
        description = "Filename for the append-only file (stored inside of dbpath)";
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

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Extra configuration options for redis.conf.";
      };
    };

  };


  ###### implementation

  config = mkIf config.services.redis.enable {

    boot.kernel.sysctl = mkIf cfg.vmOverCommit {
      "vm.overcommit_memory" = "1";
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    users.users.redis =
      { name = cfg.user;
        description = "Redis database user";
      };

    environment.systemPackages = [ cfg.package ];

    systemd.services.redis_init =
      { description = "Redis Server Initialisation";

        wantedBy = [ "redis.service" ];
        before = [ "redis.service" ];

        serviceConfig.Type = "oneshot";

        script = ''
          install -d -m0700 -o ${cfg.user} ${cfg.dbpath}
          chown -R ${cfg.user} ${cfg.dbpath}
        '';
      };

    systemd.services.redis =
      { description = "Redis Server";

        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        serviceConfig = {
          ExecStart = "${cfg.package}/bin/redis-server ${redisConfig}";
          User = cfg.user;
        };
      };

  };

}
