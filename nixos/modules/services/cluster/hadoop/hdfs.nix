{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.hadoop;

  # Config files for hadoop services
  hadoopConf = "${import ./conf.nix { inherit cfg pkgs lib; }}/";

  # Generator for HDFS service options
  hadoopServiceOption = { serviceName, firewallOption ? true, extraOpts ? null }: {
    enable = mkEnableOption (lib.mdDoc serviceName);
    restartIfChanged = mkOption {
      type = types.bool;
      description = lib.mdDoc ''
        Automatically restart the service on config change.
        This can be set to false to defer restarts on clusters running critical applications.
        Please consider the security implications of inadvertently running an older version,
        and the possibility of unexpected behavior caused by inconsistent versions across a cluster when disabling this option.
      '';
      default = false;
    };
    extraFlags = mkOption{
      type = with types; listOf str;
      default = [];
      description = lib.mdDoc "Extra command line flags to pass to ${serviceName}";
      example = [
        "-Dcom.sun.management.jmxremote"
        "-Dcom.sun.management.jmxremote.port=8010"
      ];
    };
    extraEnv = mkOption{
      type = with types; attrsOf str;
      default = {};
      description = lib.mdDoc "Extra environment variables for ${serviceName}";
    };
  } // (optionalAttrs firewallOption {
    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc "Open firewall ports for ${serviceName}.";
    };
  }) // (optionalAttrs (extraOpts != null) extraOpts);

  # Generator for HDFS service configs
  hadoopServiceConfig =
    { name
    , serviceOptions ? cfg.hdfs."${toLower name}"
    , description ? "Hadoop HDFS ${name}"
    , User ? "hdfs"
    , allowedTCPPorts ? [ ]
    , preStart ? ""
    , environment ? { }
    , extraConfig ? { }
    }: (

      mkIf serviceOptions.enable ( mkMerge [{
        systemd.services."hdfs-${toLower name}" = {
          inherit description preStart;
          environment = environment // serviceOptions.extraEnv;
          wantedBy = [ "multi-user.target" ];
          inherit (serviceOptions) restartIfChanged;
          serviceConfig = {
            inherit User;
            SyslogIdentifier = "hdfs-${toLower name}";
            ExecStart = "${cfg.package}/bin/hdfs --config ${hadoopConf} ${toLower name} ${escapeShellArgs serviceOptions.extraFlags}";
            Restart = "always";
          };
        };

        services.hadoop.gatewayRole.enable = true;

        networking.firewall.allowedTCPPorts = mkIf
          ((builtins.hasAttr "openFirewall" serviceOptions) && serviceOptions.openFirewall)
          allowedTCPPorts;
      } extraConfig])
    );

in
{
  options.services.hadoop.hdfs = {

    namenode = hadoopServiceOption { serviceName = "HDFS NameNode"; } // {
      formatOnInit = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Format HDFS namenode on first start. This is useful for quickly spinning up
          ephemeral HDFS clusters with a single namenode.
          For HA clusters, initialization involves multiple steps across multiple nodes.
          Follow this guide to initialize an HA cluster manually:
          <https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-hdfs/HDFSHighAvailabilityWithQJM.html>
        '';
      };
    };

    datanode = hadoopServiceOption { serviceName = "HDFS DataNode"; } // {
      dataDirs = mkOption {
        default = null;
        description = lib.mdDoc "Tier and path definitions for datanode storage.";
        type = with types; nullOr (listOf (submodule {
          options = {
            type = mkOption {
              type = enum [ "SSD" "DISK" "ARCHIVE" "RAM_DISK" ];
              description = lib.mdDoc ''
                Storage types ([SSD]/[DISK]/[ARCHIVE]/[RAM_DISK]) for HDFS storage policies.
              '';
            };
            path = mkOption {
              type = path;
              example = [ "/var/lib/hadoop/hdfs/dn" ];
              description = lib.mdDoc "Determines where on the local filesystem a data node should store its blocks.";
            };
          };
        }));
      };
    };

    journalnode = hadoopServiceOption { serviceName = "HDFS JournalNode"; };

    zkfc = hadoopServiceOption {
      serviceName = "HDFS ZooKeeper failover controller";
      firewallOption = false;
    };

    httpfs = hadoopServiceOption { serviceName = "HDFS JournalNode"; } // {
      tempPath = mkOption {
        type = types.path;
        default = "/tmp/hadoop/httpfs";
        description = lib.mdDoc "HTTPFS_TEMP path used by HTTPFS";
      };
    };

  };

  config = mkMerge [
    (hadoopServiceConfig {
      name = "NameNode";
      allowedTCPPorts = [
        9870 # namenode.http-address
        8020 # namenode.rpc-address
        8022 # namenode.servicerpc-address
        8019 # dfs.ha.zkfc.port
      ];
      preStart = (mkIf cfg.hdfs.namenode.formatOnInit
        "${cfg.package}/bin/hdfs --config ${hadoopConf} namenode -format -nonInteractive || true"
      );
    })

    (hadoopServiceConfig {
      name = "DataNode";
      # port numbers for datanode changed between hadoop 2 and 3
      allowedTCPPorts = if versionAtLeast cfg.package.version "3" then [
        9864 # datanode.http.address
        9866 # datanode.address
        9867 # datanode.ipc.address
      ] else [
        50075 # datanode.http.address
        50010 # datanode.address
        50020 # datanode.ipc.address
      ];
      extraConfig.services.hadoop.hdfsSiteInternal."dfs.datanode.data.dir" = mkIf (cfg.hdfs.datanode.dataDirs!= null)
        (concatMapStringsSep "," (x: "["+x.type+"]file://"+x.path) cfg.hdfs.datanode.dataDirs);
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

    (mkIf cfg.gatewayRole.enable {
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
