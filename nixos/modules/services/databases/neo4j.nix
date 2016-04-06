{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.neo4j;
  snakeOilKey = pkgs.writeText "key.snakeoil" "
-----BEGIN PRIVATE KEY-----
MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALcOfLwKTt5Dyv7e
8Tn0qf277HWY5vFeYDODmZb1qJJm501pAlG/yicCJwZruDZfRNxy8GlzVSITP5ch
gFXnMdBzN9DXOnV4263qdvyh97SPH+6SQ4O76eFZHUTlocjA1HfJ4Kw33acbpksv
iIX+rHg+Hw3XBu2pXh317WylN1MNAgMBAAECgYAIeAsdR/zOG6TQlc/jNoaGzqLp
7eEBWbRprbT1Xvgljc01r54D2jOoCllz2pfzLAUrjcXBmyxdHzbZ7xrY3pFXV2xD
nho//zr98ESalpmFGk0APNJWI/YL7EKwQlrg3WsxGsyLbLUlHXnx6mrn0S+xw6+K
mnNPao4X9P9snEUIAQJBAOXWfUWeQOlyShBuYmUubBrGCqEBzHaKxqpkNY5E4kUa
FB2QJY3mEiiGaAAckqY2ViNy2C8NlZ3c5fKSjBflAEECQQDL5MjmORKpgJhDMOOX
oHFVxxnTUa1IZTF0EzCwQkkTXUzghgmZCFCBufGtU3H8o9DDbYk+xzPAEDRf8gt4
Pl/NAkBJ6O7B+4EeUS12GTk1FneXKIZ0flKU8E2wr6b1SDuHQzqiwx8AgbLnK0m4
d3fFUYXjwmO4xeKOMGIV3oCEkpTBAkEAhKYioc0tvAMCjGwpFYN3WJQA1D+GGdxj
8R1vBq0JN8Tyd/wcEGidX9imR9pLBU9aSVpg+OvGWkTwnh8toRwLXQJAege0/OZC
1PNBbuly2/2a3VwqtcviFVioJ6ZOndrMnewxZdFdrgH1+DuZ6Zd68LtkUkObIowS
Ry5XL+gNQGEpdg==
-----END PRIVATE KEY-----
";
  snakeOilCrt = pkgs.writeText "crt.snakeoil" " 
-----BEGIN CERTIFICATE-----
MIIBoTCCAQqgAwIBAgIIb15FnnidHWgwDQYJKoZIhvcNAQENBQAwEjEQMA4GA1UE
AwwHMC4wLjAuMDAgFw0xNTA0MDYyMTI5MTBaGA85OTk5MTIzMTIzNTk1OVowEjEQ
MA4GA1UEAwwHMC4wLjAuMDCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAtw58
vApO3kPK/t7xOfSp/bvsdZjm8V5gM4OZlvWokmbnTWkCUb/KJwInBmu4Nl9E3HLw
aXNVIhM/lyGAVecx0HM30Nc6dXjbrep2/KH3tI8f7pJDg7vp4VkdROWhyMDUd8ng
rDfdpxumSy+Ihf6seD4fDdcG7aleHfXtbKU3Uw0CAwEAATANBgkqhkiG9w0BAQ0F
AAOBgQCXDoyfw6RRq9H7dGla7/dL7mz8j4pt9+7E77pQ2FAdgJhBm7XyoKSsahk7
cOYO93Fia87NUTfHLQFqzl0ciKZjcfLTHJKkp/7QEE/FTKasT5LhPfxkfEXEynsp
Tf6ltnTruwZ+q4d997rD7X6fFY/+AohSQvxv+UFfd2Wxk/wIdg==
-----END CERTIFICATE-----
";

  serverConfig = pkgs.writeText "neo4j-server.properties" ''
    org.neo4j.server.database.location=${cfg.dataDir}/data/graph.db
    org.neo4j.server.webserver.address=${cfg.listenAddress}
    org.neo4j.server.webserver.port=${toString cfg.port}
    ${if cfg.enableHttps
      then
      ''
      org.neo4j.server.webserver.https.enabled=true
      org.neo4j.server.webserver.https.port=${toString cfg.httpsPort}
      org.neo4j.server.webserver.https.cert.location=${cfg.cert}
      org.neo4j.server.webserver.https.key.location=${cfg.key}
      dbms.security.tls_certification_file=${cfg.cert}
      dbms.security.tls_key_file=${cfg.key}
      ''
      # even if you do not use TLS, neo4j needs a snakeoil certificate
      else
      ''
      org.neo4j.server.webserver.https.cert.location=${snakeOilCrt}
      org.neo4j.server.webserver.https.key.location=${snakeOilKey}
      dbms.security.tls_certification_file=${snakeOilCrt}
      dbms.security.tls_key_file=${snakeOilKey}
      ''
    }  
    org.neo4j.server.webadmin.rrdb.location=${cfg.dataDir}/data/rrd
    org.neo4j.server.webadmin.data.uri=/db/data/
    org.neo4j.server.webadmin.management.uri=/db/manage/
    org.neo4j.server.db.tuning.properties=${cfg.package}/share/neo4j/conf/neo4j.properties
    org.neo4j.server.manage.console_engines=shell
    org.neo4j.server.http.log.enabled=false
    org.neo4j.server.http.log.config=${loggingConfig}
    ${if cfg.enableAuth
      then
      ''
      dbms.security.auth_enabled=true
      dbms.security.auth_store.location=${cfg.dataDir}/data/dbms/auth
      ''
      else
      ''
      dbms.security.auth_enabled=false
      ''
    }
    org.neo4j.server.webserver.https.keystore.location=${cfg.dataDir}/data/keystore
    ${cfg.extraServerConfig}
  '';

  loggingConfig = pkgs.writeText "logging.properties" cfg.loggingConfig;
  wrapperConfig = pkgs.writeText "neo4j-wrapper.conf" ''
    wrapper.pidfile=${cfg.dataDir}/neo4j-server.pid
    wrapper.name=neo4j
    ${
    let
      mkAdditionalWrapperConfig = additionalConfig: "wrapper.java.additional="+additionalConfig;
    in concatMapStringsSep "\n" mkAdditionalWrapperConfig cfg.additionalWrapperConfig
    }
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
    
    enableAuth = mkOption {
      description = "Enable auth for Neo4j.";
      default = true;
      type = types.bool;
    };

    httpsPort = mkOption {
      description = "Neo4j port to listen for HTTPS traffic.";
      default = 7473;
      type = types.int;
    };

    cert = mkOption {
      description = "Neo4j https certificate.";
      type = types.path;
    };

    key = mkOption {
      description = "Neo4j https certificate key.";
      type = types.path;
    };

    dataDir = mkOption {
      description = "Neo4j data directory.";
      default = "/var/lib/neo4j";
      type = types.path;
    };

    additionalWrapperConfig = mkOption {
      description = "Neo4j additional wrapper configuration.";
      default =
      [ "-Dorg.neo4j.server.properties=${cfg.dataDir}/conf/neo4j-server.properties"
        "-Djava.util.logging.config.file=${cfg.dataDir}/conf/neo4j-logging.xml"
        "-XX:+UseConcMarkSweepGC"
        "-XX:+CMSClassUnloadingEnabled" ];
      type = types.listOf types.str;
    };

    loggingConfig = mkOption {
      description = "Neo4j logging configuration.";
      default = ''
	<configuration>
          <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
            <file>${cfg.dataDir}/data/log/http.log</file>
            <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
              <fileNamePattern>${cfg.dataDir}/data/log/http.%d{yyyy-MM-dd_HH}.log</fileNamePattern>
              <maxHistory>30</maxHistory>
            </rollingPolicy>
         <encoder>
            <!-- Note the deliberate misspelling of "referer" in accordance with RFC1616 -->
            <pattern>%h %l %user [%t{dd/MMM/yyyy:HH:mm:ss Z}] "%r" %s %b "%i{Referer}" "%i{User-Agent}"</pattern>
          </encoder>
        </appender>
        <appender-ref ref="FILE"/>
      </configuration>
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
      environment = {
        NEO4J_INSTANCE = cfg.dataDir;
	NEO4J_CONFIG = "${cfg.dataDir}/conf";
	NEO4J_LOG ="${cfg.dataDir}/data/log";
	NEO4J_PIDFILE = "${cfg.dataDir}/neo4j-server.pid";
      };
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/neo4j console";
	LimitNOFILE = 40000;
        User = "neo4j";
        PermissionsStartOnly = true;
	PIDFile="${cfg.dataDir}/neo4j-server.pid";
      };
      preStart = ''
        mkdir -m 0700 -p ${cfg.dataDir}/{data/graph.db,data/dbms/,data/keystore,conf/ssl,log}
        ln -fs ${wrapperConfig} ${cfg.dataDir}/conf/neo4j-wrapper.conf
	ln -fs ${serverConfig} ${cfg.dataDir}/conf/neo4j-server.properties
	ln -fs ${loggingConfig} ${cfg.dataDir}/conf/neo4j-logging.xml
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
