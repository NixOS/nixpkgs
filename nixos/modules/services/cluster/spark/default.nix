{config, pkgs, lib, ...}:
let
  cfg = config.services.spark;
in
{
  options = {
    services.spark = {
      master = {
        enable = lib.mkEnableOption "Spark master service";
        bind = lib.mkOption {
          type = lib.types.str;
          description = "Address the spark master binds to.";
          default = "127.0.0.1";
          example = "0.0.0.0";
        };
        restartIfChanged  = lib.mkOption {
          type = lib.types.bool;
          description = ''
            Automatically restart master service on config change.
            This can be set to false to defer restarts on clusters running critical applications.
            Please consider the security implications of inadvertently running an older version,
            and the possibility of unexpected behavior caused by inconsistent versions across a cluster when disabling this option.
          '';
          default = true;
        };
        extraEnvironment = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          description = "Extra environment variables to pass to spark master. See spark-standalone documentation.";
          default = {};
          example = {
            SPARK_MASTER_WEBUI_PORT = 8181;
            SPARK_MASTER_OPTS = "-Dspark.deploy.defaultCores=5";
          };
        };
      };
      worker = {
        enable = lib.mkEnableOption "Spark worker service";
        workDir = lib.mkOption {
          type = lib.types.path;
          description = "Spark worker work dir.";
          default = "/var/lib/spark";
        };
        master = lib.mkOption {
          type = lib.types.str;
          description = "Address of the spark master.";
          default = "127.0.0.1:7077";
        };
        restartIfChanged  = lib.mkOption {
          type = lib.types.bool;
          description = ''
            Automatically restart worker service on config change.
            This can be set to false to defer restarts on clusters running critical applications.
            Please consider the security implications of inadvertently running an older version,
            and the possibility of unexpected behavior caused by inconsistent versions across a cluster when disabling this option.
          '';
          default = true;
        };
        extraEnvironment = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          description = "Extra environment variables to pass to spark worker.";
          default = {};
          example = {
            SPARK_WORKER_CORES = 5;
            SPARK_WORKER_MEMORY = "2g";
          };
        };
      };
      confDir = lib.mkOption {
        type = lib.types.path;
        description = "Spark configuration directory. Spark will use the configuration files (spark-defaults.conf, spark-env.sh, log4j.properties, etc) from this directory.";
        default = "${cfg.package}/conf";
        defaultText = lib.literalExpression ''"''${package}/conf"'';
      };
      logDir = lib.mkOption {
        type = lib.types.path;
        description = "Spark log directory.";
        default = "/var/log/spark";
      };
      package = lib.mkPackageOption pkgs "spark" {
        example = ''
          spark.overrideAttrs (super: rec {
            pname = "spark";
            version = "2.4.4";

            src = pkgs.fetchzip {
              url    = "mirror://apache/spark/"''${pname}-''${version}/''${pname}-''${version}-bin-without-hadoop.tgz";
              sha256 = "1a9w5k0207fysgpxx6db3a00fs5hdc2ncx99x4ccy2s0v5ndc66g";
            };
          })
        '';
      };
    };
  };
  config = lib.mkIf (cfg.worker.enable || cfg.master.enable) {
    environment.systemPackages = [ cfg.package ];
    systemd = {
      services = {
        spark-master = lib.mkIf cfg.master.enable {
          path = with pkgs; [ procps openssh nettools ];
          description = "spark master service.";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          restartIfChanged = cfg.master.restartIfChanged;
          environment = cfg.master.extraEnvironment // {
            SPARK_MASTER_HOST = cfg.master.bind;
            SPARK_CONF_DIR = cfg.confDir;
            SPARK_LOG_DIR = cfg.logDir;
          };
          serviceConfig = {
            Type = "forking";
            User = "spark";
            Group = "spark";
            WorkingDirectory = "${cfg.package}/";
            ExecStart = "${cfg.package}/sbin/start-master.sh";
            ExecStop  = "${cfg.package}/sbin/stop-master.sh";
            TimeoutSec = 300;
            StartLimitBurst=10;
            Restart = "always";
          };
        };
        spark-worker = lib.mkIf cfg.worker.enable {
          path = with pkgs; [ procps openssh nettools rsync ];
          description = "spark master service.";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          restartIfChanged = cfg.worker.restartIfChanged;
          environment = cfg.worker.extraEnvironment // {
            SPARK_MASTER = cfg.worker.master;
            SPARK_CONF_DIR = cfg.confDir;
            SPARK_LOG_DIR = cfg.logDir;
            SPARK_WORKER_DIR = cfg.worker.workDir;
          };
          serviceConfig = {
            Type = "forking";
            User = "spark";
            WorkingDirectory = "${cfg.package}/";
            ExecStart = "${cfg.package}/sbin/start-worker.sh spark://${cfg.worker.master}";
            ExecStop  = "${cfg.package}/sbin/stop-worker.sh";
            TimeoutSec = 300;
            StartLimitBurst=10;
            Restart = "always";
          };
        };
      };
      tmpfiles.rules = [
        "d '${cfg.worker.workDir}' - spark spark - -"
        "d '${cfg.logDir}' - spark spark - -"
      ];
    };
    users = {
      users.spark = {
        description = "spark user.";
        group = "spark";
        isSystemUser = true;
      };
      groups.spark = { };
    };
  };
}
