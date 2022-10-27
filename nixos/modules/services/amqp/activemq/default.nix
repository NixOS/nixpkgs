{ config, lib, pkgs, ... }:

with pkgs;
with lib;

let

  cfg = config.services.activemq;

  activemqBroker = stdenv.mkDerivation {
    name = "activemq-broker";
    phases = [ "installPhase" ];
    buildInputs = [ jdk ];
    installPhase = ''
      mkdir -p $out/lib
      source ${activemq}/lib/classpath.env
      export CLASSPATH
      ln -s "${./ActiveMQBroker.java}" ActiveMQBroker.java
      javac -d $out/lib ActiveMQBroker.java
    '';
  };

in {

  options = {
    services.activemq = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Enable the Apache ActiveMQ message broker service.
        '';
      };
      configurationDir = mkOption {
        default = "${activemq}/conf";
        defaultText = literalExpression ''"''${pkgs.activemq}/conf"'';
        type = types.str;
        description = lib.mdDoc ''
          The base directory for ActiveMQ's configuration.
          By default, this directory is searched for a file named activemq.xml,
          which should contain the configuration for the broker service.
        '';
      };
      configurationURI = mkOption {
        type = types.str;
        default = "xbean:activemq.xml";
        description = lib.mdDoc ''
          The URI that is passed along to the BrokerFactory to
          set up the configuration of the ActiveMQ broker service.
          You should not need to change this. For custom configuration,
          set the `configurationDir` instead, and create
          an activemq.xml configuration file in it.
        '';
      };
      baseDir = mkOption {
        type = types.str;
        default = "/var/activemq";
        description = lib.mdDoc ''
          The base directory where ActiveMQ stores its persistent data and logs.
          This will be overridden if you set "activemq.base" and "activemq.data"
          in the `javaProperties` option. You can also override
          this in activemq.xml.
        '';
      };
      javaProperties = mkOption {
        type = types.attrs;
        default = { };
        example = literalExpression ''
          {
            "java.net.preferIPv4Stack" = "true";
          }
        '';
        apply = attrs: {
          "activemq.base" = "${cfg.baseDir}";
          "activemq.data" = "${cfg.baseDir}/data";
          "activemq.conf" = "${cfg.configurationDir}";
          "activemq.home" = "${activemq}";
        } // attrs;
        description = lib.mdDoc ''
          Specifies Java properties that are sent to the ActiveMQ
          broker service with the "-D" option. You can set properties
          here to change the behaviour and configuration of the broker.
          All essential properties that are not set here are automatically
          given reasonable defaults.
        '';
      };
      extraJavaOptions = mkOption {
        type = types.separatedString " ";
        default = "";
        example = "-Xmx2G -Xms2G -XX:MaxPermSize=512M";
        description = lib.mdDoc ''
          Add extra options here that you want to be sent to the
          Java runtime when the broker service is started.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
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
      path = [ jre ];
      serviceConfig.User = "activemq";
      script = ''
        source ${activemq}/lib/classpath.env
        export CLASSPATH=${activemqBroker}/lib:${cfg.configurationDir}:$CLASSPATH
        exec java \
          ${concatStringsSep " \\\n" (mapAttrsToList (name: value: "-D${name}=${value}") cfg.javaProperties)} \
          ${cfg.extraJavaOptions} ActiveMQBroker "${cfg.configurationURI}"
      '';
    };

  };

}
