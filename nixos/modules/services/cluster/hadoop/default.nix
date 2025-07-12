{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.services.hadoop;
  opt = options.services.hadoop;
in
{
  imports = [
    ./yarn.nix
    ./hdfs.nix
    ./hbase.nix
  ];

  options.services.hadoop = {
    coreSite = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.anything;
      example = lib.literalExpression ''
        {
          "fs.defaultFS" = "hdfs://localhost";
        }
      '';
      description = ''
        Hadoop core-site.xml definition
        <https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/core-default.xml>
      '';
    };
    coreSiteInternal = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.anything;
      internal = true;
      description = ''
        Internal option to add configs to core-site.xml based on module options
      '';
    };

    hdfsSiteDefault = lib.mkOption {
      default = {
        "dfs.namenode.rpc-bind-host" = "0.0.0.0";
        "dfs.namenode.http-address" = "0.0.0.0:9870";
        "dfs.namenode.servicerpc-bind-host" = "0.0.0.0";
        "dfs.namenode.http-bind-host" = "0.0.0.0";
      };
      type = lib.types.attrsOf lib.types.anything;
      description = ''
        Default options for hdfs-site.xml
      '';
    };
    hdfsSite = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.anything;
      example = lib.literalExpression ''
        {
          "dfs.nameservices" = "namenode1";
        }
      '';
      description = ''
        Additional options and overrides for hdfs-site.xml
        <https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml>
      '';
    };
    hdfsSiteInternal = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.anything;
      internal = true;
      description = ''
        Internal option to add configs to hdfs-site.xml based on module options
      '';
    };

    mapredSiteDefault = lib.mkOption {
      default = {
        "mapreduce.framework.name" = "yarn";
        "yarn.app.mapreduce.am.env" = "HADOOP_MAPRED_HOME=${cfg.package}";
        "mapreduce.map.env" = "HADOOP_MAPRED_HOME=${cfg.package}";
        "mapreduce.reduce.env" = "HADOOP_MAPRED_HOME=${cfg.package}";
      };
      defaultText = lib.literalExpression ''
        {
          "mapreduce.framework.name" = "yarn";
          "yarn.app.mapreduce.am.env" = "HADOOP_MAPRED_HOME=''${config.${opt.package}}";
          "mapreduce.map.env" = "HADOOP_MAPRED_HOME=''${config.${opt.package}}";
          "mapreduce.reduce.env" = "HADOOP_MAPRED_HOME=''${config.${opt.package}}";
        }
      '';
      type = lib.types.attrsOf lib.types.anything;
      description = ''
        Default options for mapred-site.xml
      '';
    };
    mapredSite = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.anything;
      example = lib.literalExpression ''
        {
          "mapreduce.map.java.opts" = "-Xmx900m -XX:+UseParallelGC";
        }
      '';
      description = ''
        Additional options and overrides for mapred-site.xml
        <https://hadoop.apache.org/docs/current/hadoop-mapreduce-client/hadoop-mapreduce-client-core/mapred-default.xml>
      '';
    };

    yarnSiteDefault = lib.mkOption {
      default = {
        "yarn.nodemanager.admin-env" = "PATH=$PATH";
        "yarn.nodemanager.aux-services" = "mapreduce_shuffle";
        "yarn.nodemanager.aux-services.mapreduce_shuffle.class" = "org.apache.hadoop.mapred.ShuffleHandler";
        "yarn.nodemanager.bind-host" = "0.0.0.0";
        "yarn.nodemanager.container-executor.class" =
          "org.apache.hadoop.yarn.server.nodemanager.LinuxContainerExecutor";
        "yarn.nodemanager.env-whitelist" =
          "JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PREPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_HOME,LANG,TZ";
        "yarn.nodemanager.linux-container-executor.group" = "hadoop";
        "yarn.nodemanager.linux-container-executor.path" =
          "/run/wrappers/yarn-nodemanager/bin/container-executor";
        "yarn.nodemanager.log-dirs" = "/var/log/hadoop/yarn/nodemanager";
        "yarn.resourcemanager.bind-host" = "0.0.0.0";
        "yarn.resourcemanager.scheduler.class" =
          "org.apache.hadoop.yarn.server.resourcemanager.scheduler.fair.FairScheduler";
      };
      type = lib.types.attrsOf lib.types.anything;
      description = ''
        Default options for yarn-site.xml
      '';
    };
    yarnSite = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.anything;
      example = lib.literalExpression ''
        {
          "yarn.resourcemanager.hostname" = "''${config.networking.hostName}";
        }
      '';
      description = ''
        Additional options and overrides for yarn-site.xml
        <https://hadoop.apache.org/docs/current/hadoop-yarn/hadoop-yarn-common/yarn-default.xml>
      '';
    };
    yarnSiteInternal = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.anything;
      internal = true;
      description = ''
        Internal option to add configs to yarn-site.xml based on module options
      '';
    };

    httpfsSite = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.anything;
      example = lib.literalExpression ''
        {
          "hadoop.http.max.threads" = 500;
        }
      '';
      description = ''
        Hadoop httpfs-site.xml definition
        <https://hadoop.apache.org/docs/current/hadoop-hdfs-httpfs/httpfs-default.html>
      '';
    };

    log4jProperties = lib.mkOption {
      default = "${cfg.package}/etc/hadoop/log4j.properties";
      defaultText = lib.literalExpression ''
        "''${config.${opt.package}}/etc/hadoop/log4j.properties"
      '';
      type = lib.types.path;
      example = lib.literalExpression ''
        "''${pkgs.hadoop}/etc/hadoop/log4j.properties";
      '';
      description = "log4j.properties file added to HADOOP_CONF_DIR";
    };

    containerExecutorCfg = lib.mkOption {
      default = {
        # must be the same as yarn.nodemanager.linux-container-executor.group in yarnSite
        "yarn.nodemanager.linux-container-executor.group" = "hadoop";
        "min.user.id" = 1000;
        "feature.terminal.enabled" = 1;
        "feature.mount-cgroup.enabled" = 1;
      };
      type = lib.types.attrsOf lib.types.anything;
      example = lib.literalExpression ''
        options.services.hadoop.containerExecutorCfg.default // {
          "feature.terminal.enabled" = 0;
        }
      '';
      description = ''
        Yarn container-executor.cfg definition
        <https://hadoop.apache.org/docs/r2.7.2/hadoop-yarn/hadoop-yarn-site/SecureContainer.html>
      '';
    };

    extraConfDirs = lib.mkOption {
      default = [ ];
      type = lib.types.listOf lib.types.path;
      example = lib.literalExpression ''
        [
          ./extraHDFSConfs
          ./extraYARNConfs
        ]
      '';
      description = "Directories containing additional config files to be added to HADOOP_CONF_DIR";
    };

    gatewayRole.enable = lib.mkEnableOption "gateway role for deploying hadoop configs";

    package = lib.mkPackageOption pkgs "hadoop" { };
  };

  config = lib.mkIf cfg.gatewayRole.enable {
    users.groups.hadoop = {
      gid = config.ids.gids.hadoop;
    };
    environment = {
      systemPackages = [ cfg.package ];
      etc."hadoop-conf".source =
        let
          hadoopConf = "${import ./conf.nix { inherit cfg pkgs lib; }}/";
        in
        "${hadoopConf}";
      variables.HADOOP_CONF_DIR = "/etc/hadoop-conf/";
    };
  };
}
