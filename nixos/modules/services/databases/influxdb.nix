{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.influxdb;

  settingsFormat = pkgs.formats.toml { };
in
{

  ###### interface

  options = {

    services.influxdb = {

      enable = lib.mkEnableOption "the influxdb server";

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

      settings = lib.mkOption {
        default = { };
        description = "Extra configuration options for influxdb";
        type = lib.types.submodule {
          freeformType = settingsFormat.type;
          config =
            let
              mkAllOptionDefault = lib.mapAttrs (n: lib.mkOptionDefault);
            in
            {
              meta = mkAllOptionDefault {
                bind-address = ":8088";
                commit-timeout = "50ms";
                dir = "${cfg.dataDir}/meta";
                election-timeout = "1s";
                heartbeat-timeout = "1s";
                hostname = "localhost";
                leader-lease-timeout = "500ms";
                retention-autocreate = true;
              };

              data = mkAllOptionDefault {
                dir = "${cfg.dataDir}/data";
                wal-dir = "${cfg.dataDir}/wal";
                max-wal-size = 104857600;
                wal-enable-logging = true;
                wal-flush-interval = "10m";
                wal-partition-flush-delay = "2s";
              };

              cluster = mkAllOptionDefault {
                shard-writer-timeout = "5s";
                write-timeout = "5s";
              };

              retention = mkAllOptionDefault {
                enabled = true;
                check-interval = "30m";
              };

              http = mkAllOptionDefault {
                enabled = true;
                auth-enabled = false;
                bind-address = ":8086";
                https-enabled = false;
                log-enabled = true;
                pprof-enabled = false;
                write-tracing = false;
              };

              monitor = mkAllOptionDefault {
                store-enabled = false;
                store-database = "_internal";
                store-interval = "10s";
              };

              admin = mkAllOptionDefault {
                enabled = true;
                bind-address = ":8083";
                https-enabled = false;
              };

              # We can't make lists sensibly overrideable, so you have to override
              # them whole
              graphite = lib.mkOptionDefault [
                {
                  enabled = false;
                }
              ];

              udp = lib.mkOptionDefault [
                {
                  enabled = false;
                }
              ];

              collectd = lib.mkOptionDefault [
                {
                  enabled = false;
                  typesdb = "${pkgs.collectd-data}/share/collectd/types.db";
                  database = "collectd_db";
                  bind-address = ":25826";
                }
              ];

              opentsdb = lib.mkOptionDefault [
                {
                  enabled = false;
                }
              ];

              continuous_queries = mkAllOptionDefault {
                enabled = true;
                log-enabled = true;
                recompute-previous-n = 2;
                recompute-no-older-than = "10m";
                compute-runs-per-interval = 10;
                compute-no-more-than = "2m";
              };

              hinted-handoff = mkAllOptionDefault {
                enabled = true;
                dir = "${cfg.dataDir}/hh";
                max-size = 1073741824;
                max-age = "168h";
                retry-rate-limit = 0;
                retry-interval = "1s";
              };
            };
        };
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
        ExecStart = ''${cfg.package}/bin/influxd -config "${settingsFormat.generate "config.toml" cfg.settings}"'';
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
      };
      postStart =
        let
          scheme = if cfg.settings.http.https-enabled or false then "-k https" else "http";
          inherit (cfg.settings.http) bind-address;
          bindAddr = if lib.hasPrefix ":" bind-address then "127.0.0.1${bind-address}" else bind-address;
        in
        lib.mkBefore ''
          until ${pkgs.curl.bin}/bin/curl -s -o /dev/null ${scheme}://${bindAddr}/ping; do
            sleep 1;
          done
        '';
    };

    users.users = lib.mkIf (cfg.user == "influxdb") {
      influxdb = {
        uid = config.ids.uids.influxdb;
        group = "influxdb";
        description = "Influxdb daemon user";
      };
    };

    users.groups = lib.mkIf (cfg.group == "influxdb") {
      influxdb.gid = config.ids.gids.influxdb;
    };
  };

  imports = [
    # FIXME remove after 26.11
    (lib.mkRenamedOptionModule
      [ "services" "influxdb" "extraConfig" ]
      [ "services" "influxdb" "settings" ]
    )
  ];
}
