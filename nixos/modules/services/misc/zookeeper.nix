{
  config,
  lib,
  pkgs,
  ...
}:
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
      (pkgs.writeTextDir "logback.xml" cfg.logging)
    ];
  };

in
{

  options.services.zookeeper = {
    enable = lib.mkEnableOption "Zookeeper";

    port = lib.mkOption {
      description = "Zookeeper Client port.";
      default = 2181;
      type = lib.types.port;
    };

    id = lib.mkOption {
      description = "Zookeeper ID.";
      default = 0;
      type = lib.types.int;
    };

    purgeInterval = lib.mkOption {
      description = ''
        The time interval in hours for which the purge task has to be triggered. Set to a positive integer (1 and above) to enable the auto purging.
      '';
      default = 1;
      type = lib.types.int;
    };

    extraConf = lib.mkOption {
      description = "Extra configuration for Zookeeper.";
      type = lib.types.lines;
      default = ''
        initLimit=5
        syncLimit=2
        tickTime=2000
      '';
    };

    servers = lib.mkOption {
      description = "All Zookeeper Servers.";
      default = "";
      type = lib.types.lines;
      example = ''
        server.0=host0:2888:3888
        server.1=host1:2888:3888
        server.2=host2:2888:3888
      '';
    };

    logging = lib.mkOption {
      description = "Zookeeper logging configuration, logback.xml.";
      default = ''
        <configuration>
          <property name="zookeeper.console.threshold" value="INFO" />
          <property name="zookeeper.log.dir" value="." />
          <property name="zookeeper.log.file" value="zookeeper.log" />
          <property name="zookeeper.log.threshold" value="INFO" />
          <property name="zookeeper.log.maxfilesize" value="256MB" />
          <property name="zookeeper.log.maxbackupindex" value="20" />
          <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
            <encoder>
              <pattern>%d{ISO8601} [myid:%X{myid}] - %-5p [%t:%C{1}@%L] - %m%n</pattern>
            </encoder>
            <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
              <level>''${zookeeper.console.threshold}</level>
            </filter>
          </appender>
          <root level="INFO">
            <appender-ref ref="CONSOLE" />
          </root>
        </configuration>
      '';
      type = lib.types.lines;
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/zookeeper";
      description = ''
        Data directory for Zookeeper
      '';
    };

    extraCmdLineOptions = lib.mkOption {
      description = "Extra command line options for the Zookeeper launcher.";
      default = [
        "-Dcom.sun.management.jmxremote"
        "-Dcom.sun.management.jmxremote.local.only=true"
      ];
      type = lib.types.listOf lib.types.str;
      example = [
        "-Djava.net.preferIPv4Stack=true"
        "-Dcom.sun.management.jmxremote"
        "-Dcom.sun.management.jmxremote.local.only=true"
      ];
    };

    preferIPv4 = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Add the -Djava.net.preferIPv4Stack=true flag to the Zookeeper server.
      '';
    };

    package = lib.mkPackageOption pkgs "zookeeper" { };

    jre = lib.mkOption {
      description = "The JRE with which to run Zookeeper";
      default = cfg.package.jre;
      defaultText = lib.literalExpression "pkgs.zookeeper.jre";
      example = lib.literalExpression "pkgs.jre";
      type = lib.types.package;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

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
            ${lib.escapeShellArgs cfg.extraCmdLineOptions} \
            -Dzookeeper.datadir.autocreate=false \
            ${lib.optionalString cfg.preferIPv4 "-Djava.net.preferIPv4Stack=true"} \
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
    users.groups.zookeeper = { };
  };
}
