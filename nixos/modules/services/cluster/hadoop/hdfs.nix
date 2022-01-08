{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.hadoop;

  # Config files for hadoop services
  hadoopConf = "${import ./conf.nix { inherit cfg pkgs lib; }}/";

  # Generator for HDFS service options
  hadoopServiceOption = { serviceName, firewallOption ? true }: {
    enable = mkEnableOption serviceName;
    restartIfChanged = mkOption {
      type = types.bool;
      description = ''
        Automatically restart the service on config change.
        This can be set to false to defer restarts on clusters running critical applications.
        Please consider the security implications of inadvertently running an older version,
        and the possibility of unexpected behavior caused by inconsistent versions across a cluster when disabling this option.
      '';
      default = false;
    };
  } // (optionalAttrs firewallOption {
    openFirewall = mkOption {
      type = types.bool;
      default = true;
      description = "Open firewall ports for ${serviceName}.";
    };
  });

  # Generator for HDFS service configs
  hadoopServiceConfig =
    { name
    , serviceOptions ? cfg.hdfs."${toLower name}"
    , description ? "Hadoop HDFS ${name}"
    , User ? "hdfs"
    , allowedTCPPorts ? [ ]
    , preStart ? ""
    , environment ? { }
    }: (

      mkIf serviceOptions.enable {
        systemd.services."hdfs-${toLower name}" = {
          inherit description preStart environment;
          wantedBy = [ "multi-user.target" ];
          inherit (serviceOptions) restartIfChanged;
          serviceConfig = {
            inherit User;
            SyslogIdentifier = "hdfs-${toLower name}";
            ExecStart = "${cfg.package}/bin/hdfs --config ${hadoopConf} ${toLower name}";
            Restart = "always";
          };
        };

        networking.firewall.allowedTCPPorts = mkIf
          ((builtins.hasAttr "openFirewall" serviceOptions) && serviceOptions.openFirewall)
          allowedTCPPorts;
      }
    );

in
{
  options.services.hadoop.hdfs = {

    namenode = hadoopServiceOption { serviceName = "HDFS NameNode"; } // {
      formatOnInit = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Format HDFS namenode on first start. This is useful for quickly spinning up
          ephemeral HDFS clusters with a single namenode.
          For HA clusters, initialization involves multiple steps across multiple nodes.
          Follow this guide to initialize an HA cluster manually:
          <link xlink:href="https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-hdfs/HDFSHighAvailabilityWithQJM.html"/>
        '';
      };
    };

    datanode = hadoopServiceOption { serviceName = "HDFS DataNode"; };

    journalnode = hadoopServiceOption { serviceName = "HDFS JournalNode"; };

    zkfc = hadoopServiceOption {
      serviceName = "HDFS ZooKeeper failover controller";
      firewallOption = false;
    };

    httpfs = hadoopServiceOption { serviceName = "HDFS JournalNode"; } // {
      tempPath = mkOption {
        type = types.path;
        default = "/tmp/hadoop/httpfs";
        description = "HTTPFS_TEMP path used by HTTPFS";
      };
    };

  };

  config = mkMerge [
    (hadoopServiceConfig {
      name = "NameNode";
      allowedTCPPorts = [
        9870 # namenode.http-address
        8020 # namenode.rpc-address
        8022 # namenode. servicerpc-address
      ];
      preStart = (mkIf cfg.hdfs.namenode.formatOnInit
        "${cfg.package}/bin/hdfs --config ${hadoopConf} namenode -format -nonInteractive || true"
      );
    })

    (hadoopServiceConfig {
      name = "DataNode";
      allowedTCPPorts = [
        9864 # datanode.http.address
        9866 # datanode.address
        9867 # datanode.ipc.address
      ];
    })

    (hadoopServiceConfig {
      name = "JournalNode";
      allowedTCPPorts = [
        8480 # dfs.journalnode.http-address
        8485 # dfs.journalnode.rpc-address
      ];
    })

    (hadoopServiceConfig {
      name = "zkfc";
      description = "Hadoop HDFS ZooKeeper failover controller";
    })

    (hadoopServiceConfig {
      name = "HTTPFS";
      environment.HTTPFS_TEMP = cfg.hdfs.httpfs.tempPath;
      preStart = "mkdir -p $HTTPFS_TEMP";
      User = "httpfs";
      allowedTCPPorts = [
        14000 # httpfs.http.port
      ];
    })

    (mkIf
      (
        cfg.hdfs.namenode.enable || cfg.hdfs.datanode.enable || cfg.hdfs.journalnode.enable || cfg.hdfs.zkfc.enable
      )
      {
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
