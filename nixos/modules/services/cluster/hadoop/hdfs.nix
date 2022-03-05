{ config, lib, pkgs, ...}:
with lib;
let
  cfg = config.services.hadoop;
  hadoopConf = "${import ./conf.nix { inherit cfg pkgs lib; }}/";
  restartIfChanged  = mkOption {
    type = types.bool;
    description = ''
      Automatically restart the service on config change.
      This can be set to false to defer restarts on clusters running critical applications.
      Please consider the security implications of inadvertently running an older version,
      and the possibility of unexpected behavior caused by inconsistent versions across a cluster when disabling this option.
    '';
    default = false;
  };
in
{
  options.services.hadoop.hdfs = {
    namenode = {
      enable = mkEnableOption "Whether to run the HDFS NameNode";
      formatOnInit = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Format HDFS namenode on first start. This is useful for quickly spinning up ephemeral HDFS clusters with a single namenode.
          For HA clusters, initialization involves multiple steps across multiple nodes. Follow [this guide](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-hdfs/HDFSHighAvailabilityWithQJM.html)
          to initialize an HA cluster manually.
        '';
      };
      inherit restartIfChanged;
      openFirewall = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Open firewall ports for namenode
        '';
      };
    };
    datanode = {
      enable = mkEnableOption "Whether to run the HDFS DataNode";
      inherit restartIfChanged;
      openFirewall = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Open firewall ports for datanode
        '';
      };
    };
    journalnode = {
      enable = mkEnableOption "Whether to run the HDFS JournalNode";
      inherit restartIfChanged;
      openFirewall = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Open firewall ports for journalnode
        '';
      };
    };
    zkfc = {
      enable = mkEnableOption "Whether to run the HDFS ZooKeeper failover controller";
      inherit restartIfChanged;
    };
    httpfs = {
      enable = mkEnableOption "Whether to run the HDFS HTTPfs server";
      tempPath = mkOption {
        type = types.path;
        default = "/tmp/hadoop/httpfs";
        description = ''
          HTTPFS_TEMP path used by HTTPFS
        '';
      };
      inherit restartIfChanged;
      openFirewall = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Open firewall ports for HTTPFS
        '';
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.hdfs.namenode.enable {
      systemd.services.hdfs-namenode = {
        description = "Hadoop HDFS NameNode";
        wantedBy = [ "multi-user.target" ];
        inherit (cfg.hdfs.namenode) restartIfChanged;

        preStart = (mkIf cfg.hdfs.namenode.formatOnInit ''
          ${cfg.package}/bin/hdfs --config ${hadoopConf} namenode -format -nonInteractive || true
        '');

        serviceConfig = {
          User = "hdfs";
          SyslogIdentifier = "hdfs-namenode";
          ExecStart = "${cfg.package}/bin/hdfs --config ${hadoopConf} namenode";
          Restart = "always";
        };
      };

      networking.firewall.allowedTCPPorts = (mkIf cfg.hdfs.namenode.openFirewall [
        9870 # namenode.http-address
        8020 # namenode.rpc-address
        8022 # namenode. servicerpc-address
      ]);
    })
    (mkIf cfg.hdfs.datanode.enable {
      systemd.services.hdfs-datanode = {
        description = "Hadoop HDFS DataNode";
        wantedBy = [ "multi-user.target" ];
        inherit (cfg.hdfs.datanode) restartIfChanged;

        serviceConfig = {
          User = "hdfs";
          SyslogIdentifier = "hdfs-datanode";
          ExecStart = "${cfg.package}/bin/hdfs --config ${hadoopConf} datanode";
          Restart = "always";
        };
      };

      networking.firewall.allowedTCPPorts = (mkIf cfg.hdfs.datanode.openFirewall [
        9864 # datanode.http.address
        9866 # datanode.address
        9867 # datanode.ipc.address
      ]);
    })
    (mkIf cfg.hdfs.journalnode.enable {
      systemd.services.hdfs-journalnode = {
        description = "Hadoop HDFS JournalNode";
        wantedBy = [ "multi-user.target" ];
        inherit (cfg.hdfs.journalnode) restartIfChanged;

        serviceConfig = {
          User = "hdfs";
          SyslogIdentifier = "hdfs-journalnode";
          ExecStart = "${cfg.package}/bin/hdfs --config ${hadoopConf} journalnode";
          Restart = "always";
        };
      };

      networking.firewall.allowedTCPPorts = (mkIf cfg.hdfs.journalnode.openFirewall [
        8480 # dfs.journalnode.http-address
        8485 # dfs.journalnode.rpc-address
      ]);
    })
    (mkIf cfg.hdfs.zkfc.enable {
      systemd.services.hdfs-zkfc = {
        description = "Hadoop HDFS ZooKeeper failover controller";
        wantedBy = [ "multi-user.target" ];
        inherit (cfg.hdfs.zkfc) restartIfChanged;

        serviceConfig = {
          User = "hdfs";
          SyslogIdentifier = "hdfs-zkfc";
          ExecStart = "${cfg.package}/bin/hdfs --config ${hadoopConf} zkfc";
          Restart = "always";
        };
      };
    })
    (mkIf cfg.hdfs.httpfs.enable {
      systemd.services.hdfs-httpfs = {
        description = "Hadoop httpfs";
        wantedBy = [ "multi-user.target" ];
        inherit (cfg.hdfs.httpfs) restartIfChanged;

        environment.HTTPFS_TEMP = cfg.hdfs.httpfs.tempPath;

        preStart = ''
          mkdir -p $HTTPFS_TEMP
        '';

        serviceConfig = {
          User = "httpfs";
          SyslogIdentifier = "hdfs-httpfs";
          ExecStart = "${cfg.package}/bin/hdfs --config ${hadoopConf} httpfs";
          Restart = "always";
        };
      };
      networking.firewall.allowedTCPPorts = (mkIf cfg.hdfs.httpfs.openFirewall [
        14000 # httpfs.http.port
      ]);
    })
    (mkIf (
        cfg.hdfs.namenode.enable || cfg.hdfs.datanode.enable || cfg.hdfs.journalnode.enable || cfg.hdfs.zkfc.enable
    ) {
      users.users.hdfs = {
        description = "Hadoop HDFS user";
        group = "hadoop";
        uid = config.ids.uids.hdfs;
      };
    })
    (mkIf cfg.hdfs.httpfs.enable {
      users.users.httpfs = {
        description = "Hadoop HTTPFS user";
        group = "hadoop";
        isSystemUser = true;
      };
    })
  ];
}
