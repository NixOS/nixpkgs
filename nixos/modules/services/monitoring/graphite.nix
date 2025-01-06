{ config, lib, options, pkgs, ... }:
let
  cfg = config.services.graphite;
  opt = options.services.graphite;
  writeTextOrNull = f: t: lib.mapNullable (pkgs.writeTextDir f) t;

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
    lib.optionalString (config.time.timeZone != null) "TIME_ZONE = '${config.time.timeZone}'\n"
    + cfg.web.extraConfig
  );

  seyrenConfig = {
    SEYREN_URL = cfg.seyren.seyrenUrl;
    MONGO_URL = cfg.seyren.mongoUrl;
    GRAPHITE_URL = cfg.seyren.graphiteUrl;
  } // cfg.seyren.extraConfig;

  configDir = pkgs.buildEnv {
    name = "graphite-config";
    paths = lib.lists.filter (el: el != null) [
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
    (lib.mkRemovedOptionModule ["services" "graphite" "api"] "")
    (lib.mkRemovedOptionModule ["services" "graphite" "beacon"] "")
    (lib.mkRemovedOptionModule ["services" "graphite" "pager"] "")
  ];

  ###### interface

  options.services.graphite = {
    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/db/graphite";
      description = ''
        Data directory for graphite.
      '';
    };

    web = {
      enable = lib.mkOption {
        description = "Whether to enable graphite web frontend.";
        default = false;
        type = lib.types.bool;
      };

      listenAddress = lib.mkOption {
        description = "Graphite web frontend listen address.";
        default = "127.0.0.1";
        type = lib.types.str;
      };

      port = lib.mkOption {
        description = "Graphite web frontend port.";
        default = 8080;
        type = lib.types.port;
      };

      extraConfig = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Graphite webapp settings. See:
          <https://graphite.readthedocs.io/en/latest/config-local-settings.html>
        '';
      };
    };

    carbon = {
      config = lib.mkOption {
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
        type = lib.types.str;
      };

      enableCache = lib.mkOption {
        description = "Whether to enable carbon cache, the graphite storage daemon.";
        default = false;
        type = lib.types.bool;
      };

      storageAggregation = lib.mkOption {
        description = "Defines how to aggregate data to lower-precision retentions.";
        default = null;
        type = lib.types.nullOr lib.types.str;
        example = ''
          [all_min]
          pattern = \.min$
          xFilesFactor = 0.1
          aggregationMethod = min
        '';
      };

      storageSchemas = lib.mkOption {
        description = "Defines retention rates for storing metrics.";
        default = "";
        type = lib.types.nullOr lib.types.str;
        example = ''
          [apache_busyWorkers]
          pattern = ^servers\.www.*\.workers\.busyWorkers$
          retentions = 15s:7d,1m:21d,15m:5y
        '';
      };

      blacklist = lib.mkOption {
        description = "Any metrics received which match one of the expressions will be dropped.";
        default = null;
        type = lib.types.nullOr lib.types.str;
        example = "^some\\.noisy\\.metric\\.prefix\\..*";
      };

      whitelist = lib.mkOption {
        description = "Only metrics received which match one of the expressions will be persisted.";
        default = null;
        type = lib.types.nullOr lib.types.str;
        example = ".*";
      };

      rewriteRules = lib.mkOption {
        description = ''
          Regular expression patterns that can be used to rewrite metric names
          in a search and replace fashion.
        '';
        default = null;
        type = lib.types.nullOr lib.types.str;
        example = ''
          [post]
          _sum$ =
          _avg$ =
        '';
      };

      enableRelay = lib.mkOption {
        description = "Whether to enable carbon relay, the carbon replication and sharding service.";
        default = false;
        type = lib.types.bool;
      };

      relayRules = lib.mkOption {
        description = "Relay rules are used to send certain metrics to a certain backend.";
        default = null;
        type = lib.types.nullOr lib.types.str;
        example = ''
          [example]
          pattern = ^mydata\.foo\..+
          servers = 10.1.2.3, 10.1.2.4:2004, myserver.mydomain.com
        '';
      };

      enableAggregator = lib.mkOption {
        description = "Whether to enable carbon aggregator, the carbon buffering service.";
        default = false;
        type = lib.types.bool;
      };

      aggregationRules = lib.mkOption {
        description = "Defines if and how received metrics will be aggregated.";
        default = null;
        type = lib.types.nullOr lib.types.str;
        example = ''
          <env>.applications.<app>.all.requests (60) = sum <env>.applications.<app>.*.requests
          <env>.applications.<app>.all.latency (60) = avg <env>.applications.<app>.*.latency
        '';
      };
    };

    seyren = {
      enable = lib.mkOption {
        description = "Whether to enable seyren service.";
        default = false;
        type = lib.types.bool;
      };

      port = lib.mkOption {
        description = "Seyren listening port.";
        default = 8081;
        type = lib.types.port;
      };

      seyrenUrl = lib.mkOption {
        default = "http://localhost:${toString cfg.seyren.port}/";
        defaultText = lib.literalExpression ''"http://localhost:''${toString config.${opt.seyren.port}}/"'';
        description = "Host where seyren is accessible.";
        type = lib.types.str;
      };

      graphiteUrl = lib.mkOption {
        default = "http://${cfg.web.listenAddress}:${toString cfg.web.port}";
        defaultText = lib.literalExpression ''"http://''${config.${opt.web.listenAddress}}:''${toString config.${opt.web.port}}"'';
        description = "Host where graphite service runs.";
        type = lib.types.str;
      };

      mongoUrl = lib.mkOption {
        default = "mongodb://${config.services.mongodb.bind_ip}:27017/seyren";
        defaultText = lib.literalExpression ''"mongodb://''${config.services.mongodb.bind_ip}:27017/seyren"'';
        description = "Mongodb connection string.";
        type = lib.types.str;
      };

      extraConfig = lib.mkOption {
        default = {};
        description = ''
          Extra seyren configuration. See
          <https://github.com/scobal/seyren#config>
        '';
        type = lib.types.attrsOf lib.types.str;
        example = lib.literalExpression ''
          {
            GRAPHITE_USERNAME = "user";
            GRAPHITE_PASSWORD = "pass";
          }
        '';
      };
    };
  };

  ###### implementation

  config = lib.mkMerge [
    (lib.mkIf cfg.carbon.enableCache {
      systemd.services.carbonCache = let name = "carbon-cache"; in {
        description = "Graphite Data Storage Backend";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        environment = carbonEnv;
        serviceConfig = {
          Slice = "system-graphite.slice";
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

    (lib.mkIf cfg.carbon.enableAggregator {
      systemd.services.carbonAggregator = let name = "carbon-aggregator"; in {
        enable = cfg.carbon.enableAggregator;
        description = "Carbon Data Aggregator";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        environment = carbonEnv;
        serviceConfig = {
          Slice = "system-graphite.slice";
          RuntimeDirectory = name;
          ExecStart = "${pkgs.python3Packages.twisted}/bin/twistd ${carbonOpts name}";
          User = "graphite";
          Group = "graphite";
          PIDFile="/run/${name}/${name}.pid";
        };
      };
    })

    (lib.mkIf cfg.carbon.enableRelay {
      systemd.services.carbonRelay = let name = "carbon-relay"; in {
        description = "Carbon Data Relay";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        environment = carbonEnv;
        serviceConfig = {
          Slice = "system-graphite.slice";
          RuntimeDirectory = name;
          ExecStart = "${pkgs.python3Packages.twisted}/bin/twistd ${carbonOpts name}";
          User = "graphite";
          Group = "graphite";
          PIDFile="/run/${name}/${name}.pid";
        };
      };
    })

    (lib.mkIf (cfg.carbon.enableCache || cfg.carbon.enableAggregator || cfg.carbon.enableRelay) {
      environment.systemPackages = [
        pkgs.python3Packages.carbon
      ];
    })

    (lib.mkIf cfg.web.enable ({
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
            in lib.concatStringsSep ":" [
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
          Slice = "system-graphite.slice";
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

    (lib.mkIf cfg.seyren.enable {
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
          Slice = "system-graphite.slice";
        };
        preStart = ''
          if ! test -e ${dataDir}/db-created; then
            mkdir -p ${dataDir}
            chown graphite:graphite ${dataDir}
          fi
        '';
      };

      services.mongodb.enable = lib.mkDefault true;
    })

    (lib.mkIf (
      cfg.carbon.enableCache || cfg.carbon.enableAggregator || cfg.carbon.enableRelay ||
      cfg.web.enable || cfg.seyren.enable
     ) {
      systemd.slices.system-graphite = {
        description = "Graphite Graphing System Slice";
        documentation = [ "https://graphite.readthedocs.io/en/latest/overview.html" ];
      };

      users.users.graphite = {
        uid = config.ids.uids.graphite;
        group = "graphite";
        description = "Graphite daemon user";
        home = dataDir;
      };
      users.groups.graphite.gid = config.ids.gids.graphite;
    })
  ];
}
