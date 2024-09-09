{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.zookeeper;

  zookeeperConfig = ''
    dataDir=${cfg.dataDir}
    clientPort=${toString cfg.port}
    autopurge.purgeInterval=${toString cfg.purgeInterval}
    ${cfg.extraConf}
    ${cfg.servers}
  '';

  configDir = pkgs.buildEnv {
    name = "zookeeper-conf";
    paths = [
      (pkgs.writeTextDir "zoo.cfg" zookeeperConfig)
      (pkgs.writeTextDir "log4j.properties" cfg.logging)
    ];
  };

in {

  options.services.zookeeper = {
    enable = mkEnableOption "Zookeeper";

    port = mkOption {
      description = "Zookeeper Client port.";
      default = 2181;
      type = types.port;
    };

    id = mkOption {
      description = "Zookeeper ID.";
      default = 0;
      type = types.int;
    };

    purgeInterval = mkOption {
      description = ''
        The time interval in hours for which the purge task has to be triggered. Set to a positive integer (1 and above) to enable the auto purging.
      '';
      default = 1;
      type = types.int;
    };

    extraConf = mkOption {
      description = "Extra configuration for Zookeeper.";
      type = types.lines;
      default = ''
        initLimit=5
        syncLimit=2
        tickTime=2000
      '';
    };

    servers = mkOption {
      description = "All Zookeeper Servers.";
      default = "";
      type = types.lines;
      example = ''
        server.0=host0:2888:3888
        server.1=host1:2888:3888
        server.2=host2:2888:3888
      '';
    };

    logging = mkOption {
      description = "Zookeeper logging configuration.";
      default = ''
        zookeeper.root.logger=INFO, CONSOLE
        log4j.rootLogger=INFO, CONSOLE
        log4j.logger.org.apache.zookeeper.audit.Log4jAuditLogger=INFO, CONSOLE
        log4j.appender.CONSOLE=org.apache.log4j.ConsoleAppender
        log4j.appender.CONSOLE.layout=org.apache.log4j.PatternLayout
        log4j.appender.CONSOLE.layout.ConversionPattern=[myid:%X{myid}] - %-5p [%t:%C{1}@%L] - %m%n
      '';
      type = types.lines;
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/zookeeper";
      description = ''
        Data directory for Zookeeper
      '';
    };

    extraCmdLineOptions = mkOption {
      description = "Extra command line options for the Zookeeper launcher.";
      default = [ "-Dcom.sun.management.jmxremote" "-Dcom.sun.management.jmxremote.local.only=true" ];
      type = types.listOf types.str;
      example = [ "-Djava.net.preferIPv4Stack=true" "-Dcom.sun.management.jmxremote" "-Dcom.sun.management.jmxremote.local.only=true" ];
    };

    preferIPv4 = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Add the -Djava.net.preferIPv4Stack=true flag to the Zookeeper server.
      '';
    };

    package = mkPackageOption pkgs "zookeeper" { };

    jre = mkOption {
      description = "The JRE with which to run Zookeeper";
      default = cfg.package.jre;
      defaultText = literalExpression "pkgs.zookeeper.jre";
      example = literalExpression "pkgs.jre";
      type = types.package;
    };
  };


  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0700 zookeeper - - -"
      "Z '${cfg.dataDir}' 0700 zookeeper - - -"
    ];

    systemd.services.zookeeper = {
      description = "Zookeeper Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = ''
          ${cfg.jre}/bin/java \
            -cp "${cfg.package}/lib/*:${configDir}" \
            ${escapeShellArgs cfg.extraCmdLineOptions} \
            -Dzookeeper.datadir.autocreate=false \
            ${optionalString cfg.preferIPv4 "-Djava.net.preferIPv4Stack=true"} \
            org.apache.zookeeper.server.quorum.QuorumPeerMain \
            ${configDir}/zoo.cfg
        '';
        User = "zookeeper";
      };
      preStart = ''
        echo "${toString cfg.id}" > ${cfg.dataDir}/myid
        mkdir -p ${cfg.dataDir}/version-2
      '';
    };

    users.users.zookeeper = {
      isSystemUser = true;
      group = "zookeeper";
      description = "Zookeeper daemon user";
      home = cfg.dataDir;
    };
    users.groups.zookeeper = {};
  };
}
