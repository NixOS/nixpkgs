{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.aurora.scheduler;

in {

  ###### interface

  options.services.aurora.scheduler = {
    enable = mkOption {
      type = types.uniq types.bool;
      default = false;
      description = ''
	Whether to enable the aurora scheduler.
      '';
    };

    clusterName = mkOption {
      type = types.str;
      description = ''
	Name to identify the cluster being served.
      '';
    };

    backupDir = mkOption {
      type = types.str;
      default = "/var/lib/aurora/backups";
      description = ''
	Directory to store backups under.
      '';
    };

    nativeLogFilePath = mkOption {
      type = types.str;
      default = "/var/db/aurora";
      description = ''
	Path to a file to store the native log data in.
      '';
    };

    mesosMasterAddress = mkOption {
      type = types.str;
      default = "zk://${concatStringsSep "," cfg.zkEndpoints}/mesos";
      example = "zk://1.2.3.4:2181,2.3.4.5:2181,3.4.5.6:2181/mesos";
      description = ''
	Address for the mesos master, can be a socket address or zookeeper path.
      '';
    };

    zkEndpoints = mkOption {
      type = types.listOf types.str;
      default = [ "localhost:2181" ];
      example = [ "1.2.3.4:2181" "2.3.4.5:2181" "3.4.5.6:2181" ];
      description = ''
	Endpoint specification for the ZooKeeper servers.
      '';
    };

    serversetPath = mkOption {
      type = types.str;
      default = "/aurora/scheduler";
      description = ''
	ZooKeeper ServerSet path to register at.
      '';
    };

    extraCmdLineOptions = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "-enable_job_creation true" "-enable_job_updates true" "-executor_user root" ];
      description = ''
	Extra command line options to pass to `aurora-scheduler`.
      '';
    };

    environment = mkOption {
      default = { };
      type = types.attrs;
      example = { JAVA_OPTS = "-Xmx512m"; MESOSPHERE_HTTP_CREDENTIALS = "username:password"; };
      description = ''
	Environment variables passed to Marathon.
      '';
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    systemd.services.aurora-scheduler = {
      description = "Apache Aurora Scheduler";
      environment = cfg.environment;
      wantedBy = [ "multi-user.target" ];
      after = [ "network-interfaces.target" "zookeeper.service" "mesos-master.service" "mesos-slave.service" ];

      preStart = ''
        mkdir -p ${cfg.nativeLogFilePath}
	${pkgs.mesos}/bin/mesos-log initialize --path="${cfg.nativeLogFilePath}" || true
      '';

      serviceConfig = {
        ExecStart = ''${pkgs.aurora}/bin/aurora-scheduler \
	    -cluster_name ${cfg.clusterName} \
	    -backup_dir ${cfg.backupDir} \
	    -mesos_master_address ${cfg.mesosMasterAddress} \
	    -serverset_path ${cfg.serversetPath} \
	    -thermos_executor_path ${pkgs.aurora}/bin/thermos-executor \
	    -gc_executor_path ${pkgs.aurora}/bin/gc-executor \
	    -zk_endpoints ${concatStringsSep "," cfg.zkEndpoints} \
	    -native_log_file_path ${cfg.nativeLogFilePath} \
	    -cron_timezone ${config.time.timeZone} \
	    ${concatStringsSep " " cfg.extraCmdLineOptions}
	  '';
        Restart = "always";
        RestartSec = "2";
      };
    };
  };
}
