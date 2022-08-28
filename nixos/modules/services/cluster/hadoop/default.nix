{ config, lib, options, pkgs, ...}:
let
  cfg = config.services.hadoop;
  opt = options.services.hadoop;
in
with lib;
{
  imports = [ ./yarn.nix ./hdfs.nix ./hbase.nix ];

  options.services.hadoop = {
    coreSite = mkOption {
      default = {};
      type = types.attrsOf types.anything;
      example = literalExpression ''
        {
          "fs.defaultFS" = "hdfs://localhost";
        }
      '';
      description = lib.mdDoc ''
        Hadoop core-site.xml definition
        <https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/core-default.xml>
      '';
    };
    coreSiteInternal = mkOption {
      default = {};
      type = types.attrsOf types.anything;
      internal = true;
      description = ''
        Internal option to add configs to core-site.xml based on module options
      '';
    };

    hdfsSiteDefault = mkOption {
      default = {
        "dfs.namenode.rpc-bind-host" = "0.0.0.0";
        "dfs.namenode.http-address" = "0.0.0.0:9870";
        "dfs.namenode.servicerpc-bind-host" = "0.0.0.0";
        "dfs.namenode.http-bind-host" = "0.0.0.0";
      };
      type = types.attrsOf types.anything;
      description = lib.mdDoc ''
        Default options for hdfs-site.xml
      '';
    };
    hdfsSite = mkOption {
      default = {};
      type = types.attrsOf types.anything;
      example = literalExpression ''
        {
          "dfs.nameservices" = "namenode1";
        }
      '';
      description = lib.mdDoc ''
        Additional options and overrides for hdfs-site.xml
        <https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml>
      '';
    };
    hdfsSiteInternal = mkOption {
      default = {};
      type = types.attrsOf types.anything;
      internal = true;
      description = ''
        Internal option to add configs to hdfs-site.xml based on module options
      '';
    };

    mapredSiteDefault = mkOption {
      default = {
        "mapreduce.framework.name" = "yarn";
        "yarn.app.mapreduce.am.env" = "HADOOP_MAPRED_HOME=${cfg.package}/lib/${cfg.package.untarDir}";
        "mapreduce.map.env" = "HADOOP_MAPRED_HOME=${cfg.package}/lib/${cfg.package.untarDir}";
        "mapreduce.reduce.env" = "HADOOP_MAPRED_HOME=${cfg.package}/lib/${cfg.package.untarDir}";
      };
      defaultText = literalExpression ''
        {
          "mapreduce.framework.name" = "yarn";
          "yarn.app.mapreduce.am.env" = "HADOOP_MAPRED_HOME=''${config.${opt.package}}/lib/''${config.${opt.package}.untarDir}";
          "mapreduce.map.env" = "HADOOP_MAPRED_HOME=''${config.${opt.package}}/lib/''${config.${opt.package}.untarDir}";
          "mapreduce.reduce.env" = "HADOOP_MAPRED_HOME=''${config.${opt.package}}/lib/''${config.${opt.package}.untarDir}";
        }
      '';
      type = types.attrsOf types.anything;
      description = lib.mdDoc ''
        Default options for mapred-site.xml
      '';
    };
    mapredSite = mkOption {
      default = {};
      type = types.attrsOf types.anything;
      example = literalExpression ''
        {
          "mapreduce.map.java.opts" = "-Xmx900m -XX:+UseParallelGC";
        }
      '';
      description = lib.mdDoc ''
        Additional options and overrides for mapred-site.xml
        <https://hadoop.apache.org/docs/current/hadoop-mapreduce-client/hadoop-mapreduce-client-core/mapred-default.xml>
      '';
    };

    yarnSiteDefault = mkOption {
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
        "yarn.resourcemanager.scheduler.class" = "org.apache.hadoop.yarn.server.resourcemanager.scheduler.fair.FairScheduler";
      };
      type = types.attrsOf types.anything;
      description = lib.mdDoc ''
        Default options for yarn-site.xml
      '';
    };
    yarnSite = mkOption {
      default = {};
      type = types.attrsOf types.anything;
      example = literalExpression ''
        {
          "yarn.resourcemanager.hostname" = "''${config.networking.hostName}";
        }
      '';
      description = lib.mdDoc ''
        Additional options and overrides for yarn-site.xml
        <https://hadoop.apache.org/docs/current/hadoop-yarn/hadoop-yarn-common/yarn-default.xml>
      '';
    };
    yarnSiteInternal = mkOption {
      default = {};
      type = types.attrsOf types.anything;
      internal = true;
      description = ''
        Internal option to add configs to yarn-site.xml based on module options
      '';
    };

    httpfsSite = mkOption {
      default = { };
      type = types.attrsOf types.anything;
      example = literalExpression ''
        {
          "hadoop.http.max.threads" = 500;
        }
      '';
      description = lib.mdDoc ''
        Hadoop httpfs-site.xml definition
        <https://hadoop.apache.org/docs/current/hadoop-hdfs-httpfs/httpfs-default.html>
      '';
    };

    log4jProperties = mkOption {
      default = "${cfg.package}/lib/${cfg.package.untarDir}/etc/hadoop/log4j.properties";
      defaultText = literalExpression ''
        "''${config.${opt.package}}/lib/''${config.${opt.package}.untarDir}/etc/hadoop/log4j.properties"
      '';
      type = types.path;
      example = literalExpression ''
        "''${pkgs.hadoop}/lib/''${pkgs.hadoop.untarDir}/etc/hadoop/log4j.properties";
      '';
      description = lib.mdDoc "log4j.properties file added to HADOOP_CONF_DIR";
    };

    containerExecutorCfg = mkOption {
      default = {
        # must be the same as yarn.nodemanager.linux-container-executor.group in yarnSite
        "yarn.nodemanager.linux-container-executor.group"="hadoop";
        "min.user.id"=1000;
        "feature.terminal.enabled"=1;
        "feature.mount-cgroup.enabled" = 1;
      };
      type = types.attrsOf types.anything;
      example = literalExpression ''
        options.services.hadoop.containerExecutorCfg.default // {
          "feature.terminal.enabled" = 0;
        }
      '';
      description = lib.mdDoc ''
        Yarn container-executor.cfg definition
        <https://hadoop.apache.org/docs/r2.7.2/hadoop-yarn/hadoop-yarn-site/SecureContainer.html>
      '';
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
      description = lib.mdDoc "Directories containing additional config files to be added to HADOOP_CONF_DIR";
    };

    gatewayRole.enable = mkEnableOption (lib.mdDoc "gateway role for deploying hadoop configs");

    package = mkOption {
      type = types.package;
      default = pkgs.hadoop;
      defaultText = literalExpression "pkgs.hadoop";
      description = "";
    };
  };


  config = mkIf cfg.gatewayRole.enable {
    users.groups.hadoop = {
      gid = config.ids.gids.hadoop;
    };
    environment = {
      systemPackages = [ cfg.package ];
      etc."hadoop-conf".source = let
        hadoopConf = "${import ./conf.nix { inherit cfg pkgs lib; }}/";
      in "${hadoopConf}";
      variables.HADOOP_CONF_DIR = "/etc/hadoop-conf/";
    };
  };
}
