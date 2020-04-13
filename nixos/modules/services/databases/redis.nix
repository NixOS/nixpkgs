{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.redis;
  redisBool = b: if b then "yes" else "no";
  condOption = name: value: if value != null then "${name} ${toString value}" else "";

  redisConfig = pkgs.writeText "redis.conf" ''
    port ${toString cfg.port}
    ${condOption "bind" cfg.bind}
    ${condOption "unixsocket" cfg.unixSocket}
    daemonize yes
    supervised systemd
    loglevel ${cfg.logLevel}
    logfile ${cfg.logfile}
    syslog-enabled ${redisBool cfg.syslog}
    pidfile /run/redis/redis.pid
    databases ${toString cfg.databases}
    ${concatMapStrings (d: "save ${toString (builtins.elemAt d 0)} ${toString (builtins.elemAt d 1)}\n") cfg.save}
    dbfilename dump.rdb
    dir /var/lib/redis
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
  imports = [
    (mkRemovedOptionModule [ "services" "redis" "user" ] "The redis module now is hardcoded to the redis user.")
    (mkRemovedOptionModule [ "services" "redis" "dbpath" ] "The redis module now uses /var/lib/redis as data directory.")
    (mkRemovedOptionModule [ "services" "redis" "dbFilename" ] "The redis module now uses /var/lib/redis/dump.rdb as database dump location.")
    (mkRemovedOptionModule [ "services" "redis" "appendOnlyFilename" ] "This option was never used.")
    (mkRemovedOptionModule [ "services" "redis" "pidFile" ] "This option was removed.")
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
        defaultText = "pkgs.redis";
        description = "Which Redis derivation to use.";
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
        example = "/run/redis/redis.sock";
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

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Extra configuration options for redis.conf.";
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
      isSystemUser = true;
    };

    environment.systemPackages = [ cfg.package ];

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
        RuntimeDirectory = "redis";
        StateDirectory = "redis";
        Type = "notify";
        User = "redis";
      };
    };
  };
}
