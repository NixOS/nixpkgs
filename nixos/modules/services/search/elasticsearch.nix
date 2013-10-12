{ config, pkgs, ... }:

with pkgs.lib;

let
  cfg = config.services.elasticsearch;

  es_home = "/var/lib/elasticsearch";

  configFile = pkgs.writeText "elasticsearch.yml" ''
    network.host: ${cfg.host}
    network.port: ${cfg.port}
    network.tcp.port: ${cfg.tcp_port}
    cluster.name: ${cfg.cluster_name}
    ${cfg.extraConf}
  '';

in {

  ###### interface

  options.services.elasticsearch = {
    enable = mkOption {
      description = "Whether to enable elasticsearch";
      default = false;
      type = types.uniq types.bool;
    };

    host = mkOption {
      description = "Elasticsearch listen address";
      default = "127.0.0.1";
      types = type.uniq types.string;
    };

    port = mkOption {
      description = "Elasticsearch port to listen for HTTP traffic";
      default = "9200";
      types = type.uniq types.string;
    };

    tcp_port = mkOption {
      description = "Elasticsearch port for the node to node communication";
      default = "9300";
      types = type.uniq types.string;
    };

    cluster_name = mkOption {
      description = "Elasticsearch name that identifies your cluster for auto-discovery";
      default = "elasticsearch";
      types = type.uniq types.string;
    };

    extraConf = mkOption {
      description = "Extra configuration for elasticsearch";
      default = "";
      types = type.uniq types.string;
      example = ''
        node.name: "elasticsearch"
        node.master: true
        node.data: false
        index.number_of_shards: 5
        index.number_of_replicas: 1
      '';
    };

    logging = mkOption {
      description = "Elasticsearch logging configuration";
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
      types = type.uniq types.string;
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    environment.etc = [
      { source = configFile;
        target = "elasticsearch/elasticsearch.yml"; }
      { source = pkgs.writeText "logging.yml" cfg.logging;
        target = "elasticsearch/logging.yml"; }
    ];

    systemd.services.elasticsearch = mkIf cfg.enable {
      description = "Elasticsearch daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-interfaces.target" ];
      environment = { ES_HOME = es_home; };
      serviceConfig = {
        ExecStart = "${pkgs.elasticsearch}/bin/elasticsearch -f -Des.path.conf=/etc/elasticsearch";
        User = "elasticsearch";
      };
    };

    environment.systemPackages = [ pkgs.elasticsearch ];

    users.extraUsers = singleton {
      name = "elasticsearch";
      uid = config.ids.uids.elasticsearch;
      description = "Elasticsearch daemon user";
      home = es_home;
      createHome = true;
    };
  };
}
