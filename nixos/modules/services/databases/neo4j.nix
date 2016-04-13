{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.neo4j;

  serverConfig = pkgs.writeText "neo4j-server.properties" ''
    org.neo4j.server.database.location=${cfg.dataDir}/data/graph.db
    org.neo4j.server.webserver.address=${cfg.listenAddress}
    org.neo4j.server.webserver.port=${toString cfg.port}
    ${optionalString cfg.enableHttps ''
      org.neo4j.server.webserver.https.enabled=true
      org.neo4j.server.webserver.https.port=${toString cfg.httpsPort}
      org.neo4j.server.webserver.https.cert.location=${cfg.cert}
      org.neo4j.server.webserver.https.key.location=${cfg.key}
      org.neo4j.server.webserver.https.keystore.location=${cfg.dataDir}/data/keystore
    ''}
    org.neo4j.server.webadmin.rrdb.location=${cfg.dataDir}/data/rrd
    org.neo4j.server.webadmin.data.uri=/db/data/
    org.neo4j.server.webadmin.management.uri=/db/manage/
    org.neo4j.server.db.tuning.properties=${cfg.package}/share/neo4j/conf/neo4j.properties
    org.neo4j.server.manage.console_engines=shell
    ${cfg.extraServerConfig}
  '';

  loggingConfig = pkgs.writeText "logging.properties" cfg.loggingConfig;

  wrapperConfig = pkgs.writeText "neo4j-wrapper.conf" ''
    wrapper.java.additional=-Dorg.neo4j.server.properties=${serverConfig}
    wrapper.java.additional=-Djava.util.logging.config.file=${loggingConfig}
    wrapper.java.additional=-XX:+UseConcMarkSweepGC
    wrapper.java.additional=-XX:+CMSClassUnloadingEnabled
    wrapper.pidfile=${cfg.dataDir}/neo4j-server.pid
    wrapper.name=neo4j
  '';

in {

  ###### interface

  options.services.neo4j = {
    enable = mkOption {
      description = "Whether to enable neo4j.";
      default = false;
      type = types.bool;
    };

    package = mkOption {
      description = "Neo4j package to use.";
      default = pkgs.neo4j;
      defaultText = "pkgs.neo4j";
      type = types.package;
    };

    listenAddress = mkOption {
      description = "Neo4j listen address.";
      default = "127.0.0.1";
      type = types.str;
    };

    port = mkOption {
      description = "Neo4j port to listen for HTTP traffic.";
      default = 7474;
      type = types.int;
    };

    enableHttps = mkOption {
      description = "Enable https for Neo4j.";
      default = false;
      type = types.bool;
    };

    httpsPort = mkOption {
      description = "Neo4j port to listen for HTTPS traffic.";
      default = 7473;
      type = types.int;
    };

    cert = mkOption {
      description = "Neo4j https certificate.";
      default = "${cfg.dataDir}/conf/ssl/neo4j.cert";
      type = types.path;
    };

    key = mkOption {
      description = "Neo4j https certificate key.";
      default = "${cfg.dataDir}/conf/ssl/neo4j.key";
      type = types.path;
    };

    dataDir = mkOption {
      description = "Neo4j data directory.";
      default = "/var/lib/neo4j";
      type = types.path;
    };

    loggingConfig = mkOption {
      description = "Neo4j logging configuration.";
      default = ''
        handlers=java.util.logging.ConsoleHandler
        .level=INFO
        org.neo4j.server.level=INFO

        java.util.logging.ConsoleHandler.level=INFO
        java.util.logging.ConsoleHandler.formatter=org.neo4j.server.logging.SimpleConsoleFormatter
        java.util.logging.ConsoleHandler.filter=org.neo4j.server.logging.NeoLogFilter
      '';
      type = types.lines;
    };

    extraServerConfig = mkOption {
      description = "Extra configuration for neo4j server.";
      default = "";
      type = types.lines;
    };

  };

  ###### implementation

  config = mkIf cfg.enable {
    systemd.services.neo4j = {
      description = "Neo4j Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-interfaces.target" ];
      environment = { NEO4J_INSTANCE = cfg.dataDir; };
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/neo4j console";
        User = "neo4j";
        PermissionsStartOnly = true;
      };
      preStart = ''
        mkdir -m 0700 -p ${cfg.dataDir}/{data/graph.db,conf}
        ln -fs ${wrapperConfig} ${cfg.dataDir}/conf/neo4j-wrapper.conf
        if [ "$(id -u)" = 0 ]; then chown -R neo4j ${cfg.dataDir}; fi
      '';
    };

    environment.systemPackages = [ pkgs.neo4j ];

    users.extraUsers = singleton {
      name = "neo4j";
      uid = config.ids.uids.neo4j;
      description = "Neo4j daemon user";
      home = cfg.dataDir;
    };
  };

}
