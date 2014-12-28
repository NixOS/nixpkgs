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

in {

  options.services.mesos = {
    slave = {
      enable = mkOption {
        description = "Whether to enable the Mesos Slave.";
        default = false;
        type = types.uniq types.bool;
      };

      port = mkOption {
        description = "Mesos Slave port";
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
        type = types.listOf types.string;
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
      after = [ "network-interfaces.target" ];
      environment.MESOS_CONTAINERIZERS = "docker,mesos";
      serviceConfig = {
        ExecStart = ''
          ${pkgs.mesos}/bin/mesos-slave \
            --port=${toString cfg.port} \
            --master=${cfg.master} \
            ${optionalString cfg.withHadoop "--hadoop-home=${pkgs.hadoop}"} \
            ${attribsArg} \
            --work_dir=${cfg.workDir} \
            --logging_level=${cfg.logLevel} \
            --docker=${pkgs.docker}/libexec/docker/docker \
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
