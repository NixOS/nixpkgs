{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.elasticsearch;

  esConfig = ''
    network.host: ${cfg.listenAddress}
    network.port: ${toString cfg.port}
    network.tcp.port: ${toString cfg.tcp_port}
    # TODO: find a way to enable security manager
    security.manager.enabled: false
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
      type = types.bool;
    };

    package = mkOption {
      description = "Elasticsearch package to use.";
      default = pkgs.elasticsearch2;
      defaultText = "pkgs.elasticsearch2";
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
      after = [ "network-interfaces.target" ];
      path = [ pkgs.inetutils ];
      environment = {
        ES_HOME = cfg.dataDir;
      };
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/elasticsearch -Des.path.conf=${configDir} ${toString cfg.extraCmdLineOptions}";
        User = "elasticsearch";
        PermissionsStartOnly = true;
      };
      preStart = ''
        mkdir -m 0700 -p ${cfg.dataDir}

        # Install plugins
        ln -sfT ${esPlugins}/plugins ${cfg.dataDir}/plugins
        ln -sfT ${cfg.package}/lib ${cfg.dataDir}/lib
        if [ "$(id -u)" = 0 ]; then chown -R elasticsearch ${cfg.dataDir}; fi
      '';
      postStart = mkBefore ''
        until ${pkgs.curl.bin}/bin/curl -s -o /dev/null ${cfg.listenAddress}:${toString cfg.port}; do
          sleep 1
        done
      '';
    };

    environment.systemPackages = [ cfg.package ];

    users.extraUsers = singleton {
      name = "elasticsearch";
      uid = config.ids.uids.elasticsearch;
      description = "Elasticsearch daemon user";
      home = cfg.dataDir;
    };
  };
}
