{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.opensearch;

  opensearchConfig = ''
    network.host: ${cfg.listenAddress}
    cluster.name: ${cfg.cluster_name}
    ${lib.optionalString cfg.single_node "discovery.type: single-node"}
    ${lib.optionalString cfg.single_node "gateway.auto_import_dangling_indices: true"}

    http.port: ${toString cfg.port}
    transport.port: ${toString cfg.tcp_port}

    ${cfg.extraConf}
  '';

  configDir = cfg.dataDir + "/config";

  opensearchYml = pkgs.writeTextFile {
    name = "opensearch.yml";
    text = opensearchConfig;
  };

  loggingConfigFilename = "log4j2.properties";
  loggingConfigFile = pkgs.writeTextFile {
    name = loggingConfigFilename;
    text = cfg.logging;
  };

in
{

  ###### interface

  options.services.opensearch = {
    enable = mkEnableOption (lib.mdDoc "OpenSearch, a distributed search and analytics engine.");

    package = mkOption {
      description = lib.mdDoc "OpenSearch package to use.";
      default = pkgs.opensearch;
      defaultText = literalExpression "pkgs.opensearch";
      type = types.package;
    };

    listenAddress = mkOption {
      description = lib.mdDoc "OpenSearch listen address.";
      default = "127.0.0.1";
      type = types.str;
    };

    port = mkOption {
      description = lib.mdDoc "OpenSearch port to listen for HTTP traffic.";
      default = 9200;
      type = types.int;
    };

    tcp_port = mkOption {
      description = lib.mdDoc "OpenSearch port for the node to node communication.";
      default = 9300;
      type = types.int;
    };

    cluster_name = mkOption {
      description = lib.mdDoc "OpenSearch name that identifies your cluster for auto-discovery.";
      default = "opensearch";
      type = types.str;
    };

    single_node = mkOption {
      description = lib.mdDoc "Start a single-node cluster";
      default = true;
      type = types.bool;
    };

    extraConf = mkOption {
      description = lib.mdDoc "Extra configuration for OpenSearch.";
      default = "";
      type = types.str;
      example = ''
        node.name: "opensearch"
        node.master: true
        node.data: false
      '';
    };

    logging = mkOption {
      description = lib.mdDoc "OpenSearch logging configuration.";
      default = ''
        logger.action.name = org.opensearch.action
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
      default = "/var/lib/opensearch";
      description = lib.mdDoc ''
        Data directory for OpenSearch.
      '';
    };

    extraCmdLineOptions = mkOption {
      description = lib.mdDoc "Extra command line options for the OpenSearch launcher.";
      default = [ ];
      type = types.listOf types.str;
    };

    extraJavaOptions = mkOption {
      description = lib.mdDoc "Extra command line options for Java.";
      default = [ ];
      type = types.listOf types.str;
      example = [ "-Djava.net.preferIPv4Stack=true" ];
    };


    restartIfChanged  = mkOption {
      type = types.bool;
      description = lib.mdDoc ''
        Automatically restart the service on config change.
        This can be set to false to defer restarts on a server or cluster.
        Please consider the security implications of inadvertently running an older version,
        and the possibility of unexpected behavior caused by inconsistent versions across a cluster when disabling this option.
      '';
      default = true;
    };

  };

  ###### implementation

  config = mkIf cfg.enable {
    systemd.services.opensearch = {
      description = "OpenSearch Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = [ pkgs.inetutils ];
      inherit (cfg) restartIfChanged;
      environment = {
        OPENSEARCH_HOME = cfg.dataDir;
        OPENSEARCH_JAVA_OPTS = toString cfg.extraJavaOptions;
        OPENSEARCH_PATH_CONF = configDir;
      };
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/opensearch ${toString cfg.extraCmdLineOptions}";
        User = "opensearch";
        PermissionsStartOnly = true;
        LimitNOFILE = "1024000";
        Restart = "always";
        TimeoutStartSec = "infinity";
      };
      preStart = ''
        ${optionalString (!config.boot.isContainer) ''
          # Only set vm.max_map_count if lower than OpenSearch's required minimum
          # This avoids conflict if configured via boot.kernel.sysctl
          if [ `${pkgs.procps}/bin/sysctl -n vm.max_map_count` -lt 262144 ]; then
            ${pkgs.procps}/bin/sysctl -w vm.max_map_count=262144
          fi
        ''}

        mkdir -m 0700 -p ${cfg.dataDir}

        ln -sfT ${cfg.package}/lib ${cfg.dataDir}/lib
        ln -sfT ${cfg.package}/modules ${cfg.dataDir}/modules

        # OpenSearch needs to create the opensearch.keystore in the config directory
        # so this directory needs to be writable.
        mkdir -m 0700 -p ${configDir}

        # Note that we copy config files from the nix store instead of symbolically linking them
        # because otherwise Security will raise the following exception:
        # java.security.AccessControlException:
        # access denied ("java.io.FilePermission" "/var/lib/opensearch/config/opensearch.yml" "read")

        cp ${opensearchYml} ${configDir}/opensearch.yml
        # Make sure the logging configuration for old OpenSearch versions is removed:
        rm -f "${configDir}/logging.yml"
        cp ${loggingConfigFile} ${configDir}/${loggingConfigFilename}
        mkdir -p ${configDir}/scripts
        cp ${cfg.package}/config/jvm.options ${configDir}/jvm.options
        # redirect jvm logs to the data directory
        mkdir -m 0700 -p ${cfg.dataDir}/logs
        ${pkgs.sd}/bin/sd 'logs/gc.log' '${cfg.dataDir}/logs/gc.log' ${configDir}/jvm.options \

        if [ "$(id -u)" = 0 ]; then chown -R opensearch:opensearch ${cfg.dataDir}; fi
      '';
      postStart = ''
        # Make sure OpenSearch is up and running before dependents
        # are started
        while ! ${pkgs.curl}/bin/curl -sS -f http://${cfg.listenAddress}:${toString cfg.port} 2>/dev/null; do
          sleep 1
        done
      '';
    };

    environment.systemPackages = [ cfg.package ];

    users = {
      groups.opensearch.gid = config.ids.gids.opensearch;
      users.opensearch = {
        uid = config.ids.uids.opensearch;
        description = "OpenSearch daemon user";
        isSystemUser = true;
        home = cfg.dataDir;
        group = "opensearch";
        useDefaultShell = true;
      };
    };
  };
}
