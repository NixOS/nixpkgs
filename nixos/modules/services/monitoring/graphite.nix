{ config, pkgs, ... }:

with pkgs.lib;

let
  cfg = config.services.graphite;
  writeTextOrNull = f: t: if t == null then null else pkgs.writeText f t;

  dataDir = "/var/db/graphite";
  carbonOpts = name: with config.ids; ''
    --nodaemon --syslog --prefix=${name} \
    --uid ${toString uids.graphite} --gid ${toString uids.graphite} ${name}
  '';
  carbonEnv = {
    PYTHONPATH = "${pkgs.python27Packages.carbon}/lib/python2.7/site-packages";
    GRAPHITE_ROOT = dataDir;
    GRAPHITE_CONF_DIR = "/etc/graphite/";
  };

in {

  ###### interface

  options.services.graphite = {
    web = {
      enable = mkOption {
        description = "Whether to enable graphite web frontend";
        default = false;
        type = types.uniq types.bool;
      };

      host = mkOption {
        description = "Graphite web frontend listen address";
        default = "127.0.0.1";
        types = type.uniq types.string;
      };

      port = mkOption {
        description = "Graphite web frontend port";
        default = "8080";
        types = type.uniq types.string;
      };
    };

    carbon = {
      config = mkOption {
        description = "Content of carbon configuration file";
        default = ''
          [cache]
          # Listen on localhost by default for security reasons
          UDP_RECEIVER_INTERFACE = 127.0.0.1
          PICKLE_RECEIVER_INTERFACE = 127.0.0.1
          LINE_RECEIVER_INTERFACE = 127.0.0.1
          CACHE_QUERY_INTERFACE = 127.0.0.1
        '';
        type = types.uniq types.string;
      };

      enableCache = mkOption {
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

      enableRelay = mkOption {
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

      enableAggregator = mkOption {
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
    };
  };

  ###### implementation

  config = mkIf (cfg.carbon.enableAggregator || cfg.carbon.enableCache || cfg.carbon.enableRelay || cfg.web.enable) {
    environment.etc = lists.filter (el: el.source != null) [
      { source = writeTextOrNull "carbon.conf" cfg.carbon.config;
        target = "graphite/carbon.conf"; }
      { source = writeTextOrNull "storage-agregation.conf" cfg.carbon.storageAggregation;
        target = "graphite/storage-agregation.conf"; }
      { source = writeTextOrNull "storage-schemas.conf" cfg.carbon.storageSchemas;
        target = "graphite/storage-schemas.conf"; }
      { source = writeTextOrNull "blacklist.conf" cfg.carbon.blacklist;
        target = "graphite/blacklist.conf"; }
      { source = writeTextOrNull "whitelist.conf" cfg.carbon.whitelist;
        target = "graphite/whitelist.conf"; }
      { source = writeTextOrNull "rewrite-rules.conf" cfg.carbon.rewriteRules;
        target = "graphite/rewrite-rules.conf"; }
      { source = writeTextOrNull "relay-rules.conf" cfg.carbon.relayRules;
        target = "graphite/relay-rules.conf"; }
      { source = writeTextOrNull "aggregation-rules.conf" cfg.carbon.aggregationRules;
        target = "graphite/aggregation-rules.conf"; }
    ];

    systemd.services.carbonCache = mkIf cfg.carbon.enableCache {
      description = "Graphite data storage backend";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-interfaces.target" ];
      environment = carbonEnv;
      serviceConfig.ExecStart = "${pkgs.twisted}/bin/twistd ${carbonOpts "carbon-cache"}";
      restartTriggers = [
        pkgs.pythonPackages.carbon
        cfg.carbon.config
        cfg.carbon.storageAggregation
        cfg.carbon.storageSchemas
        cfg.carbon.rewriteRules
      ];
      preStart = ''
        mkdir -p ${dataDir}/whisper
      '';
    };

    systemd.services.carbonAggregator = mkIf cfg.carbon.enableAggregator {
      description = "Carbon data aggregator";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-interfaces.target" ];
      environment = carbonEnv;
      serviceConfig.ExecStart = "${pkgs.twisted}/bin/twistd ${carbonOpts "carbon-aggregator"}";
      restartTriggers = [
        pkgs.pythonPackages.carbon cfg.carbon.config cfg.carbon.aggregationRules
      ];
    };

    systemd.services.carbonRelay = mkIf cfg.carbon.enableRelay {
      description = "Carbon data relay";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-interfaces.target" ];
      environment = carbonEnv;
      serviceConfig.ExecStart = "${pkgs.twisted}/bin/twistd ${carbonOpts "carbon-relay"}";
      restartTriggers = [
        pkgs.pythonPackages.carbon cfg.carbon.config cfg.carbon.relayRules
      ];
    };

    systemd.services.graphiteWeb = mkIf cfg.web.enable {
      description = "Graphite web interface";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-interfaces.target" ];
      environment = {
        PYTHONPATH = "${pkgs.python27Packages.graphite_web}/lib/python2.7/site-packages";
        DJANGO_SETTINGS_MODULE = "graphite.settings";
        GRAPHITE_CONF_DIR = "/etc/graphite/";
        GRAPHITE_STORAGE_DIR = dataDir;
      };
      serviceConfig = {
        ExecStart = ''
          ${pkgs.python27Packages.waitress}/bin/waitress-serve \
          --host=${cfg.web.host} --port=${cfg.web.port} \
          --call django.core.handlers.wsgi:WSGIHandler'';
        User = "graphite";
        Group = "graphite";
      };
      preStart = ''
        if ! test -e ${dataDir}/db-created; then
          mkdir -p ${dataDir}/{whisper/,log/webapp/}

          # populate database
          ${pkgs.python27Packages.graphite_web}/bin/manage-graphite.py syncdb --noinput

          # create index
          ${pkgs.python27Packages.graphite_web}/bin/build-index.sh

          touch ${dataDir}/db-created
        fi
      '';
      restartTriggers = [
        pkgs.python27Packages.graphite_web
        pkgs.python27Packages.waitress
      ];
    };

    environment.systemPackages = [
      pkgs.pythonPackages.carbon
      pkgs.python27Packages.graphite_web
      pkgs.python27Packages.waitress
    ];

    users.extraUsers = singleton {
      name = "graphite";
      uid = config.ids.uids.graphite;
      description = "Graphite daemon user";
      home = dataDir;
      createHome = true;
    };
    users.extraGroups.graphite.gid = config.ids.gids.graphite;
  };
}
