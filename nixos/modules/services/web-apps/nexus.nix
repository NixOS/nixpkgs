{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.services.nexus;

in
{
  options = {
    services.nexus = {
      enable = lib.mkEnableOption "Sonatype Nexus3 OSS service";

      package = lib.mkPackageOption pkgs "nexus" { };

      jdkPackage = lib.mkPackageOption pkgs "openjdk8" { };

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
        type = lib.types.int;
        default = 8081;
        description = "Port to listen on.";
      };

      jvmOpts = lib.mkOption {
        type = lib.types.lines;
        default = ''
          -Xms1200M
          -Xmx1200M
          -XX:MaxDirectMemorySize=2G
          -XX:+UnlockDiagnosticVMOptions
          -XX:+UnsyncloadClass
          -XX:+LogVMOutput
          -XX:LogFile=${cfg.home}/nexus3/log/jvm.log
          -XX:-OmitStackTraceInFastThrow
          -Djava.net.preferIPv4Stack=true
          -Dkaraf.home=${cfg.package}
          -Dkaraf.base=${cfg.package}
          -Dkaraf.etc=${cfg.package}/etc/karaf
          -Djava.util.logging.config.file=${cfg.package}/etc/karaf/java.util.logging.properties
          -Dkaraf.data=${cfg.home}/nexus3
          -Djava.io.tmpdir=${cfg.home}/nexus3/tmp
          -Dkaraf.startLocalConsole=false
          -Djava.endorsed.dirs=${cfg.package}/lib/endorsed
        '';
        defaultText = lib.literalExpression ''
          '''
            -Xms1200M
            -Xmx1200M
            -XX:MaxDirectMemorySize=2G
            -XX:+UnlockDiagnosticVMOptions
            -XX:+UnsyncloadClass
            -XX:+LogVMOutput
            -XX:LogFile=''${home}/nexus3/log/jvm.log
            -XX:-OmitStackTraceInFastThrow
            -Djava.net.preferIPv4Stack=true
            -Dkaraf.home=''${package}
            -Dkaraf.base=''${package}
            -Dkaraf.etc=''${package}/etc/karaf
            -Djava.util.logging.config.file=''${package}/etc/karaf/java.util.logging.properties
            -Dkaraf.data=''${home}/nexus3
            -Djava.io.tmpdir=''${home}/nexus3/tmp
            -Dkaraf.startLocalConsole=false
            -Djava.endorsed.dirs=''${package}/lib/endorsed
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

        INSTALL4J_JAVA_HOME = cfg.jdkPackage;
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

      script = "${cfg.package}/bin/nexus run";

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        PrivateTmp = true;
        LimitNOFILE = 102642;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ ironpinguin ];
}
