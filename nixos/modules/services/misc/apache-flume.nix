{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.apache-flume;

  flumeEnvSh = pkgs.writeTextDir "flume-env.sh" cfg.flumeEnvSh;
  coreSiteXml = pkgs.writeTextDir "core-site.xml" cfg.coreSiteXml;
  flumeConf = pkgs.writeText "flume.conf" cfg.flumeConf;
  logConfig = pkgs.writeText "log4j.properties" cfg.log4jProperties;

in {

  options.services.apache-flume = {
    enable = mkOption {
      description = "Whether to enable Apache flume.";
      default = false;
      type = types.bool;
    };

    homeDir = mkOption {
      description = "Home directory for the flume user.";
      default = "/var/lib/apache-flume";
      type = types.path;
    };

    flumeConf = mkOption {
      description = "Complete flume.conf content.";
      type = types.lines;
      example = ''
        a1.sources = r1
        a1.sources.r1.type = netcat
        a1.sources.r1.bind = localhost
        a1.sources.r1.port = 44444
      '';
      default = ''
        # example.conf: A single-node Flume configuration

        # Name the components on this agent
        a1.sources = r1
        a1.sinks = k1
        a1.channels = c1

        # Describe/configure the source
        a1.sources.r1.type = netcat
        a1.sources.r1.bind = localhost
        a1.sources.r1.port = 44444

        # Describe the sink
        a1.sinks.k1.type = logger

        # Use a channel which buffers events in memory
        a1.channels.c1.type = memory
        a1.channels.c1.capacity = 1000
        a1.channels.c1.transactionCapacity = 100

        # Bind the source and sink to the channel
        a1.sources.r1.channels = c1
        a1.sinks.k1.channel = c1
      '';
    };

    hadoopPackage = mkOption {
      description = "Which hadoop package to use for Flume.";
      default = pkgs.hadoop;
      defaultText = "pkgs.hadoop";
      type = types.package;
    };

    log4jProperties = mkOption {
      description = "Flume log4j property configuration.";
      default = ''
        log4j.rootLogger=INFO, stdout
        log4j.appender.stdout=org.apache.log4j.ConsoleAppender
        log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
        log4j.appender.stdout.layout.ConversionPattern=[%d] %p %m (%c)%n
      '';
      type = types.lines;
    };

    coreSiteXml = mkOption {
      description = ''
        core-site.xml for Hadoop properties.
      '';
      default = ''
        <?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
        <configuration>
          <property>
             <name>fs.s3a.maxRetries</name>
             <value>20</value>
          </property>
        </configuration>
      '';
      defaultText = "";
      type = types.lines;
      example = ''
        <?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
        <configuration>
          <property>
             <name>fs.s3a.maxRetries</name>
             <value>20</value>
          </property>
        </configuration>
      '';
    };

    flumeEnvSh = mkOption {
      description = ''
        Flume environment config. This is sourced by flume on startup to
        set certain environment variables.
      '';
      default = ''
        export FLUME_JAVA_LIBRARY_PATH="${cfg.hadoopPackage}/lib/native"
        export FLUME_JAVA_OPTS="-Dlog4j.configuration=file:${logConfig}"
      '';
      defaultText = "";
      type = types.lines;
      example = ''
        export FLUME_CLASSPATH=/path/to/other/jars
      '';
    };

    javaOptions = mkOption {
      description = "Extra command line options for the JVM running flume.";
      default = ''JAVA_OPTS="-Xmx20m"'';
      type = types.str;
      example = ''JAVA_OPTS="-Xmx20m"'';
    };

    package = mkOption {
      description = "The flume package to use";
      default = pkgs.apacheFlume;
      defaultText = "pkgs.apacheFlume";
      type = types.package;
    };

  };

  config = mkIf cfg.enable {

    environment.systemPackages = [cfg.package];

    users.users = singleton {
      name = "apache-flume";
      uid = config.ids.uids.apache-flume;
      description = "Apache flume daemon user";
      home = cfg.homeDir;
    };

    systemd.services.apache-flume = {
      description = "Apache flume Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = ''
          ${cfg.package}/bin/flume-ng agent --classpath ${coreSiteXml} --conf ${flumeEnvSh} --conf-file ${flumeConf} --name agent
        '';
        User = "apache-flume";
        SuccessExitStatus = "0 143";
      };
    };

  };
}
