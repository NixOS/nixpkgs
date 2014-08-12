{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.elasticsearch;

  esConfig = ''
    network.host: ${cfg.host}
    network.port: ${toString cfg.port}
    network.tcp.port: ${toString cfg.tcp_port}
    cluster.name: ${cfg.cluster_name}
    ${cfg.extraConf}
  '';

  configDir = pkgs.buildEnv {
    name = "elasticsearch-config";
    paths = [
      (pkgs.writeTextDir "elasticsearch.yml" esConfig)
      (pkgs.writeTextDir "logging.yml" cfg.logging)
    ];
  };

  esPlugins = pkgs.buildEnv {
    name = "elasticsearch-plugins";
    paths = cfg.plugins;
  };

in {

  ###### interface

  options.services.elasticsearch = {
    enable = mkOption {
      description = "Whether to enable elasticsearch.";
      default = false;
      type = types.uniq types.bool;
    };

    host = mkOption {
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
        index.number_of_shards: 5
        index.number_of_replicas: 1
      '';
    };

    logging = mkOption {
      description = "Elasticsearch logging configuration.";
      default = ''
        rootLogger: INFO, console
        logger:
          action: INFO
          com.amazonaws: WARN
        appender:
          console:
            type: console
            layout:
              type: consolePattern
              conversionPattern: "[%d{ISO8601}][%-5p][%-25c] %m%n"
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
      type = types.listOf types.string;
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
      after = [ "network-interfaces.target" ];
      environment = { ES_HOME = cfg.dataDir; };
      serviceConfig = {
        ExecStart = "${pkgs.elasticsearch}/bin/elasticsearch -Des.path.conf=${configDir} ${toString cfg.extraCmdLineOptions}";
        User = "elasticsearch";
        PermissionsStartOnly = true;
      };
      preStart = ''
        mkdir -m 0700 -p ${cfg.dataDir}
        if [ "$(id -u)" = 0 ]; then chown -R elasticsearch ${cfg.dataDir}; fi

        # Install plugins
        rm ${cfg.dataDir}/plugins || true
        ln -s ${esPlugins}/plugins ${cfg.dataDir}/plugins
      '';
    };

    environment.systemPackages = [ pkgs.elasticsearch ];

    users.extraUsers = singleton {
      name = "elasticsearch";
      uid = config.ids.uids.elasticsearch;
      description = "Elasticsearch daemon user";
      home = cfg.dataDir;
    };
  };
}
