{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.activemq;

  activemqBroker =
    pkgs.runCommand "activemq-broker"
      {
        nativeBuildInputs = [ pkgs.jdk ];
      }
      ''
        mkdir -p $out/lib
        source ${pkgs.activemq}/lib/classpath.env
        export CLASSPATH
        ln -s "${./ActiveMQBroker.java}" ActiveMQBroker.java
        javac -d $out/lib ActiveMQBroker.java
      '';

in
{

  options = {
    services.activemq = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enable the Apache ActiveMQ message broker service.
        '';
      };
      configurationDir = lib.mkOption {
        default = "${pkgs.activemq}/conf";
        defaultText = lib.literalExpression ''"''${pkgs.activemq}/conf"'';
        type = lib.types.str;
        description = ''
          The base directory for ActiveMQ's configuration.
          By default, this directory is searched for a file named activemq.xml,
          which should contain the configuration for the broker service.
        '';
      };
      configurationURI = lib.mkOption {
        type = lib.types.str;
        default = "xbean:activemq.xml";
        description = ''
          The URI that is passed along to the BrokerFactory to
          set up the configuration of the ActiveMQ broker service.
          You should not need to change this. For custom configuration,
          set the `configurationDir` instead, and create
          an activemq.xml configuration file in it.
        '';
      };
      baseDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/activemq";
        description = ''
          The base directory where ActiveMQ stores its persistent data and logs.
          This will be overridden if you set "activemq.base" and "activemq.data"
          in the `javaProperties` option. You can also override
          this in activemq.xml.
        '';
      };
      javaProperties = lib.mkOption {
        type = lib.types.attrs;
        default = { };
        example = lib.literalExpression ''
          {
            "java.net.preferIPv4Stack" = "true";
          }
        '';
        apply =
          attrs:
          {
            "activemq.base" = "${cfg.baseDir}";
            "activemq.data" = "${cfg.baseDir}/data";
            "activemq.conf" = "${cfg.configurationDir}";
            "activemq.home" = "${pkgs.activemq}";
          }
          // attrs;
        description = ''
          Specifies Java properties that are sent to the ActiveMQ
          broker service with the "-D" option. You can set properties
          here to change the behaviour and configuration of the broker.
          All essential properties that are not set here are automatically
          given reasonable defaults.
        '';
      };
      extraJavaOptions = lib.mkOption {
        type = lib.types.separatedString " ";
        default = "";
        example = "-Xmx2G -Xms2G -XX:MaxPermSize=512M";
        description = ''
          Add extra options here that you want to be sent to the
          Java runtime when the broker service is started.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.activemq = {
      description = "ActiveMQ server user";
      group = "activemq";
      uid = config.ids.uids.activemq;
    };

    users.groups.activemq.gid = config.ids.gids.activemq;

    systemd.services.activemq_init = {
      wantedBy = [ "activemq.service" ];
      partOf = [ "activemq.service" ];
      before = [ "activemq.service" ];
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir -p "${cfg.javaProperties."activemq.data"}"
        chown -R activemq "${cfg.javaProperties."activemq.data"}"
      '';
    };

    systemd.services.activemq = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = [ pkgs.jre ];
      serviceConfig.User = "activemq";
      script = ''
        source ${pkgs.activemq}/lib/classpath.env
        export CLASSPATH=${activemqBroker}/lib:${cfg.configurationDir}:$CLASSPATH
        exec java \
          ${
            lib.concatStringsSep " \\\n" (
              lib.mapAttrsToList (name: value: "-D${name}=${value}") cfg.javaProperties
            )
          } \
          ${cfg.extraJavaOptions} ActiveMQBroker "${cfg.configurationURI}"
      '';
    };

  };

}
