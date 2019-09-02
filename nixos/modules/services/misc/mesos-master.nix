{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.mesos.master;

in {

  options.services.mesos = {

    master = {
      enable = mkOption {
        description = "Whether to enable the Mesos Master.";
        default = false;
        type = types.bool;
      };

      ip = mkOption {
        description = "IP address to listen on.";
        default = "0.0.0.0";
        type = types.str;
      };

      port = mkOption {
        description = "Mesos Master port";
        default = 5050;
        type = types.int;
      };

      advertiseIp = mkOption {
        description = "IP address advertised to reach this master.";
        default = null;
        type = types.nullOr types.str;
      };

      advertisePort = mkOption {
        description = "Port advertised to reach this Mesos master.";
        default = null;
        type = types.nullOr types.int;
      };

      zk = mkOption {
        description = ''
          ZooKeeper URL (used for leader election amongst masters).
          May be one of:
            zk://host1:port1,host2:port2,.../mesos
            zk://username:password@host1:port1,host2:port2,.../mesos
        '';
        type = types.str;
      };

      workDir = mkOption {
        description = "The Mesos work directory.";
        default = "/var/lib/mesos/master";
        type = types.str;
      };

      extraCmdLineOptions = mkOption {
        description = ''
          Extra command line options for Mesos Master.

          See https://mesos.apache.org/documentation/latest/configuration/
        '';
        default = [ "" ];
        type = types.listOf types.str;
        example = [ "--credentials=VALUE" ];
      };

      quorum = mkOption {
        description = ''
          The size of the quorum of replicas when using 'replicated_log' based
          registry. It is imperative to set this value to be a majority of
          masters i.e., quorum > (number of masters)/2.

          If 0 will fall back to --registry=in_memory.
        '';
        default = 0;
        type = types.int;
      };

      logLevel = mkOption {
        description = ''
          The logging level used. Possible values:
            'INFO', 'WARNING', 'ERROR'
        '';
        default = "INFO";
        type = types.str;
      };

    };


  };


  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d '${cfg.workDir}' 0700 - - - -"
    ];
    systemd.services.mesos-master = {
      description = "Mesos Master";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = ''
          ${pkgs.mesos}/bin/mesos-master \
            --ip=${cfg.ip} \
            --port=${toString cfg.port} \
            ${optionalString (cfg.advertiseIp != null) "--advertise_ip=${cfg.advertiseIp}"} \
            ${optionalString (cfg.advertisePort  != null) "--advertise_port=${toString cfg.advertisePort}"} \
            ${if cfg.quorum == 0
              then "--registry=in_memory"
              else "--zk=${cfg.zk} --registry=replicated_log --quorum=${toString cfg.quorum}"} \
            --work_dir=${cfg.workDir} \
            --logging_level=${cfg.logLevel} \
            ${toString cfg.extraCmdLineOptions}
        '';
        Restart = "on-failure";
      };
    };
  };

}

