{ config, pkgs, ... }:

with pkgs.lib;

let
  cfg = config.services.graphite;
  writeTextOrNull = f: t: if t == null then null else pkgs.writeText f t;

  dataDir = "/var/db/graphite";

in {

  ###### interface

  options.services.graphite = {
    carbon = mkOption {
      description = "Content of carbon configuration file";
      default = "";
      type = types.uniq types.string;
    };

    enableCarbonCache = mkOption {
      description = "Whether to enable carbon cache, the graphite storage daemon";
      default = false;
      type = types.uniq types.bool;
    };

    storageAggregation = mkOption {
      description = "Defines how to aggregate data to lower-precision retentions";
      default = null;
      type = types.uniq (types.nullOr types.string);
      example = ''
        [all_min]
        pattern = \.min$
        xFilesFactor = 0.1
        aggregationMethod = min
      '';
    };

    storageSchemas = mkOption {
      description = "Defines retention rates for storing metrics";
      default = "";
      type = types.uniq (types.nullOr types.string);
      example = ''
        [apache_busyWorkers]
        pattern = ^servers\.www.*\.workers\.busyWorkers$
        retentions = 15s:7d,1m:21d,15m:5y
      '';
    };

    blacklist = mkOption {
      description = "Any metrics received which match one of the experssions will be dropped";
      default = null;
      type = types.uniq (types.nullOr types.string);
      example = "^some\.noisy\.metric\.prefix\..*";
    };

    whitelist = mkOption {
      description = "Only metrics received which match one of the experssions will be persisted";
      default = null;
      type = types.uniq (types.nullOr types.string);
      example = ".*";
    };

    rewriteRules = mkOption {
      description = "Regular expression patterns that can be used to rewrite metric names in a search and replace fashion";
      default = null;
      type = types.uniq (types.nullOr types.string);
      example = ''
        [post]
        _sum$ =
        _avg$ =
      '';
    };

    enableCarbonRelay = mkOption {
      description = "Whether to enable carbon relay, the carbon replication and sharding service";
      default = false;
      type = types.uniq types.bool;
    };

    relayRules = mkOption {
      description = "Relay rules are used to send certain metrics to a certain backend.";
      default = null;
      type = types.uniq (types.nullOr types.string);
      example = ''
        [example]
        pattern = ^mydata\.foo\..+
        servers = 10.1.2.3, 10.1.2.4:2004, myserver.mydomain.com
      '';
    };

    enableCarbonAggregator = mkOption {
      description = "Whether to enable carbon agregator, the carbon buffering service";
      default = false;
      type = types.uniq types.bool;
    };

    aggregationRules = mkOption {
      description = "Defines if and how received metrics will be agregated";
      default = null;
      type = types.uniq (types.nullOr types.string);
      example = ''
        <env>.applications.<app>.all.requests (60) = sum <env>.applications.<app>.*.requests
        <env>.applications.<app>.all.latency (60) = avg <env>.applications.<app>.*.latency
      '';
    };

    enableGraphiteWeb = mkOption {
      description = "Whether to enable graphite web frontend";
      default = false;
      type = types.uniq types.bool;
    };

  };

  ###### implementation

  config = mkIf (cfg.enableCarbonAggregator || cfg.enableCarbonCache || cfg.enableCarbonRelay || cfg.enableGraphiteWeb) {
    environment.etc = lists.filter (el: el.source != null) [
      { source = writeTextOrNull "carbon.conf" cfg.carbon;
        target = "graphite/carbon.conf"; }
      { source = writeTextOrNull "storage-agregation.conf" cfg.storageAggregation;
        target = "graphite/storage-agregation.conf"; }
      { source = writeTextOrNull "storage-schemas.conf" cfg.storageSchemas;
        target = "graphite/storage-schemas.conf"; }
      { source = writeTextOrNull "blacklist.conf" cfg.blacklist;
        target = "graphite/blacklist.conf"; }
      { source = writeTextOrNull "whitelist.conf" cfg.whitelist;
        target = "graphite/whitelist.conf"; }
      { source = writeTextOrNull "rewrite-rules.conf" cfg.rewriteRules;
        target = "graphite/rewrite-rules.conf"; }
      { source = writeTextOrNull "relay-rules.conf" cfg.relayRules;
        target = "graphite/relay-rules.conf"; }
      { source = writeTextOrNull "aggregation-rules.conf" cfg.aggregationRules;
        target = "graphite/aggregation-rules.conf"; }
    ];

    systemd.services.carbonCache = mkIf cfg.enableCarbonCache {
      description = "Graphite data storage backend";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-interfaces.target" ];
      environment = {
        GRAPHITE_CONF_DIR = "/etc/graphite/";
        GRAPHITE_STORAGE_DIR = "/var/db/graphite/";
      };
      serviceConfig = {
        ExecStart = "${pkgs.pythonPackages.carbon}/bin/carbon-cache.py --debug --pidfile /tmp/carbonCache.pid start";
        User = "graphite";
        Group = "graphite";
      };
      restartTriggers = [
        pkgs.pythonPackages.carbon cfg.carbon
        cfg.storageAggregation cfg.storageSchemas cfg.rewriteRules
      ];
      preStart = ''
        mkdir -p ${dataDir}/whisper
      '';
    };

    systemd.services.carbonAggregator = mkIf cfg.enableCarbonAggregator {
      description = "Carbon data aggregator";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-interfaces.target" ];
      environment = {
        GRAPHITE_CONF_DIR = "/etc/graphite/";
        GRAPHITE_STORAGE_DIR = "${dataDir}";
      };
      serviceConfig = {
        ExecStart = "${pkgs.pythonPackages.carbon}/bin/carbon-aggregator.py --debug --pidfile /tmp/carbonAggregator.pid start";
        User = "graphite";
        Group = "graphite";
      };
      restartTriggers = [ pkgs.pythonPackages.carbon cfg.carbon cfg.aggregationRules ];
    };

    systemd.services.carbonRelay = mkIf cfg.enableCarbonRelay {
      description = "Carbon data relay";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-interfaces.target" ];
      environment = {
        GRAPHITE_CONF_DIR = "/etc/graphite/";
        GRAPHITE_STORAGE_DIR = "${dataDir}";
      };
      serviceConfig = {
        ExecStart = "${pkgs.pythonPackages.carbon}/bin/carbon-relay.py --debug --pidfile /tmp/carbonRelay.pid start";
        User = "graphite";
        Group = "graphite";
      };
      restartTriggers = [ pkgs.pythonPackages.carbon cfg.carbon cfg.relayRules ];
    };

    systemd.services.graphiteWeb = mkIf cfg.enableGraphiteWeb {
      description = "Graphite web interface";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-interfaces.target" ];
      environment = {
        GRAPHITE_CONF_DIR = "/etc/graphite/";
        GRAPHITE_STORAGE_DIR = "${dataDir}";
      };
      serviceConfig = {
        ExecStart = "${pkgs.pythonPackages.graphite_web}/bin/run-graphite-devel-server.py ${pkgs.pythonPackages.graphite_web}";
        User = "graphite";
        Group = "graphite";
      };
      preStart = ''
        if ! test -e ${dataDir}/db-created; then
          mkdir -p ${dataDir}/{whisper/,log/webapp/}

          # populate database
          ${pkgs.pythonPackages.graphite_web}/bin/manage-graphite.py syncdb --noinput

          # create index
          ${pkgs.pythonPackages.graphite_web}/bin/build-index.sh

          touch ${dataDir}/db-created
        fi
      '';
      restartTriggers = [ pkgs.pythonPackages.graphite_web ];
    };

    environment.systemPackages = [
      pkgs.pythonPackages.carbon pkgs.pythonPackages.graphite_web pkgs.pythonPackages.django_1_3
    ];

    users.extraUsers = singleton {
      name = "graphite";
      uid = config.ids.uids.graphite;
      description = "Graphite daemon user";
      home = "${dataDir}";
      createHome = true;
    };
    users.extraGroups.graphite.gid = config.ids.gids.graphite;
  };
}
