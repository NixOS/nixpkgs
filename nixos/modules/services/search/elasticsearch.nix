{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.elasticsearch;

  es6 = builtins.compareVersions cfg.package.version "6" >= 0;

  esConfig = ''
    network.host: ${cfg.listenAddress}
    cluster.name: ${cfg.cluster_name}

    http.port: ${toString cfg.port}
    transport.tcp.port: ${toString cfg.tcp_port}

    ${cfg.extraConf}
  '';

  configDir = cfg.dataDir + "/config";

  elasticsearchYml = pkgs.writeTextFile {
    name = "elasticsearch.yml";
    text = esConfig;
  };

  loggingConfigFilename = "log4j2.properties";
  loggingConfigFile = pkgs.writeTextFile {
    name = loggingConfigFilename;
    text = cfg.logging;
  };

  esPlugins = pkgs.buildEnv {
    name = "elasticsearch-plugins";
    paths = cfg.plugins;
    postBuild = "${pkgs.coreutils}/bin/mkdir -p $out/plugins";
  };

in {

  ###### interface

  options.services.elasticsearch = {
    enable = mkOption {
      description = "Whether to enable elasticsearch.";
      default = false;
      type = types.bool;
    };

    package = mkOption {
      description = "Elasticsearch package to use.";
      default = pkgs.elasticsearch;
      defaultText = "pkgs.elasticsearch";
      type = types.package;
    };

    listenAddress = mkOption {
      description = "Elasticsearch listen address.";
      default = "127.0.0.1";
      type = types.str;
    };

    port = mkOption {
      description = "Elasticsearch port to listen for HTTP traffic.";
      default = 9200;
      type = types.int;
    };

    tcp_port = mkOption {
      description = "Elasticsearch port for the node to node communication.";
      default = 9300;
      type = types.int;
    };

    cluster_name = mkOption {
      description = "Elasticsearch name that identifies your cluster for auto-discovery.";
      default = "elasticsearch";
      type = types.str;
    };

    extraConf = mkOption {
      description = "Extra configuration for elasticsearch.";
      default = "";
      type = types.str;
      example = ''
        node.name: "elasticsearch"
        node.master: true
        node.data: false
      '';
    };

    logging = mkOption {
      description = "Elasticsearch logging configuration.";
      default = ''
        logger.action.name = org.elasticsearch.action
        logger.action.level = info

        appender.console.type = Console
        appender.console.name = console
        appender.console.layout.type = PatternLayout
        appender.console.layout.pattern = [%d{ISO8601}][%-5p][%-25c{1.}] %marker%m%n

        rootLogger.level = info
        rootLogger.appenderRef.console.ref = console
      '';
      type = types.str;
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/elasticsearch";
      description = ''
        Data directory for elasticsearch.
      '';
    };

    extraCmdLineOptions = mkOption {
      description = "Extra command line options for the elasticsearch launcher.";
      default = [];
      type = types.listOf types.str;
    };

    extraJavaOptions = mkOption {
      description = "Extra command line options for Java.";
      default = [];
      type = types.listOf types.str;
      example = [ "-Djava.net.preferIPv4Stack=true" ];
    };

    plugins = mkOption {
      description = "Extra elasticsearch plugins";
      default = [];
      type = types.listOf types.package;
    };

  };

  ###### implementation

  config = mkIf cfg.enable {
    systemd.services.elasticsearch = {
      description = "Elasticsearch Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = [ pkgs.inetutils ];
      environment = {
        ES_HOME = cfg.dataDir;
        ES_JAVA_OPTS = toString ( optional (!es6) [ "-Des.path.conf=${configDir}" ]
                                  ++ cfg.extraJavaOptions);
      } // optionalAttrs es6 {
        ES_PATH_CONF = configDir;
      };
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/elasticsearch ${toString cfg.extraCmdLineOptions}";
        User = "elasticsearch";
        PermissionsStartOnly = true;
        LimitNOFILE = "1024000";
      };
      preStart = ''
        ${optionalString (!config.boot.isContainer) ''
          # Only set vm.max_map_count if lower than ES required minimum
          # This avoids conflict if configured via boot.kernel.sysctl
          if [ `${pkgs.procps}/bin/sysctl -n vm.max_map_count` -lt 262144 ]; then
            ${pkgs.procps}/bin/sysctl -w vm.max_map_count=262144
          fi
        ''}

        mkdir -m 0700 -p ${cfg.dataDir}

        # Install plugins
        ln -sfT ${esPlugins}/plugins ${cfg.dataDir}/plugins
        ln -sfT ${cfg.package}/lib ${cfg.dataDir}/lib
        ln -sfT ${cfg.package}/modules ${cfg.dataDir}/modules

        # elasticsearch needs to create the elasticsearch.keystore in the config directory
        # so this directory needs to be writable.
        mkdir -m 0700 -p ${configDir}

        # Note that we copy config files from the nix store instead of symbolically linking them
        # because otherwise X-Pack Security will raise the following exception:
        # java.security.AccessControlException:
        # access denied ("java.io.FilePermission" "/var/lib/elasticsearch/config/elasticsearch.yml" "read")

        cp ${elasticsearchYml} ${configDir}/elasticsearch.yml
        # Make sure the logging configuration for old elasticsearch versions is removed:
        rm -f "${configDir}/logging.yml"
        cp ${loggingConfigFile} ${configDir}/${loggingConfigFilename}
        mkdir -p ${configDir}/scripts
        ${optionalString es6 "cp ${cfg.package}/config/jvm.options ${configDir}/jvm.options"}

        if [ "$(id -u)" = 0 ]; then chown -R elasticsearch:elasticsearch ${cfg.dataDir}; fi
      '';
    };

    environment.systemPackages = [ cfg.package ];

    users = {
      groups.elasticsearch.gid = config.ids.gids.elasticsearch;
      users.elasticsearch = {
        uid = config.ids.uids.elasticsearch;
        description = "Elasticsearch daemon user";
        home = cfg.dataDir;
        group = "elasticsearch";
      };
    };
  };
}
