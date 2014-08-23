{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.graphite;
  writeTextOrNull = f: t: if t == null then null else pkgs.writeTextDir f t;

  dataDir = cfg.dataDir;

  configDir = pkgs.buildEnv {
    name = "graphite-config";
    paths = lists.filter (el: el != null) [
      (writeTextOrNull "carbon.conf" cfg.carbon.config)
      (writeTextOrNull "storage-aggregation.conf" cfg.carbon.storageAggregation)
      (writeTextOrNull "storage-schemas.conf" cfg.carbon.storageSchemas)
      (writeTextOrNull "blacklist.conf" cfg.carbon.blacklist)
      (writeTextOrNull "whitelist.conf" cfg.carbon.whitelist)
      (writeTextOrNull "rewrite-rules.conf" cfg.carbon.rewriteRules)
      (writeTextOrNull "relay-rules.conf" cfg.carbon.relayRules)
      (writeTextOrNull "aggregation-rules.conf" cfg.carbon.aggregationRules)
    ];
  };

  carbonOpts = name: with config.ids; ''
    --nodaemon --syslog --prefix=${name} --pidfile ${dataDir}/${name}.pid ${name}
  '';
  carbonEnv = {
    PYTHONPATH = "${pkgs.python27Packages.carbon}/lib/python2.7/site-packages";
    GRAPHITE_ROOT = dataDir;
    GRAPHITE_CONF_DIR = configDir;
    GRAPHITE_STORAGE_DIR = dataDir;
  };

in {

  ###### interface

  options.services.graphite = {
    dataDir = mkOption {
      type = types.path;
      default = "/var/db/graphite";
      description = ''
        Data directory for graphite.
      '';
    };

    web = {
      enable = mkOption {
        description = "Whether to enable graphite web frontend.";
        default = false;
        type = types.uniq types.bool;
      };

      host = mkOption {
        description = "Graphite web frontend listen address.";
        default = "127.0.0.1";
        type = types.str;
      };

      port = mkOption {
        description = "Graphite web frontend port.";
        default = 8080;
        type = types.int;
      };
    };

    carbon = {
      config = mkOption {
        description = "Content of carbon configuration file.";
        default = ''
          [cache]
          # Listen on localhost by default for security reasons
          UDP_RECEIVER_INTERFACE = 127.0.0.1
          PICKLE_RECEIVER_INTERFACE = 127.0.0.1
          LINE_RECEIVER_INTERFACE = 127.0.0.1
          CACHE_QUERY_INTERFACE = 127.0.0.1
          # Do not log every update
          LOG_UPDATES = False
          LOG_CACHE_HITS = False
        '';
        type = types.str;
      };

      enableCache = mkOption {
        description = "Whether to enable carbon cache, the graphite storage daemon.";
        default = false;
        type = types.uniq types.bool;
      };

      storageAggregation = mkOption {
        description = "Defines how to aggregate data to lower-precision retentions.";
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
        description = "Defines retention rates for storing metrics.";
        default = "";
        type = types.uniq (types.nullOr types.string);
        example = ''
          [apache_busyWorkers]
          pattern = ^servers\.www.*\.workers\.busyWorkers$
          retentions = 15s:7d,1m:21d,15m:5y
        '';
      };

      blacklist = mkOption {
        description = "Any metrics received which match one of the experssions will be dropped.";
        default = null;
        type = types.uniq (types.nullOr types.string);
        example = "^some\.noisy\.metric\.prefix\..*";
      };

      whitelist = mkOption {
        description = "Only metrics received which match one of the experssions will be persisted.";
        default = null;
        type = types.uniq (types.nullOr types.string);
        example = ".*";
      };

      rewriteRules = mkOption {
        description = ''
          Regular expression patterns that can be used to rewrite metric names
          in a search and replace fashion.
        '';
        default = null;
        type = types.uniq (types.nullOr types.string);
        example = ''
          [post]
          _sum$ =
          _avg$ =
        '';
      };

      enableRelay = mkOption {
        description = "Whether to enable carbon relay, the carbon replication and sharding service.";
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
        description = "Whether to enable carbon agregator, the carbon buffering service.";
        default = false;
        type = types.uniq types.bool;
      };

      aggregationRules = mkOption {
        description = "Defines if and how received metrics will be agregated.";
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
    systemd.services.carbonCache = {
      enable = cfg.carbon.enableCache;
      description = "Graphite Data Storage Backend";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-interfaces.target" ];
      environment = carbonEnv;
      serviceConfig = {
        ExecStart = "${pkgs.twisted}/bin/twistd ${carbonOpts "carbon-cache"}";
        User = "graphite";
        Group = "graphite";
        PermissionsStartOnly = true;
      };
      restartTriggers = [
        pkgs.pythonPackages.carbon
        configDir
      ];
      preStart = ''
        mkdir -p ${cfg.dataDir}/whisper
        chmod 0700 ${cfg.dataDir}/whisper
        chown -R graphite:graphite ${cfg.dataDir}
      '';
    };

    systemd.services.carbonAggregator = {
      enable = cfg.carbon.enableAggregator;
      description = "Carbon Data Aggregator";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-interfaces.target" ];
      environment = carbonEnv;
      serviceConfig = {
        ExecStart = "${pkgs.twisted}/bin/twistd ${carbonOpts "carbon-aggregator"}";
        User = "graphite";
        Group = "graphite";
      };
      restartTriggers = [
        pkgs.pythonPackages.carbon
        configDir
      ];
    };

    systemd.services.carbonRelay = {
      enable = cfg.carbon.enableRelay;
      description = "Carbon Data Relay";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-interfaces.target" ];
      environment = carbonEnv;
      serviceConfig = {
        ExecStart = "${pkgs.twisted}/bin/twistd ${carbonOpts "carbon-relay"}";
        User = "graphite";
        Group = "graphite";
      };
      restartTriggers = [
        pkgs.pythonPackages.carbon
        configDir
      ];
    };

    systemd.services.graphiteWeb = {
      enable = cfg.web.enable;
      description = "Graphite Web Interface";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-interfaces.target" ];
      path = [ pkgs.perl ];
      environment = {
        PYTHONPATH = "${pkgs.python27Packages.graphite_web}/lib/python2.7/site-packages";
        DJANGO_SETTINGS_MODULE = "graphite.settings";
        GRAPHITE_CONF_DIR = "/etc/graphite/";
        GRAPHITE_STORAGE_DIR = dataDir;
      };
      serviceConfig = {
        ExecStart = ''
          ${pkgs.python27Packages.waitress}/bin/waitress-serve \
          --host=${cfg.web.host} --port=${toString cfg.web.port} \
          --call django.core.handlers.wsgi:WSGIHandler'';
        User = "graphite";
        Group = "graphite";
        PermissionsStartOnly = true;
      };
      preStart = ''
        if ! test -e ${dataDir}/db-created; then
          mkdir -p ${dataDir}/{whisper/,log/webapp/}
          chmod 0700 ${dataDir}/{whisper/,log/webapp/}

          # populate database
          ${pkgs.python27Packages.graphite_web}/bin/manage-graphite.py syncdb --noinput

          # create index
          ${pkgs.python27Packages.graphite_web}/bin/build-index.sh

          touch ${dataDir}/db-created

          chown -R graphite:graphite ${cfg.dataDir}
        fi
      '';
      restartTriggers = [
        pkgs.python27Packages.graphite_web
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
    };
    users.extraGroups.graphite.gid = config.ids.gids.graphite;
  };
}
