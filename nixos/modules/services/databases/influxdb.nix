{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.influxdb;

  configOptions = recursiveUpdate {
    meta = {
      bind-address = ":8088";
      commit-timeout = "50ms";
      dir = "${cfg.dataDir}/meta";
      election-timeout = "1s";
      heartbeat-timeout = "1s";
      hostname = "localhost";
      leader-lease-timeout = "500ms";
      retention-autocreate = true;
    };

    data = {
      dir = "${cfg.dataDir}/data";
      wal-dir = "${cfg.dataDir}/wal";
      max-wal-size = 104857600;
      wal-enable-logging = true;
      wal-flush-interval = "10m";
      wal-partition-flush-delay = "2s";
    };

    cluster = {
      shard-writer-timeout = "5s";
      write-timeout = "5s";
    };

    retention = {
      enabled = true;
      check-interval = "30m";
    };

    http = {
      enabled = true;
      auth-enabled = false;
      bind-address = ":8086";
      https-enabled = false;
      log-enabled = true;
      pprof-enabled = false;
      write-tracing = false;
    };

    monitor = {
      store-enabled = false;
      store-database = "_internal";
      store-interval = "10s";
    };

    admin = {
      enabled = true;
      bind-address = ":8083";
      https-enabled = false;
    };

    graphite = [{
      enabled = false;
    }];

    udp = [{
      enabled = false;
    }];

    collectd = [{
      enabled = false;
      typesdb = "${pkgs.collectd-data}/share/collectd/types.db";
      database = "collectd_db";
      bind-address = ":25826";
    }];

    opentsdb = [{
      enabled = false;
    }];

    continuous_queries = {
      enabled = true;
      log-enabled = true;
      recompute-previous-n = 2;
      recompute-no-older-than = "10m";
      compute-runs-per-interval = 10;
      compute-no-more-than = "2m";
    };

    hinted-handoff = {
      enabled = true;
      dir = "${cfg.dataDir}/hh";
      max-size = 1073741824;
      max-age = "168h";
      retry-rate-limit = 0;
      retry-interval = "1s";
    };
  } cfg.extraConfig;

  configFile = pkgs.runCommand "config.toml" {
    buildInputs = [ pkgs.remarshal ];
    preferLocalBuild = true;
  } ''
    remarshal -if json -of toml \
      < ${pkgs.writeText "config.json" (builtins.toJSON configOptions)} \
      > $out
  '';
in
{

  ###### interface

  options = {

    services.influxdb = {

      enable = mkOption {
        default = false;
        description = "Whether to enable the influxdb server";
        type = types.bool;
      };

      package = mkOption {
        default = pkgs.influxdb;
        defaultText = "pkgs.influxdb";
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

      extraConfig = mkOption {
        default = {};
        description = "Extra configuration options for influxdb";
        type = types.attrs;
      };
    };
  };


  ###### implementation

  config = mkIf config.services.influxdb.enable {

    systemd.services.influxdb = {
      description = "InfluxDB Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = ''${cfg.package}/bin/influxd -config "${configFile}"'';
        User = "${cfg.user}";
        Group = "${cfg.group}";
        PermissionsStartOnly = true;
      };
      preStart = ''
        mkdir -m 0770 -p ${cfg.dataDir}
        if [ "$(id -u)" = 0 ]; then chown -R ${cfg.user}:${cfg.group} ${cfg.dataDir}; fi
      '';
      postStart =
        let
          scheme = if configOptions.http.https-enabled then "-k https" else "http";
          bindAddr = (ba: if hasPrefix ":" ba then "127.0.0.1${ba}" else "${ba}")(toString configOptions.http.bind-address);
        in
        mkBefore ''
          until ${pkgs.curl.bin}/bin/curl -s -o /dev/null ${scheme}://${bindAddr}/ping; do
            sleep 1;
          done
        '';
    };

    users.users = optional (cfg.user == "influxdb") {
      name = "influxdb";
      uid = config.ids.uids.influxdb;
      description = "Influxdb daemon user";
    };

    users.groups = optional (cfg.group == "influxdb") {
      name = "influxdb";
      gid = config.ids.gids.influxdb;
    };
  };

}
