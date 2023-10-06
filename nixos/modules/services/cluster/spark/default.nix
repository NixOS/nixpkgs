{config, pkgs, lib, ...}:
let
  cfg = config.services.spark;
in
with lib;
{
  options = {
    services.spark = {
      master = {
        enable = mkEnableOption (lib.mdDoc "Spark master service");
        bind = mkOption {
          type = types.str;
          description = lib.mdDoc "Address the spark master binds to.";
          default = "127.0.0.1";
          example = "0.0.0.0";
        };
        restartIfChanged  = mkOption {
          type = types.bool;
          description = lib.mdDoc ''
            Automatically restart master service on config change.
            This can be set to false to defer restarts on clusters running critical applications.
            Please consider the security implications of inadvertently running an older version,
            and the possibility of unexpected behavior caused by inconsistent versions across a cluster when disabling this option.
          '';
          default = true;
        };
        extraEnvironment = mkOption {
          type = types.attrsOf types.str;
          description = lib.mdDoc "Extra environment variables to pass to spark master. See spark-standalone documentation.";
          default = {};
          example = {
            SPARK_MASTER_WEBUI_PORT = 8181;
            SPARK_MASTER_OPTS = "-Dspark.deploy.defaultCores=5";
          };
        };
      };
      worker = {
        enable = mkEnableOption (lib.mdDoc "Spark worker service");
        workDir = mkOption {
          type = types.path;
          description = lib.mdDoc "Spark worker work dir.";
          default = "/var/lib/spark";
        };
        master = mkOption {
          type = types.str;
          description = lib.mdDoc "Address of the spark master.";
          default = "127.0.0.1:7077";
        };
        restartIfChanged  = mkOption {
          type = types.bool;
          description = lib.mdDoc ''
            Automatically restart worker service on config change.
            This can be set to false to defer restarts on clusters running critical applications.
            Please consider the security implications of inadvertently running an older version,
            and the possibility of unexpected behavior caused by inconsistent versions across a cluster when disabling this option.
          '';
          default = true;
        };
        extraEnvironment = mkOption {
          type = types.attrsOf types.str;
          description = lib.mdDoc "Extra environment variables to pass to spark worker.";
          default = {};
          example = {
            SPARK_WORKER_CORES = 5;
            SPARK_WORKER_MEMORY = "2g";
          };
        };
      };
      confDir = mkOption {
        type = types.path;
        description = lib.mdDoc "Spark configuration directory. Spark will use the configuration files (spark-defaults.conf, spark-env.sh, log4j.properties, etc) from this directory.";
        default = "${cfg.package}/lib/${cfg.package.untarDir}/conf";
        defaultText = literalExpression ''"''${package}/lib/''${package.untarDir}/conf"'';
      };
      logDir = mkOption {
        type = types.path;
        description = lib.mdDoc "Spark log directory.";
        default = "/var/log/spark";
      };
      package = mkOption {
        type = types.package;
        description = lib.mdDoc "Spark package.";
        default = pkgs.spark;
        defaultText = literalExpression "pkgs.spark";
        example = literalExpression ''pkgs.spark.overrideAttrs (super: rec {
          pname = "spark";
          version = "2.4.4";

          src = pkgs.fetchzip {
            url    = "mirror://apache/spark/"''${pname}-''${version}/''${pname}-''${version}-bin-without-hadoop.tgz";
            sha256 = "1a9w5k0207fysgpxx6db3a00fs5hdc2ncx99x4ccy2s0v5ndc66g";
          };
        })'';
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
            WorkingDirectory = "${cfg.package}/lib/${cfg.package.untarDir}";
            ExecStart = "${cfg.package}/lib/${cfg.package.untarDir}/sbin/start-master.sh";
            ExecStop  = "${cfg.package}/lib/${cfg.package.untarDir}/sbin/stop-master.sh";
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
            WorkingDirectory = "${cfg.package}/lib/${cfg.package.untarDir}";
            ExecStart = "${cfg.package}/lib/${cfg.package.untarDir}/sbin/start-worker.sh spark://${cfg.worker.master}";
            ExecStop  = "${cfg.package}/lib/${cfg.package.untarDir}/sbin/stop-worker.sh";
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
