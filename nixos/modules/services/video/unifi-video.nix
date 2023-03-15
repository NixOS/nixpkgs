{ config, lib, options, pkgs, utils, ... }:
with lib;
let
  cfg = config.services.unifi-video;
  opt = options.services.unifi-video;
  mainClass = "com.ubnt.airvision.Main";
  cmd = ''
    ${pkgs.jsvc}/bin/jsvc \
    -cwd ${stateDir} \
    -debug \
    -verbose:class \
    -nodetach \
    -user unifi-video \
    -home ${cfg.jrePackage}/lib/openjdk \
    -cp ${pkgs.commonsDaemon}/share/java/commons-daemon-1.2.4.jar:${stateDir}/lib/airvision.jar \
    -pidfile ${cfg.pidFile} \
    -procname unifi-video \
    -Djava.security.egd=file:/dev/./urandom \
    -Xmx${toString cfg.maximumJavaHeapSize}M \
    -Xss512K \
    -XX:+UseG1GC \
    -XX:+UseStringDeduplication \
    -XX:MaxMetaspaceSize=768M \
    -Djava.library.path=${stateDir}/lib \
    -Djava.awt.headless=true \
    -Djavax.net.ssl.trustStore=${stateDir}/etc/ufv-truststore \
    -Dfile.encoding=UTF-8 \
    -Dav.tempdir=/var/cache/unifi-video
  '';

  mongoConf = pkgs.writeTextFile {
    name = "mongo.conf";
    executable = false;
    text = ''
      # for documentation of all options, see http://docs.mongodb.org/manual/reference/configuration-options/

      storage:
         dbPath: ${cfg.dataDir}/db
         journal:
            enabled: true
         syncPeriodSecs: 60

      systemLog:
         destination: file
         logAppend: true
         path: ${stateDir}/logs/mongod.log

      net:
         port: 7441
         bindIp: 127.0.0.1
         http:
            enabled: false

      operationProfiling:
         slowOpThresholdMs: 500
         mode: off
    '';
  };


  mongoWtConf = pkgs.writeTextFile {
    name = "mongowt.conf";
    executable = false;
    text = ''
      # for documentation of all options, see:
      #   http://docs.mongodb.org/manual/reference/configuration-options/

      storage:
         dbPath: ${cfg.dataDir}/db-wt
         journal:
            enabled: true
         wiredTiger:
            engineConfig:
               cacheSizeGB: 1

      systemLog:
         destination: file
         logAppend: true
         path: logs/mongod.log

      net:
         port: 7441
         bindIp: 127.0.0.1

      operationProfiling:
         slowOpThresholdMs: 500
         mode: off
    '';
  };

  stateDir = "/var/lib/unifi-video";

in
{

  options.services.unifi-video = {

    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether or not to enable the unifi-video service.
      '';
    };

    jrePackage = mkOption {
      type = types.package;
      default = pkgs.jre8;
      defaultText = literalExpression "pkgs.jre8";
      description = lib.mdDoc ''
        The JRE package to use. Check the release notes to ensure it is supported.
      '';
    };

    unifiVideoPackage = mkOption {
      type = types.package;
      default = pkgs.unifi-video;
      defaultText = literalExpression "pkgs.unifi-video";
      description = lib.mdDoc ''
        The unifi-video package to use.
      '';
    };

    mongodbPackage = mkOption {
      type = types.package;
      default = pkgs.mongodb-4_2;
      defaultText = literalExpression "pkgs.mongodb";
      description = lib.mdDoc ''
        The mongodb package to use.
      '';
    };

    logDir = mkOption {
      type = types.str;
      default = "${stateDir}/logs";
      description = lib.mdDoc ''
        Where to store the logs.
      '';
    };

    dataDir = mkOption {
      type = types.str;
      default = "${stateDir}/data";
      description = lib.mdDoc ''
        Where to store the database and other data.
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether or not to open the required ports on the firewall.
      '';
    };

    maximumJavaHeapSize = mkOption {
      type = types.nullOr types.int;
      default = 1024;
      example = 4096;
      description = lib.mdDoc ''
        Set the maximum heap size for the JVM in MB.
      '';
    };

    pidFile = mkOption {
      type = types.path;
      default = "${cfg.dataDir}/unifi-video.pid";
      defaultText = literalExpression ''"''${config.${opt.dataDir}}/unifi-video.pid"'';
      description = lib.mdDoc "Location of unifi-video pid file.";
    };

  };

  config = mkIf cfg.enable {

    warnings = optional
      (options.services.unifi-video.openFirewall.highestPrio >= (mkOptionDefault null).priority)
      "The current services.unifi-video.openFirewall = true default is deprecated and will change to false in 22.11. Set it explicitly to silence this warning.";

    users.users.unifi-video = {
      description = "UniFi Video controller daemon user";
      home = stateDir;
      group = "unifi-video";
      isSystemUser = true;
    };
    users.groups.unifi-video = {};

    networking.firewall = mkIf cfg.openFirewall {
      # https://help.ui.com/hc/en-us/articles/217875218-UniFi-Video-Ports-Used
      allowedTCPPorts = [
        7080 # HTTP portal
        7443 # HTTPS portal
        7445 # Video over HTTP (mobile app)
        7446 # Video over HTTPS (mobile app)
        7447 # RTSP via the controller
        7442 # Camera management from cameras to NVR over WAN
      ];
      allowedUDPPorts = [
        6666 # Inbound camera streams sent over WAN
      ];
    };

    systemd.tmpfiles.rules = [
      "d '${stateDir}' 0700 unifi-video unifi-video - -"
      "d '/var/cache/unifi-video' 0700 unifi-video unifi-video - -"

      "d '${stateDir}/logs' 0700 unifi-video unifi-video - -"
      "C '${stateDir}/etc' 0700 unifi-video unifi-video - ${pkgs.unifi-video}/lib/unifi-video/etc"
      "C '${stateDir}/webapps' 0700 unifi-video unifi-video - ${pkgs.unifi-video}/lib/unifi-video/webapps"
      "C '${stateDir}/email' 0700 unifi-video unifi-video - ${pkgs.unifi-video}/lib/unifi-video/email"
      "C '${stateDir}/fw' 0700 unifi-video unifi-video - ${pkgs.unifi-video}/lib/unifi-video/fw"
      "C '${stateDir}/lib' 0700 unifi-video unifi-video - ${pkgs.unifi-video}/lib/unifi-video/lib"

      "d '${stateDir}/data' 0700 unifi-video unifi-video - -"
      "d '${stateDir}/data/db' 0700 unifi-video unifi-video - -"
      "C '${stateDir}/data/system.properties' 0700 unifi-video unifi-video - ${pkgs.unifi-video}/lib/unifi-video/etc/system.properties"

      "d '${stateDir}/bin' 0700 unifi-video unifi-video - -"
      "f '${stateDir}/bin/evostreamms' 0700 unifi-video unifi-video - ${pkgs.unifi-video}/lib/unifi-video/bin/evostreamms"
      "f '${stateDir}/bin/libavcodec.so.54' 0700 unifi-video unifi-video - ${pkgs.unifi-video}/lib/unifi-video/bin/libavcodec.so.54"
      "f '${stateDir}/bin/libavformat.so.54' 0700 unifi-video unifi-video - ${pkgs.unifi-video}/lib/unifi-video/bin/libavformat.so.54"
      "f '${stateDir}/bin/libavutil.so.52' 0700 unifi-video unifi-video - ${pkgs.unifi-video}/lib/unifi-video/bin/libavutil.so.52"
      "f '${stateDir}/bin/ubnt.avtool' 0700 unifi-video unifi-video - ${pkgs.unifi-video}/lib/unifi-video/bin/ubnt.avtool"
      "f '${stateDir}/bin/ubnt.updater' 0700 unifi-video unifi-video - ${pkgs.unifi-video}/lib/unifi-video/bin/ubnt.updater"
      "C '${stateDir}/bin/mongo' 0700 unifi-video unifi-video - ${cfg.mongodbPackage}/bin/mongo"
      "C '${stateDir}/bin/mongod' 0700 unifi-video unifi-video - ${cfg.mongodbPackage}/bin/mongod"
      "C '${stateDir}/bin/mongoperf' 0700 unifi-video unifi-video - ${cfg.mongodbPackage}/bin/mongoperf"
      "C '${stateDir}/bin/mongos' 0700 unifi-video unifi-video - ${cfg.mongodbPackage}/bin/mongos"

      "d '${stateDir}/conf' 0700 unifi-video unifi-video - -"
      "C '${stateDir}/conf/evostream' 0700 unifi-video unifi-video - ${pkgs.unifi-video}/lib/unifi-video/conf/evostream"
      "Z '${stateDir}/conf/evostream' 0700 unifi-video unifi-video - -"
      "L+ '${stateDir}/conf/mongodv3.0+.conf' 0700 unifi-video unifi-video - ${mongoConf}"
      "L+ '${stateDir}/conf/mongodv3.6+.conf' 0700 unifi-video unifi-video - ${mongoConf}"
      "L+ '${stateDir}/conf/mongod-wt.conf' 0700 unifi-video unifi-video - ${mongoWtConf}"
      "L+ '${stateDir}/conf/catalina.policy' 0700 unifi-video unifi-video - ${pkgs.unifi-video}/lib/unifi-video/conf/catalina.policy"
      "L+ '${stateDir}/conf/catalina.properties' 0700 unifi-video unifi-video - ${pkgs.unifi-video}/lib/unifi-video/conf/catalina.properties"
      "L+ '${stateDir}/conf/context.xml' 0700 unifi-video unifi-video - ${pkgs.unifi-video}/lib/unifi-video/conf/context.xml"
      "L+ '${stateDir}/conf/logging.properties' 0700 unifi-video unifi-video - ${pkgs.unifi-video}/lib/unifi-video/conf/logging.properties"
      "L+ '${stateDir}/conf/server.xml' 0700 unifi-video unifi-video - ${pkgs.unifi-video}/lib/unifi-video/conf/server.xml"
      "L+ '${stateDir}/conf/tomcat-users.xml' 0700 unifi-video unifi-video - ${pkgs.unifi-video}/lib/unifi-video/conf/tomcat-users.xml"
      "L+ '${stateDir}/conf/web.xml' 0700 unifi-video unifi-video - ${pkgs.unifi-video}/lib/unifi-video/conf/web.xml"
    ];

    systemd.services.unifi-video = {
      description = "UniFi Video NVR daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ] ;
      unitConfig.RequiresMountsFor = stateDir;
      # Make sure package upgrades trigger a service restart
      restartTriggers = [ cfg.unifiVideoPackage cfg.mongodbPackage ];
      path = with pkgs; [ gawk coreutils busybox which jre8 lsb-release libcap util-linux ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${(removeSuffix "\n" cmd)} ${mainClass} start";
        ExecStop = "${(removeSuffix "\n" cmd)} stop ${mainClass} stop";
        Restart = "on-failure";
        UMask = "0077";
        User = "unifi-video";
        WorkingDirectory = "${stateDir}";
      };
    };
  };

  imports = [
    (mkRenamedOptionModule [ "services" "unifi-video" "openPorts" ] [ "services" "unifi-video" "openFirewall" ])
  ];

  meta.maintainers = with lib.maintainers; [ rsynnest ];
}
