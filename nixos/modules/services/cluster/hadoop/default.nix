{ config, lib, pkgs, ...}:
let
  cfg = config.services.hadoop;
in
with lib;
{
  imports = [ ./yarn.nix ./hdfs.nix ];

  options.services.hadoop = {
    coreSite = mkOption {
      default = {};
      type = types.attrsOf types.anything;
      example = literalExpression ''
        {
          "fs.defaultFS" = "hdfs://localhost";
        }
      '';
      description = "Hadoop core-site.xml definition";
    };

    hdfsSite = mkOption {
      default = {
        "dfs.namenode.rpc-bind-host" = "0.0.0.0";
      };
      type = types.attrsOf types.anything;
      example = literalExpression ''
        {
          "dfs.nameservices" = "namenode1";
        }
      '';
      description = "Hadoop hdfs-site.xml definition";
    };

    mapredSite = mkOption {
      default = {
        "mapreduce.framework.name" = "yarn";
        "yarn.app.mapreduce.am.env" = "HADOOP_MAPRED_HOME=${cfg.package}/lib/${cfg.package.untarDir}";
        "mapreduce.map.env" = "HADOOP_MAPRED_HOME=${cfg.package}/lib/${cfg.package.untarDir}";
        "mapreduce.reduce.env" = "HADOOP_MAPRED_HOME=${cfg.package}/lib/${cfg.package.untarDir}";
      };
      type = types.attrsOf types.anything;
      example = literalExpression ''
        options.services.hadoop.mapredSite.default // {
          "mapreduce.map.java.opts" = "-Xmx900m -XX:+UseParallelGC";
        }
      '';
      description = "Hadoop mapred-site.xml definition";
    };

    yarnSite = mkOption {
      default = {
        "yarn.nodemanager.admin-env" = "PATH=$PATH";
        "yarn.nodemanager.aux-services" = "mapreduce_shuffle";
        "yarn.nodemanager.aux-services.mapreduce_shuffle.class" = "org.apache.hadoop.mapred.ShuffleHandler";
        "yarn.nodemanager.bind-host" = "0.0.0.0";
        "yarn.nodemanager.container-executor.class" = "org.apache.hadoop.yarn.server.nodemanager.LinuxContainerExecutor";
        "yarn.nodemanager.env-whitelist" = "JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PREPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_HOME,LANG,TZ";
        "yarn.nodemanager.linux-container-executor.group" = "hadoop";
        "yarn.nodemanager.linux-container-executor.path" = "/run/wrappers/yarn-nodemanager/bin/container-executor";
        "yarn.nodemanager.log-dirs" = "/var/log/hadoop/yarn/nodemanager";
        "yarn.resourcemanager.bind-host" = "0.0.0.0";
        "yarn.resourcemanager.scheduler.class" = "org.apache.hadoop.yarn.server.resourcemanager.scheduler.fifo.FifoScheduler";
      };
      type = types.attrsOf types.anything;
      example = literalExpression ''
        options.services.hadoop.yarnSite.default // {
          "yarn.resourcemanager.hostname" = "''${config.networking.hostName}";
        }
      '';
      description = "Hadoop yarn-site.xml definition";
    };

    log4jProperties = mkOption {
      default = "${cfg.package}/lib/${cfg.package.untarDir}/etc/hadoop/log4j.properties";
      type = types.path;
      example = literalExpression ''
        "''${pkgs.hadoop}/lib/''${pkgs.hadoop.untarDir}/etc/hadoop/log4j.properties";
      '';
      description = "log4j.properties file added to HADOOP_CONF_DIR";
    };

    containerExecutorCfg = mkOption {
      default = {
        # must be the same as yarn.nodemanager.linux-container-executor.group in yarnSite
        "yarn.nodemanager.linux-container-executor.group"="hadoop";
        "min.user.id"=1000;
        "feature.terminal.enabled"=1;
      };
      type = types.attrsOf types.anything;
      example = literalExpression ''
        options.services.hadoop.containerExecutorCfg.default // {
          "feature.terminal.enabled" = 0;
        }
      '';
      description = "Yarn container-executor.cfg definition";
    };

    extraConfDirs = mkOption {
      default = [];
      type = types.listOf types.path;
      example = literalExpression ''
        [
          ./extraHDFSConfs
          ./extraYARNConfs
        ]
      '';
      description = "Directories containing additional config files to be added to HADOOP_CONF_DIR";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.hadoop;
      defaultText = literalExpression "pkgs.hadoop";
      description = "";
    };
  };


  config = mkMerge [
    (mkIf (builtins.hasAttr "yarn" config.users.users ||
           builtins.hasAttr "hdfs" config.users.users) {
      users.groups.hadoop = {
        gid = config.ids.gids.hadoop;
      };
      environment = {
        systemPackages = [ cfg.package ];
        etc."hadoop-conf".source = let
          hadoopConf = "${import ./conf.nix { inherit cfg pkgs lib; }}/";
        in "${hadoopConf}";
      };
    })

  ];
}
