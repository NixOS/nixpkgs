{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.nexus;
  pkg = cfg.package;
in
{
  options = {
    services.nexus = {
      enable = lib.mkEnableOption "Sonatype Nexus3 OSS service";

      package = lib.mkOption {
        type = lib.types.package;
        default =
          if lib.versionAtLeast config.system.stateVersion "26.11" then pkgs.nexus_3 else pkgs.nexus;
        defaultText = lib.literalExpression ''
          if lib.versionAtLeast config.system.stateVersion "26.11"
          then pkgs.nexus_3
          else pkgs.nexus;
        '';
        description = ''
          Nexus package to use. Note that upgrading from the nexus to the nexus3
          package requires manual intervention before the upgrade.
        '';
      };

      jdkPackage = lib.mkOption {
        type = lib.types.package;
        default = if lib.versionAtLeast pkg.version "3.71.0" then pkgs.jdk21_headless else pkgs.openjdk8;
        defaultText = lib.literalExpression ''
          if lib.versionAtLeast pkg "3.71.0"
          then pkgs.jdk21_headless
          else pkgs.openjdk8;
        '';
        description = ''
          JDK Package used to run nexus. Note that newer versions of nexus require JDK 21 or higher.
        '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "nexus";
        description = "User which runs Nexus3.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "nexus";
        description = "Group which runs Nexus3.";
      };

      home = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/sonatype-work";
        description = "Home directory of the Nexus3 instance.";
      };

      listenAddress = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Address to listen on.";
      };

      listenPort = lib.mkOption {
        type = lib.types.port;
        default = 8081;
        description = "Port to listen on.";
      };

      initialJavaHeapSize = lib.mkOption {
        type = lib.types.str;
        default = "1024M";
        description = "Initial JVM heap size in MiB to allocate.";
      };

      maxJavaHeapMemory = lib.mkOption {
        type = lib.types.str;
        default = cfg.initialJavaHeapSize;
        defaultText = lib.literalExpression "cfg.intialJavaHeapSize";
        description = "Maxium heap size in MiB the JVM is allowed to allocate.";
      };

      maxDirectMemorySize = lib.mkOption {
        type = lib.types.str;
        default = "2G";
        description = "Sets the maximum total size (in bytes) of the `java.nio` package, direct-buffer allocations. If not set, the flag is ignored and the JVM chooses the size for NIO direct-buffer allocations automatically.";
      };

      jvmOpts = lib.mkOption {
        type = lib.types.lines;
        default = ''
          -Xms${cfg.initialJavaHeapSize}
          -Xmx${cfg.maxJavaHeapMemory}
          -XX:MaxDirectMemorySize=${cfg.maxDirectMemorySize}
          -XX:-OmitStackTraceInFastThrow
          -Dkaraf.home=${cfg.package}
          -Dkaraf.base=${cfg.package}
          -Dkaraf.etc=${cfg.package}/etc/karaf
          -Djava.util.logging.config.file=${cfg.package}/etc/karaf/java.util.logging.properties
          -Dkaraf.data=${cfg.home}/nexus3
          -Djava.io.tmpdir=${cfg.home}/nexus3/tmp
          -Dkaraf.startLocalConsole=false
        '';
        defaultText = lib.literalExpression ''
          '''
            -Xms''${initialJavaHeapSize}
            -Xmx''${maxJavaHeapMemory}
            -XX:MaxDirectMemorySize=''${maxDirectMemorySize}
            -XX:-OmitStackTraceInFastThrow
            -Dkaraf.home=''${package}
            -Dkaraf.base=''${package}
            -Dkaraf.etc=''${package}/etc/karaf
            -Djava.util.logging.config.file=''${package}/etc/karaf/java.util.logging.properties
            -Dkaraf.data=''${home}/nexus3
            -Djava.io.tmpdir=''${home}/nexus3/tmp
            -Dkaraf.startLocalConsole=false
          '''
        '';

        description = ''
          Options for the JVM written to `nexus.jvmopts`.
          Please refer to the docs (https://help.sonatype.com/repomanager3/installation/configuring-the-runtime-environment)
          for further information.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    warnings = lib.optional (lib.versionOlder pkg.version "3.71.0") ''
      A legacy Nexus version (from before NixOS 26.11) may be installed.

      To upgrade to a version higher than ${pkg.version}, the database needs to
      be updated to a v2.x H2 database. See https://help.sonatype.com/en/upgrading-to-nexus-repository-3-71-0-and-beyond.html
      for a guide for upgrading from both OrientDB or H2 v1.x databases.

      After successful database migration, set `services.nexus.package` to `pkgs.nexus_3`.
    '';

    users.users.${cfg.user} = {
      isSystemUser = true;
      inherit (cfg) group home;
      createHome = true;
    };

    users.groups.${cfg.group} = { };

    systemd.services.nexus = {
      description = "Sonatype Nexus3";

      wantedBy = [ "multi-user.target" ];

      path = [ cfg.home ];

      environment = {
        NEXUS_USER = cfg.user;
        NEXUS_HOME = cfg.home;

        APP_JAVA_HOME = cfg.jdkPackage;
        VM_OPTS_FILE = pkgs.writeText "nexus.vmoptions" cfg.jvmOpts;
      };

      preStart = ''
        mkdir -p ${cfg.home}/nexus3/etc

        if [ ! -f ${cfg.home}/nexus3/etc/nexus.properties ]; then
          echo "# Jetty section" > ${cfg.home}/nexus3/etc/nexus.properties
          echo "application-port=${toString cfg.listenPort}" >> ${cfg.home}/nexus3/etc/nexus.properties
          echo "application-host=${toString cfg.listenAddress}" >> ${cfg.home}/nexus3/etc/nexus.properties
        else
          sed 's/^application-port=.*/application-port=${toString cfg.listenPort}/' -i ${cfg.home}/nexus3/etc/nexus.properties
          sed 's/^# application-port=.*/application-port=${toString cfg.listenPort}/' -i ${cfg.home}/nexus3/etc/nexus.properties
          sed 's/^application-host=.*/application-host=${toString cfg.listenAddress}/' -i ${cfg.home}/nexus3/etc/nexus.properties
          sed 's/^# application-host=.*/application-host=${toString cfg.listenAddress}/' -i ${cfg.home}/nexus3/etc/nexus.properties
        fi
      '';

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/nexus run";
        User = cfg.user;
        Group = cfg.group;
        PrivateTmp = true;
        LimitNOFILE = 102642;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [
    ironpinguin
    transcaffeine
  ];
}
