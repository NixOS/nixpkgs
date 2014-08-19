{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.influxdb;

  influxdbConfig = pkgs.writeText "config.toml" ''
    bind-address = "${cfg.bindAddress}"

    [logging]
    level  = "info"
    file   = "stdout"

    [admin]
    port   = ${toString cfg.adminPort}
    assets = "${pkgs.influxdb}/share/influxdb/admin"

    [api]
    port   = ${toString cfg.apiPort}
    ${cfg.apiExtraConfig}

    [input_plugins]
      ${cfg.inputPluginsConfig}

    [raft]
    dir = "${cfg.dataDir}/raft"
    ${cfg.raftConfig}

    [storage]
    dir = "${cfg.dataDir}/db"
    ${cfg.storageConfig}

    [cluster]
    ${cfg.clusterConfig}

    [sharding]
      ${cfg.shardingConfig}

    [wal]
    dir = "${cfg.dataDir}/wal"
    ${cfg.walConfig}

    ${cfg.extraConfig}
  '';
in
{

  ###### interface

  options = {

    services.influxdb = {

      enable = mkOption {
        default = false;
        description = "Whether to enable the influxdb server";
        type = types.uniq types.bool;
      };

      package = mkOption {
        default = pkgs.influxdb;
        description = "Which influxdb derivation to use";
        type = types.package;
      };

      user = mkOption {
        default = "influxdb";
        description = "User account under which influxdb runs";
        type = types.string;
      };

      group = mkOption {
        default = "influxdb";
        description = "Group under which influxdb runs";
        type = types.string;
      };

      dataDir = mkOption {
        default = "/var/db/influxdb";
        description = "Data directory for influxd data files.";
        type = types.path;
      };

      bindAddress = mkOption {
        default = "127.0.0.1";
        description = "Address where influxdb listens";
        type = types.str;
      };

      adminPort = mkOption {
        default = 8083;
        description = "The port where influxdb admin listens";
        type = types.int;
      };

      apiPort = mkOption {
        default = 8086;
        description = "The port where influxdb api listens";
        type = types.int;
      };

      apiExtraConfig = mkOption {
        default = ''
          read-timeout = "5s"
        '';
        description = "Extra influxdb api configuration";
        example = ''
          ssl-port = 8084
          ssl-cert = /path/to/cert.pem
          read-timeout = "5s"
        '';
        type = types.lines;
      };

      inputPluginsConfig = mkOption {
        default = "";
        description = "Configuration of influxdb extra plugins";
        example = ''
          [input_plugins.graphite]
          enabled = true
          port = 2003
          database = "graphite"
        '';
      };

      raftConfig = mkOption {
        default = ''
          port = 8090
        '';
        description = "Influxdb raft configuration";
        type = types.lines;
      };

      storageConfig = mkOption {
        default = ''
          write-buffer-size = 10000
        '';
        description = "Influxdb raft configuration";
        type = types.lines;
      };

      clusterConfig = mkOption {
        default = ''
          protobuf_port = 8099
          protobuf_timeout = "2s"
          protobuf_heartbeat = "200ms"
          protobuf_min_backoff = "1s"
          protobuf_max_backoff = "10s"

          write-buffer-size = 10000
          max-response-buffer-size = 100

          concurrent-shard-query-limit = 10
        '';
        description = "Influxdb cluster configuration";
        type = types.lines;
      };

      leveldbConfig = mkOption {
        default = ''
          max-open-files = 40
          lru-cache-size = "200m"
          max-open-shards = 0
          point-batch-size = 100
          write-batch-size = 5000000
        '';
        description = "Influxdb leveldb configuration";
        type = types.lines;
      };

      shardingConfig = mkOption {
        default = ''
          replication-factor = 1

          [sharding.short-term]
          duration = "7d"
          split = 1

          [sharding.long-term]
          duration = "30d"
          split = 1
        '';
        description = "Influxdb sharding configuration";
        type = types.lines;
      };

      walConfig = mkOption {
        default = ''
          flush-after = 1000
          bookmark-after = 1000
          index-after = 1000
          requests-per-logfile = 10000
        '';
        description = "Influxdb write-ahead log configuration";
        type = types.lines;
      };

      extraConfig = mkOption {
        default = "";
        description = "Extra configuration options for influxdb";
        type = types.string;
      };
    };

  };


  ###### implementation

  config = mkIf config.services.influxdb.enable {

    systemd.services.influxdb = {
      description = "InfluxDB Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-interfaces.target" ];
      serviceConfig = {
        ExecStart = ''${cfg.package}/bin/influxdb -config "${influxdbConfig}"'';
        User = "${cfg.user}";
        Group = "${cfg.group}";
        PermissionsStartOnly = true;
      };
      preStart = ''
        mkdir -m 0770 -p ${cfg.dataDir}
        if [ "$(id -u)" = 0 ]; then chown -R ${cfg.user}:${cfg.group} ${cfg.dataDir}; fi
      '';
    };

    users.extraUsers = optional (cfg.user == "influxdb") {
      name = "influxdb";
      uid = config.ids.uids.influxdb;
      description = "Influxdb daemon user";
    };

    users.extraGroups = optional (cfg.group == "influxdb") {
      name = "influxdb";
      gid = config.ids.gids.influxdb;
    };
  };

}
