{ config, lib, pkgs, ...}:
let
  cfg = config.services.hadoop;
  hadoopConf = import ./conf.nix { hadoop = cfg; pkgs = pkgs; };
in
with lib;
{
  options.services.hadoop.hdfs = {
    namenode.enabled = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to run the Hadoop YARN NameNode
      '';
    };
    datanode.enabled = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to run the Hadoop YARN DataNode
      '';
    };
  };

  config = mkMerge [
    (mkIf cfg.hdfs.namenode.enabled {
      systemd.services."hdfs-namenode" = {
        description = "Hadoop HDFS NameNode";
        wantedBy = [ "multi-user.target" ];

        environment = {
          HADOOP_HOME = "${cfg.package}";
        };

        preStart = ''
          ${cfg.package}/bin/hdfs --config ${hadoopConf} namenode -format -nonInteractive || true
        '';

        serviceConfig = {
          User = "hdfs";
          SyslogIdentifier = "hdfs-namenode";
          ExecStart = "${cfg.package}/bin/hdfs --config ${hadoopConf} namenode";
        };
      };
    })
    (mkIf cfg.hdfs.datanode.enabled {
      systemd.services."hdfs-datanode" = {
        description = "Hadoop HDFS DataNode";
        wantedBy = [ "multi-user.target" ];

        environment = {
          HADOOP_HOME = "${cfg.package}";
        };

        serviceConfig = {
          User = "hdfs";
          SyslogIdentifier = "hdfs-datanode";
          ExecStart = "${cfg.package}/bin/hdfs --config ${hadoopConf} datanode";
        };
      };
    })
    (mkIf (
        cfg.hdfs.namenode.enabled || cfg.hdfs.datanode.enabled
    ) {
      users.users.hdfs = {
        description = "Hadoop HDFS user";
        group = "hadoop";
        uid = config.ids.uids.hdfs;
      };
    })

  ];
}
