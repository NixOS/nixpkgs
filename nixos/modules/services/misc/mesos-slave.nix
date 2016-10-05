{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.mesos.slave;

  mkAttributes =
    attrs: concatStringsSep ";" (mapAttrsToList
                                   (k: v: "${k}:${v}")
                                   (filterAttrs (k: v: v != null) attrs));
  attribsArg = optionalString (cfg.attributes != {})
                              "--attributes=${mkAttributes cfg.attributes}";

  containerizers = [ "mesos" ] ++ (optional cfg.withDocker "docker");

in {

  options.services.mesos = {
    slave = {
      enable = mkOption {
        description = "Whether to enable the Mesos Slave.";
        default = false;
        type = types.bool;
      };

      ip = mkOption {
        description = "IP address to listen on.";
        default = "0.0.0.0";
        type = types.string;
      };

      port = mkOption {
        description = "Port to listen on.";
        default = 5051;
        type = types.int;
      };

      master = mkOption {
        description = ''
          May be one of:
            zk://host1:port1,host2:port2,.../path
            zk://username:password@host1:port1,host2:port2,.../path
        '';
        type = types.str;
      };

      withHadoop = mkOption {
        description = "Add the HADOOP_HOME to the slave.";
        default = false;
        type = types.bool;
      };

      withDocker = mkOption {
        description = "Enable the docker containerizer.";
        default = config.virtualisation.docker.enable;
        type = types.bool;
      };

      workDir = mkOption {
        description = "The Mesos work directory.";
        default = "/var/lib/mesos/slave";
        type = types.str;
      };

      extraCmdLineOptions = mkOption {
        description = ''
          Extra command line options for Mesos Slave.

          See https://mesos.apache.org/documentation/latest/configuration/
        '';
        default = [ "" ];
        type = types.listOf types.str;
        example = [ "--gc_delay=3days" ];
      };

      logLevel = mkOption {
        description = ''
          The logging level used. Possible values:
            'INFO', 'WARNING', 'ERROR'
        '';
        default = "INFO";
        type = types.str;
      };

      attributes = mkOption {
        description = ''
          Machine attributes for the slave instance.

          Use caution when changing this; you may need to manually reset slave
          metadata before the slave can re-register.
        '';
        default = {};
        type = types.attrsOf types.str;
        example = { rack = "aa";
                    host = "aabc123";
                    os = "nixos"; };
      };
    };

  };


  config = mkIf cfg.enable {
    systemd.services.mesos-slave = {
      description = "Mesos Slave";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment.MESOS_CONTAINERIZERS = concatStringsSep "," containerizers;
      serviceConfig = {
        ExecStart = ''
          ${pkgs.mesos}/bin/mesos-slave \
            --ip=${cfg.ip} \
            --port=${toString cfg.port} \
            --master=${cfg.master} \
            --work_dir=${cfg.workDir} \
            --logging_level=${cfg.logLevel} \
            ${attribsArg} \
            ${optionalString cfg.withHadoop "--hadoop-home=${pkgs.hadoop}"} \
            ${optionalString cfg.withDocker "--docker=${pkgs.docker}/libexec/docker/docker"} \
            ${toString cfg.extraCmdLineOptions}
        '';
        PermissionsStartOnly = true;
      };
      preStart = ''
        mkdir -m 0700 -p ${cfg.workDir}
      '';
    };
  };

}
