{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.pulsar;

  zkServersConfText = concatStringsSep "\n" (builtins.genList
    (idx: let
      host = builtins.elemAt cfg.zookeeper.servers idx;
    in "servers.${toString idx}=${host}:2888:3888")
    (builtins.length cfg.zookeeper.servers)
  );
  zkConf = pkgs.writeText "pulsar-zookeeper.cfg" ''
    clientPort=${toString cfg.zookeeper.clientPort}
    dataDir=${cfg.zookeeper.dataDir}
    ${cfg.zookeeper.extraConf}
    ${zkServersConfText}
  '';

  zkConnectionString = concatStringsSep "," (map
    (host: ''${host}:${toString cfg.zookeeper.clientPort}'')
    cfg.zookeeper.servers
  );

  bkConf = pkgs.writeText "pulsar-bookie.cfg" ''
    zkServers=${zkConnectionString}
    advertisedAddress=${cfg.bookie.advertisedAddress}
    journalDirectories=${cfg.bookie.dataDir}/journal
    ledgerDirectories=${cfg.bookie.dataDir}/ledger
    storage.range.store.dirs=${cfg.bookie.dataDir}/range
    ${cfg.bookie.extraConf}
  '';

  brokerConf = pkgs.writeText "pulsar-broker.cfg" ''
    zookeeperServers=${zkConnectionString}
    configurationStoreServers=${zkConnectionString}
    clusterName=pulsar-cluster-1
    # to not conflict with the bookkeeper admin interface
    webServicePort=8081
    ${cfg.broker.extraConf}
  '';

  loggingConf = pkgs.writeText "log4j.properties" cfg.logging;

  environment = {
    PULSAR_ZK_CONF = zkConf;
    PULSAR_BOOKKEEPER_CONF = bkConf;
    BOOKIE_CONF = bkConf;
    PULSAR_BROKER_CONF = brokerConf;
    PULSAR_LOG_CONF = loggingConf;
    BOOKIE_LOG_CONF = loggingConf;
    PULSAR_MEM = cfg.jvmMemoryOptions;
  };
in {
  options.services.pulsar = {
    package = mkOption {
      description = "The pulsar package to use";
      default = pkgs.pulsar;
      defaultText = "pkgs.pulsar";
      type = types.package;
    };

    webServiceUrl = mkOption {
      description = "Web service URL that the cluster will be initalized with";
      default = "http://127.0.0.1:8080";
      type = types.str;
    };

    brokerServiceUrl = mkOption {
      description = "Broker service URL that the cluster will be initalized with";
      default = "pulsar://127.0.0.1:6650";
      type = types.str;
    };

    logging = mkOption {
      description = "Log4j logging configuration.";
      default = ''
        zookeeper.root.logger=INFO, CONSOLE
        log4j.rootLogger=INFO, CONSOLE
        log4j.appender.CONSOLE=org.apache.log4j.ConsoleAppender
        log4j.appender.CONSOLE.layout=org.apache.log4j.PatternLayout
        log4j.appender.CONSOLE.layout.ConversionPattern=[myid:%X{myid}] - %-5p [%t:%C{1}@%L] - %m%n
      '';
      type = types.lines;
    };

    jvmMemoryOptions = mkOption {
      description = "JVM memory options, overriding Pulsar's defaults.";
      default = "";
      example = "-Xms64m -Xmx64m";
      type = types.str;
    };
  };

  options.services.pulsar.zookeeper = {
    enable = mkOption {
      description = "Whether to run a pulsar Zookeeper.";
      default = false;
      type = types.bool;
    };

    id = mkOption {
      description = ''
        This node's Zookeeper id, a 0-index of the current server in
        services.pulsar.zookeeper.servers list.
      '';
      default = 0;
      type = types.int;
    };

    servers = mkOption {
      description = "Hosts of all pulsar Zookeeper Servers.";
      default = ["127.0.0.1"];
      type = types.listOf types.str;
      example = ["host0" "host1" "host2"];
    };

    dataDir = mkOption {
      description = "Data directory for Zookeeper.";
      type = types.path;
      default = "/var/lib/pulsar-zookeeper";
    };

    clientPort = mkOption {
      description = "Port to run the client Zookeeper service for pulsar.";
      type = types.int;
      default = 2181;
    };

    extraConf = mkOption {
      description = "Extra configuration for pulsar Zookeeper.";
      type = types.lines;
      default = ''
        initLimit=5
        syncLimit=2
        tickTime=2000
        autopurge.purgeInterval=1
      '';
    };
  };

  options.services.pulsar.bookie = {
    enable = mkOption {
      description = "Whether to run a Pulsar Bookkeeper.";
      default = false;
      type = types.bool;
    };

    dataDir = mkOption {
      description = "Data directory for Bookkeeper.";
      type = types.path;
      default = "/var/lib/pulsar-bookie";
    };

    advertisedAddress = mkOption {
      description = "Advertised IP address for this node";
      type = types.str;
      default = "127.0.0.1";
    };

    extraConf = mkOption {
      description = "Extra configuration for Bookkeeper.";
      type = types.lines;
      default = "";
    };
  };

  options.services.pulsar.broker = {
    enable = mkOption {
      description = "Whether to run a pulsar Broker.";
      default = false;
      type = types.bool;
    };

    extraConf = mkOption {
      description = "Extra configuration for the Broker.";
      type = types.lines;
      default = "";
    };
  };

  config = {
    users.users.pulsar-zookeeper = mkIf cfg.zookeeper.enable {
      description = "Pulsar zookeeper daemons user";
      uid = config.ids.uids.pulsar-zookeeper;
      home = cfg.zookeeper.dataDir;
      createHome = true;
    };
    systemd.services.pulsar-zookeeper = mkIf cfg.zookeeper.enable {
      description = "Pulsar's Zookeeper Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      inherit environment;
      serviceConfig.User = "pulsar-zookeeper";
      script = "${cfg.package}/bin/pulsar zookeeper";
      preStart = ''
        echo "${toString cfg.zookeeper.id}" > ${cfg.zookeeper.dataDir}/myid
      '';
    };

    users.users.pulsar-bookie = mkIf cfg.bookie.enable {
      description = "Pulsar bookie daemons user";
      uid = config.ids.uids.pulsar-bookie;
      home = cfg.bookie.dataDir;
      createHome = true;
    };
    systemd.services.pulsar-bookie = mkIf cfg.bookie.enable {
      description = "Pulsar's Bookkeeper Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
        "pulsar-zookeeper.target"
      ];
      inherit environment;
      serviceConfig.User = "pulsar-bookie";
      script = ''
        # It is non-destruction to re-run the cluster initialization
        ${cfg.package}/bin/pulsar initialize-cluster-metadata \
            --cluster pulsar-cluster-1 \
            --zookeeper ${zkConnectionString} \
            --configuration-store ${zkConnectionString} \
            --web-service-url ${cfg.webServiceUrl} \
            --broker-service-url ${cfg.brokerServiceUrl}
        # However we should only format the bookie data once
        if [ ! -f ${cfg.bookie.dataDir}/has-done-init ]; then
          ${cfg.package}/bin/bookkeeper shell bookieformat
          touch ${cfg.bookie.dataDir}/has-done-init
        fi
        ${cfg.package}/bin/pulsar bookie
      '';
    };

    users.users.pulsar-broker = mkIf cfg.broker.enable {
      description = "Pulsar broker daemons user";
      uid = config.ids.uids.pulsar-broker;
    };
    systemd.services.pulsar-broker = mkIf cfg.broker.enable {
      description = "Pulsar's Broker Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
        "pulsar-zookeeper.target"
        "pulsar-bookie.target"
      ];
      inherit environment;
      serviceConfig.User = "pulsar-broker";
      script = "${cfg.package}/bin/pulsar broker";
    };
  };
}
