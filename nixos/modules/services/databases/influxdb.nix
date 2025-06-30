{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.influxdb;

  configOptions = lib.recursiveUpdate {
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

    graphite = [
      {
        enabled = false;
      }
    ];

    udp = [
      {
        enabled = false;
      }
    ];

    collectd = [
      {
        enabled = false;
        typesdb = "${pkgs.collectd-data}/share/collectd/types.db";
        database = "collectd_db";
        bind-address = ":25826";
      }
    ];

    opentsdb = [
      {
        enabled = false;
      }
    ];

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

  configFile = (pkgs.formats.toml { }).generate "config.toml" configOptions;
in
{

  ###### interface

  options = {

    services.influxdb = {

      enable = lib.mkOption {
        default = false;
        description = "Whether to enable the influxdb server";
        type = lib.types.bool;
      };

      package = lib.mkPackageOption pkgs "influxdb" { };

      user = lib.mkOption {
        default = "influxdb";
        description = "User account under which influxdb runs";
        type = lib.types.str;
      };

      group = lib.mkOption {
        default = "influxdb";
        description = "Group under which influxdb runs";
        type = lib.types.str;
      };

      dataDir = lib.mkOption {
        default = "/var/db/influxdb";
        description = "Data directory for influxd data files.";
        type = lib.types.path;
      };

      extraConfig = lib.mkOption {
        default = { };
        description = "Extra configuration options for influxdb";
        type = lib.types.attrs;
      };
    };
  };

  ###### implementation

  config = lib.mkIf config.services.influxdb.enable {

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0770 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.influxdb = {
      description = "InfluxDB Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = ''${cfg.package}/bin/influxd -config "${configFile}"'';
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
      };
      postStart =
        let
          scheme = if configOptions.http.https-enabled then "-k https" else "http";
          bindAddr = (ba: if lib.hasPrefix ":" ba then "127.0.0.1${ba}" else "${ba}") (
            toString configOptions.http.bind-address
          );
        in
        lib.mkBefore ''
          until ${pkgs.curl.bin}/bin/curl -s -o /dev/null ${scheme}://${bindAddr}/ping; do
            sleep 1;
          done
        '';
    };

    users.users = lib.optionalAttrs (cfg.user == "influxdb") {
      influxdb = {
        uid = config.ids.uids.influxdb;
        group = "influxdb";
        description = "Influxdb daemon user";
      };
    };

    users.groups = lib.optionalAttrs (cfg.group == "influxdb") {
      influxdb.gid = config.ids.gids.influxdb;
    };
  };

}
