{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.graphite;
  writeTextOrNull = f: t: mapNullable (pkgs.writeTextDir f) t;

  dataDir = cfg.dataDir;
  staticDir = cfg.dataDir + "/static";

  graphiteLocalSettingsDir = pkgs.runCommand "graphite_local_settings" {
      inherit graphiteLocalSettings;
      preferLocalBuild = true;
    } ''
    mkdir -p $out
    ln -s $graphiteLocalSettings $out/graphite_local_settings.py
  '';

  graphiteLocalSettings = pkgs.writeText "graphite_local_settings.py" (
    "STATIC_ROOT = '${staticDir}'\n" +
    optionalString (config.time.timeZone != null) "TIME_ZONE = '${config.time.timeZone}'\n"
    + cfg.web.extraConfig
  );

  graphiteApiConfig = pkgs.writeText "graphite-api.yaml" ''
    search_index: ${dataDir}/index
    ${optionalString (config.time.timeZone != null) ''time_zone: ${config.time.timeZone}''}
    ${optionalString (cfg.api.finders != []) ''finders:''}
    ${concatMapStringsSep "\n" (f: "  - " + f.moduleName) cfg.api.finders}
    ${optionalString (cfg.api.functions != []) ''functions:''}
    ${concatMapStringsSep "\n" (f: "  - " + f) cfg.api.functions}
    ${cfg.api.extraConfig}
  '';

  seyrenConfig = {
    SEYREN_URL = cfg.seyren.seyrenUrl;
    MONGO_URL = cfg.seyren.mongoUrl;
    GRAPHITE_URL = cfg.seyren.graphiteUrl;
  } // cfg.seyren.extraConfig;

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
    --nodaemon --syslog --prefix=${name} --pidfile /run/${name}/${name}.pid ${name}
  '';

  carbonEnv = {
    PYTHONPATH = let
      cenv = pkgs.python3.buildEnv.override {
        extraLibs = [ pkgs.python3Packages.carbon ];
      };
    in "${cenv}/${pkgs.python3.sitePackages}";
    GRAPHITE_ROOT = dataDir;
    GRAPHITE_CONF_DIR = configDir;
    GRAPHITE_STORAGE_DIR = dataDir;
  };

in {

  imports = [
    (mkRemovedOptionModule ["services" "graphite" "pager"] "")
  ];

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
        type = types.bool;
      };

      listenAddress = mkOption {
        description = "Graphite web frontend listen address.";
        default = "127.0.0.1";
        type = types.str;
      };

      port = mkOption {
        description = "Graphite web frontend port.";
        default = 8080;
        type = types.int;
      };

      extraConfig = mkOption {
        type = types.str;
        default = "";
        description = ''
          Graphite webapp settings. See:
          <link xlink:href="http://graphite.readthedocs.io/en/latest/config-local-settings.html"/>
        '';
      };
    };

    api = {
      enable = mkOption {
        description = ''
          Whether to enable graphite api. Graphite api is lightweight alternative
          to graphite web, with api and without dashboard. It's advised to use
          grafana as alternative dashboard and influxdb as alternative to
          graphite carbon.

          For more information visit
          <link xlink:href="https://graphite-api.readthedocs.org/en/latest/"/>
        '';
        default = false;
        type = types.bool;
      };

      finders = mkOption {
        description = "List of finder plugins to load.";
        default = [];
        example = literalExample "[ pkgs.python3Packages.influxgraph ]";
        type = types.listOf types.package;
      };

      functions = mkOption {
        description = "List of functions to load.";
        default = [
          "graphite_api.functions.SeriesFunctions"
          "graphite_api.functions.PieFunctions"
        ];
        type = types.listOf types.str;
      };

      listenAddress = mkOption {
        description = "Graphite web service listen address.";
        default = "127.0.0.1";
        type = types.str;
      };

      port = mkOption {
        description = "Graphite api service port.";
        default = 8080;
        type = types.int;
      };

      package = mkOption {
        description = "Package to use for graphite api.";
        default = pkgs.python3Packages.graphite_api;
        defaultText = "pkgs.python3Packages.graphite_api";
        type = types.package;
      };

      extraConfig = mkOption {
        description = "Extra configuration for graphite api.";
        default = ''
          whisper:
            directories:
                - ${dataDir}/whisper
        '';
        example = ''
          allowed_origins:
            - dashboard.example.com
          cheat_times: true
          influxdb:
            host: localhost
            port: 8086
            user: influxdb
            pass: influxdb
            db: metrics
          cache:
            CACHE_TYPE: 'filesystem'
            CACHE_DIR: '/tmp/graphite-api-cache'
        '';
        type = types.lines;
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
        type = types.bool;
      };

      storageAggregation = mkOption {
        description = "Defines how to aggregate data to lower-precision retentions.";
        default = null;
        type = types.nullOr types.str;
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
        type = types.nullOr types.str;
        example = ''
          [apache_busyWorkers]
          pattern = ^servers\.www.*\.workers\.busyWorkers$
          retentions = 15s:7d,1m:21d,15m:5y
        '';
      };

      blacklist = mkOption {
        description = "Any metrics received which match one of the experssions will be dropped.";
        default = null;
        type = types.nullOr types.str;
        example = "^some\\.noisy\\.metric\\.prefix\\..*";
      };

      whitelist = mkOption {
        description = "Only metrics received which match one of the experssions will be persisted.";
        default = null;
        type = types.nullOr types.str;
        example = ".*";
      };

      rewriteRules = mkOption {
        description = ''
          Regular expression patterns that can be used to rewrite metric names
          in a search and replace fashion.
        '';
        default = null;
        type = types.nullOr types.str;
        example = ''
          [post]
          _sum$ =
          _avg$ =
        '';
      };

      enableRelay = mkOption {
        description = "Whether to enable carbon relay, the carbon replication and sharding service.";
        default = false;
        type = types.bool;
      };

      relayRules = mkOption {
        description = "Relay rules are used to send certain metrics to a certain backend.";
        default = null;
        type = types.nullOr types.str;
        example = ''
          [example]
          pattern = ^mydata\.foo\..+
          servers = 10.1.2.3, 10.1.2.4:2004, myserver.mydomain.com
        '';
      };

      enableAggregator = mkOption {
        description = "Whether to enable carbon aggregator, the carbon buffering service.";
        default = false;
        type = types.bool;
      };

      aggregationRules = mkOption {
        description = "Defines if and how received metrics will be aggregated.";
        default = null;
        type = types.nullOr types.str;
        example = ''
          <env>.applications.<app>.all.requests (60) = sum <env>.applications.<app>.*.requests
          <env>.applications.<app>.all.latency (60) = avg <env>.applications.<app>.*.latency
        '';
      };
    };

    seyren = {
      enable = mkOption {
        description = "Whether to enable seyren service.";
        default = false;
        type = types.bool;
      };

      port = mkOption {
        description = "Seyren listening port.";
        default = 8081;
        type = types.int;
      };

      seyrenUrl = mkOption {
        default = "http://localhost:${toString cfg.seyren.port}/";
        description = "Host where seyren is accessible.";
        type = types.str;
      };

      graphiteUrl = mkOption {
        default = "http://${cfg.web.listenAddress}:${toString cfg.web.port}";
        description = "Host where graphite service runs.";
        type = types.str;
      };

      mongoUrl = mkOption {
        default = "mongodb://${config.services.mongodb.bind_ip}:27017/seyren";
        description = "Mongodb connection string.";
        type = types.str;
      };

      extraConfig = mkOption {
        default = {};
        description = ''
          Extra seyren configuration. See
          <link xlink:href='https://github.com/scobal/seyren#config' />
        '';
        type = types.attrsOf types.str;
        example = literalExample ''
          {
            GRAPHITE_USERNAME = "user";
            GRAPHITE_PASSWORD = "pass";
          }
        '';
      };
    };

    beacon = {
      enable = mkEnableOption "graphite beacon";

      config = mkOption {
        description = "Graphite beacon configuration.";
        default = {};
        type = types.attrs;
      };
    };
  };

  ###### implementation

  config = mkMerge [
    (mkIf cfg.carbon.enableCache {
      systemd.services.carbonCache = let name = "carbon-cache"; in {
        description = "Graphite Data Storage Backend";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        environment = carbonEnv;
        serviceConfig = {
          RuntimeDirectory = name;
          ExecStart = "${pkgs.python3Packages.twisted}/bin/twistd ${carbonOpts name}";
          User = "graphite";
          Group = "graphite";
          PermissionsStartOnly = true;
          PIDFile="/run/${name}/${name}.pid";
        };
        preStart = ''
          install -dm0700 -o graphite -g graphite ${cfg.dataDir}
          install -dm0700 -o graphite -g graphite ${cfg.dataDir}/whisper
        '';
      };
    })

    (mkIf cfg.carbon.enableAggregator {
      systemd.services.carbonAggregator = let name = "carbon-aggregator"; in {
        enable = cfg.carbon.enableAggregator;
        description = "Carbon Data Aggregator";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        environment = carbonEnv;
        serviceConfig = {
          RuntimeDirectory = name;
          ExecStart = "${pkgs.python3Packages.twisted}/bin/twistd ${carbonOpts name}";
          User = "graphite";
          Group = "graphite";
          PIDFile="/run/${name}/${name}.pid";
        };
      };
    })

    (mkIf cfg.carbon.enableRelay {
      systemd.services.carbonRelay = let name = "carbon-relay"; in {
        description = "Carbon Data Relay";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        environment = carbonEnv;
        serviceConfig = {
          RuntimeDirectory = name;
          ExecStart = "${pkgs.python3Packages.twisted}/bin/twistd ${carbonOpts name}";
          User = "graphite";
          Group = "graphite";
          PIDFile="/run/${name}/${name}.pid";
        };
      };
    })

    (mkIf (cfg.carbon.enableCache || cfg.carbon.enableAggregator || cfg.carbon.enableRelay) {
      environment.systemPackages = [
        pkgs.python3Packages.carbon
      ];
    })

    (mkIf cfg.web.enable ({
      systemd.services.graphiteWeb = {
        description = "Graphite Web Interface";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        path = [ pkgs.perl ];
        environment = {
          PYTHONPATH = let
              penv = pkgs.python3.buildEnv.override {
                extraLibs = [
                  pkgs.python3Packages.graphite-web
                ];
              };
              penvPack = "${penv}/${pkgs.python3.sitePackages}";
            in concatStringsSep ":" [
                 "${graphiteLocalSettingsDir}"
                 "${penvPack}"
                 # explicitly adding pycairo in path because it cannot be imported via buildEnv
                 "${pkgs.python3Packages.pycairo}/${pkgs.python3.sitePackages}"
               ];
          DJANGO_SETTINGS_MODULE = "graphite.settings";
          GRAPHITE_SETTINGS_MODULE = "graphite_local_settings";
          GRAPHITE_CONF_DIR = configDir;
          GRAPHITE_STORAGE_DIR = dataDir;
          LD_LIBRARY_PATH = "${pkgs.cairo.out}/lib";
        };
        serviceConfig = {
          ExecStart = ''
            ${pkgs.python3Packages.waitress-django}/bin/waitress-serve-django \
              --host=${cfg.web.listenAddress} --port=${toString cfg.web.port}
          '';
          User = "graphite";
          Group = "graphite";
          PermissionsStartOnly = true;
        };
        preStart = ''
          if ! test -e ${dataDir}/db-created; then
            mkdir -p ${dataDir}/{whisper/,log/webapp/}
            chmod 0700 ${dataDir}/{whisper/,log/webapp/}

            ${pkgs.python3Packages.django}/bin/django-admin.py migrate --noinput

            chown -R graphite:graphite ${dataDir}

            touch ${dataDir}/db-created
          fi

          # Only collect static files when graphite_web changes.
          if ! [ "${dataDir}/current_graphite_web" -ef "${pkgs.python3Packages.graphite-web}" ]; then
            mkdir -p ${staticDir}
            ${pkgs.python3Packages.django}/bin/django-admin.py collectstatic  --noinput --clear
            chown -R graphite:graphite ${staticDir}
            ln -sfT "${pkgs.python3Packages.graphite-web}" "${dataDir}/current_graphite_web"
          fi
        '';
      };

      environment.systemPackages = [ pkgs.python3Packages.graphite-web ];
    }))

    (mkIf cfg.api.enable {
      systemd.services.graphiteApi = {
        description = "Graphite Api Interface";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        environment = {
          PYTHONPATH = let
              aenv = pkgs.python3.buildEnv.override {
                extraLibs = [ cfg.api.package pkgs.cairo pkgs.python3Packages.cffi ] ++ cfg.api.finders;
              };
            in "${aenv}/${pkgs.python3.sitePackages}";
          GRAPHITE_API_CONFIG = graphiteApiConfig;
          LD_LIBRARY_PATH = "${pkgs.cairo.out}/lib";
        };
        serviceConfig = {
          ExecStart = ''
            ${pkgs.python3Packages.waitress}/bin/waitress-serve \
            --host=${cfg.api.listenAddress} --port=${toString cfg.api.port} \
            graphite_api.app:app
          '';
          User = "graphite";
          Group = "graphite";
          PermissionsStartOnly = true;
        };
        preStart = ''
          if ! test -e ${dataDir}/db-created; then
            mkdir -p ${dataDir}/cache/
            chmod 0700 ${dataDir}/cache/

            chown graphite:graphite ${cfg.dataDir}
            chown -R graphite:graphite ${cfg.dataDir}/cache

            touch ${dataDir}/db-created
          fi
        '';
      };
    })

    (mkIf cfg.seyren.enable {
      systemd.services.seyren = {
        description = "Graphite Alerting Dashboard";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" "mongodb.service" ];
        environment = seyrenConfig;
        serviceConfig = {
          ExecStart = "${pkgs.seyren}/bin/seyren -httpPort ${toString cfg.seyren.port}";
          WorkingDirectory = dataDir;
          User = "graphite";
          Group = "graphite";
        };
        preStart = ''
          if ! test -e ${dataDir}/db-created; then
            mkdir -p ${dataDir}
            chown graphite:graphite ${dataDir}
          fi
        '';
      };

      services.mongodb.enable = mkDefault true;
    })

    (mkIf cfg.beacon.enable {
      systemd.services.graphite-beacon = {
        description = "Grpahite Beacon Alerting Daemon";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = ''
            ${pkgs.python3Packages.graphite_beacon}/bin/graphite-beacon \
              --config=${pkgs.writeText "graphite-beacon.json" (builtins.toJSON cfg.beacon.config)}
          '';
          User = "graphite";
          Group = "graphite";
        };
      };
    })

    (mkIf (
      cfg.carbon.enableCache || cfg.carbon.enableAggregator || cfg.carbon.enableRelay ||
      cfg.web.enable || cfg.api.enable ||
      cfg.seyren.enable || cfg.beacon.enable
     ) {
      users.users.graphite = {
        uid = config.ids.uids.graphite;
        description = "Graphite daemon user";
        home = dataDir;
      };
      users.groups.graphite.gid = config.ids.gids.graphite;
    })
  ];
}
