# This is a more up-to-date version of the InfluxDB module compared to the one I
# see in nixos-15.09.
# This whole file can be removed once InfluxDB 0.11 has made its way into
# upstream nixpkgs.
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.influxdb011;

  remarshal = (pkgs.callPackage ../packages/remarshal.nix { }).bin //
    { outputs = [ "bin" ]; };

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

    collectd = {
      enabled = false;
      typesdb = "${pkgs.collectd}/share/collectd/types.db";
      database = "collectd_db";
      port = 25826;
    };

    opentsdb = {
      enabled = false;
    };

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
    buildInputs = [ remarshal ];
  } ''
    remarshal -if json -of toml \
      < ${pkgs.writeText "config.json" (builtins.toJSON configOptions)} \
      > $out
  '';
in
{

  ###### interface

  options = {

    services.influxdb011 = {

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

  config = mkIf config.services.influxdb011.enable {

    systemd.services.influxdb = {
      description = "InfluxDB 0.10 Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-interfaces.target" ];
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
