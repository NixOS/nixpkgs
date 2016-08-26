{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.neo4j;

  serverConfig = pkgs.writeText "neo4j.conf" ''
    dbms.directories.certificates=${cfg.dataDir}/certificates
    dbms.directories.logs=${cfg.dataDir}/logs
    dbms.directories.data=${cfg.dataDir}/data
    dbms.directories.metrics=${cfg.dataDir}/metrics
    dbms.directories.plugins=${cfg.dataDir}/plugins
    dbms.connector.http.type=HTTP
    dbms.connector.http.enabled=true
    dbms.connector.http.address=${cfg.listenAddress}:${toString cfg.port}
    ${optionalString cfg.enableHttps ''
      dbms.connector.https.type=HTTP
      dbms.connector.https.enabled=true
      dbms.connector.https.encryption=TLS
      dbms.connector.https.address=${cfg.listenAddress}:${toString cfg.httpsPort}
    ''}
    org.neo4j.server.webadmin.rrdb.location=${cfg.dataDir}/data/rrd
    org.neo4j.server.webadmin.data.uri=/db/data/
    org.neo4j.server.webadmin.management.uri=/db/manage/
    org.neo4j.server.db.tuning.properties=${cfg.package}/share/neo4j/conf/neo4j.properties
    org.neo4j.server.manage.console_engines=shell
    ${cfg.extraServerConfig}
  '';

in {

  ###### interface

  options.services.neo4j = {
    enable = mkEnableOption "neo4j";

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

    dataDir = mkOption {
      description = "Neo4j data directory.";
      default = "/var/lib/neo4j";
      type = types.path;
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
      environment = {
        NEO4J_INSTANCE = cfg.dataDir;
        NEO4J_CONF = "${cfg.dataDir}/conf";
      };
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/neo4j console";
        User = "neo4j";
        PermissionsStartOnly = true;
      };
      preStart = ''
        mkdir -p /run/neo4j
        mkdir -m 0700 -p ${cfg.dataDir}/{data,conf,certificates,logs}
        ln -fs ${serverConfig} ${cfg.dataDir}/conf/neo4j.conf
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
