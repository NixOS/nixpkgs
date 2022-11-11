{ config, lib, pkgs, ...}:

with lib;
let
  cfg = config.services.hadoop;
  hadoopConf = "${import ./conf.nix { inherit cfg pkgs lib; }}/";
  mkIfNotNull = x: mkIf (x != null) x;
in
{
  options.services.hadoop = {

    gatewayRole.enableHbaseCli = mkEnableOption (lib.mdDoc "HBase CLI tools");

    hbaseSiteDefault = mkOption {
      default = {
        "hbase.regionserver.ipc.address" = "0.0.0.0";
        "hbase.master.ipc.address" = "0.0.0.0";
        "hbase.master.info.bindAddress" = "0.0.0.0";
        "hbase.regionserver.info.bindAddress" = "0.0.0.0";

        "hbase.cluster.distributed" = "true";
      };
      type = types.attrsOf types.anything;
      description = lib.mdDoc ''
        Default options for hbase-site.xml
      '';
    };
    hbaseSite = mkOption {
      default = {};
      type = with types; attrsOf anything;
      example = literalExpression ''
      '';
      description = lib.mdDoc ''
        Additional options and overrides for hbase-site.xml
        <https://github.com/apache/hbase/blob/rel/2.4.11/hbase-common/src/main/resources/hbase-default.xml>
      '';
    };
    hbaseSiteInternal = mkOption {
      default = {};
      type = with types; attrsOf anything;
      internal = true;
      description = lib.mdDoc ''
        Internal option to add configs to hbase-site.xml based on module options
      '';
    };

    hbase = {

      package = mkOption {
        type = types.package;
        default = pkgs.hbase;
        defaultText = literalExpression "pkgs.hbase";
        description = lib.mdDoc "HBase package";
      };

      rootdir = mkOption {
        description = lib.mdDoc ''
          This option will set "hbase.rootdir" in hbase-site.xml and determine
          the directory shared by region servers and into which HBase persists.
          The URL should be 'fully-qualified' to include the filesystem scheme.
          If a core-site.xml is provided, the FS scheme defaults to the value
          of "fs.defaultFS".

          Filesystems other than HDFS (like S3, QFS, Swift) are also supported.
        '';
        type = types.str;
        example = "hdfs://nameservice1/hbase";
        default = "/hbase";
      };
      zookeeperQuorum = mkOption {
        description = lib.mdDoc ''
          This option will set "hbase.zookeeper.quorum" in hbase-site.xml.
          Comma separated list of servers in the ZooKeeper ensemble.
        '';
        type = with types; nullOr commas;
        example = "zk1.internal,zk2.internal,zk3.internal";
        default = null;
      };
      master = {
        enable = mkEnableOption (lib.mdDoc "HBase Master");
        initHDFS = mkEnableOption (lib.mdDoc "initialization of the hbase directory on HDFS");

        openFirewall = mkOption {
          type = types.bool;
          default = false;
          description = lib.mdDoc ''
            Open firewall ports for HBase master.
          '';
        };
      };
      regionServer = {
        enable = mkEnableOption (lib.mdDoc "HBase RegionServer");

        overrideHosts = mkOption {
          type = types.bool;
          default = true;
          description = lib.mdDoc ''
            Remove /etc/hosts entries for "127.0.0.2" and "::1" defined in nixos/modules/config/networking.nix
            Regionservers must be able to resolve their hostnames to their IP addresses, through PTR records
            or /etc/hosts entries.

          '';
        };

        openFirewall = mkOption {
          type = types.bool;
          default = false;
          description = lib.mdDoc ''
            Open firewall ports for HBase master.
          '';
        };
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.hbase.master.enable {
      services.hadoop.gatewayRole = {
        enable = true;
        enableHbaseCli = mkDefault true;
      };

      systemd.services.hbase-master = {
        description = "HBase master";
        wantedBy = [ "multi-user.target" ];

        preStart = mkIf cfg.hbase.master.initHDFS ''
          HADOOP_USER_NAME=hdfs ${cfg.package}/bin/hdfs --config ${hadoopConf} dfsadmin -safemode wait
          HADOOP_USER_NAME=hdfs ${cfg.package}/bin/hdfs --config ${hadoopConf} dfs -mkdir -p ${cfg.hbase.rootdir}
          HADOOP_USER_NAME=hdfs ${cfg.package}/bin/hdfs --config ${hadoopConf} dfs -chown hbase ${cfg.hbase.rootdir}
        '';

        serviceConfig = {
          User = "hbase";
          SyslogIdentifier = "hbase-master";
          ExecStart = "${cfg.hbase.package}/bin/hbase --config ${hadoopConf} " +
                      "master start";
          Restart = "always";
        };
      };

      services.hadoop.hbaseSiteInternal."hbase.rootdir" = cfg.hbase.rootdir;

      networking.firewall.allowedTCPPorts = (mkIf cfg.hbase.master.openFirewall [
        16000 16010
      ]);

    })

    (mkIf cfg.hbase.regionServer.enable {
      services.hadoop.gatewayRole = {
        enable = true;
        enableHbaseCli = mkDefault true;
      };

      systemd.services.hbase-regionserver = {
        description = "HBase RegionServer";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = "hbase";
          SyslogIdentifier = "hbase-regionserver";
          ExecStart = "${cfg.hbase.package}/bin/hbase --config /etc/hadoop-conf/ " +
                      "regionserver start";
          Restart = "always";
        };
      };

      services.hadoop.hbaseSiteInternal."hbase.rootdir" = cfg.hbase.rootdir;

      networking = {
        firewall.allowedTCPPorts = (mkIf cfg.hbase.regionServer.openFirewall [
          16020 16030
        ]);
        hosts = mkIf cfg.hbase.regionServer.overrideHosts {
          "127.0.0.2" = mkForce [ ];
          "::1" = mkForce [ ];
        };
      };
    })

    (mkIf cfg.gatewayRole.enable {

      environment.systemPackages = mkIf cfg.gatewayRole.enableHbaseCli [ cfg.hbase.package ];

      services.hadoop.hbaseSiteInternal = with cfg.hbase; {
        "hbase.zookeeper.quorum" = mkIfNotNull zookeeperQuorum;
      };

      users.users.hbase = {
        description = "Hadoop HBase user";
        group = "hadoop";
        isSystemUser = true;
      };
    })
  ];
}
