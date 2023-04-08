{ config, lib, pkgs, ...}:

with lib;
let
  cfg = config.services.hadoop;
  hadoopConf = "${import ./conf.nix { inherit cfg pkgs lib; }}/";
  mkIfNotNull = x: mkIf (x != null) x;
  # generic hbase role options
  hbaseRoleOption = name: extraOpts: {
    enable = mkEnableOption (mdDoc "HBase ${name}");

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc "Open firewall ports for HBase ${name}.";
    };

    restartIfChanged = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc "Restart ${name} con config change.";
    };

    extraFlags = mkOption {
      type = with types; listOf str;
      default = [];
      example = literalExpression ''[ "--backup" ]'';
      description = mdDoc "Extra flags for the ${name} service.";
    };

    environment = mkOption {
      type = with types; attrsOf str;
      default = {};
      example = literalExpression ''
        {
          HBASE_MASTER_OPTS = "-Dcom.sun.management.jmxremote.ssl=true";
        }
      '';
      description = mdDoc "Environment variables passed to ${name}.";
    };
  } // extraOpts;
  # generic hbase role configs
  hbaseRoleConfig = name: ports: (mkIf cfg.hbase."${name}".enable {
    services.hadoop.gatewayRole = {
      enable = true;
      enableHbaseCli = mkDefault true;
    };

    systemd.services."hbase-${toLower name}" = {
      description = "HBase ${name}";
      wantedBy = [ "multi-user.target" ];
      path = with cfg; [ hbase.package ] ++ optional
        (with cfg.hbase.master; enable && initHDFS) package;
      preStart = mkIf (with cfg.hbase.master; enable && initHDFS)
        (concatStringsSep "\n" (
          map (x: "HADOOP_USER_NAME=hdfs hdfs --config /etc/hadoop-conf ${x}")[
            "dfsadmin -safemode wait"
            "dfs -mkdir -p ${cfg.hbase.rootdir}"
            "dfs -chown hbase ${cfg.hbase.rootdir}"
          ]
        ));

      inherit (cfg.hbase."${name}") environment;
      script = concatStringsSep " " (
        [
          "hbase --config /etc/hadoop-conf/"
          "${toLower name} start"
        ]
        ++ cfg.hbase."${name}".extraFlags
        ++ map (x: "--${toLower x} ${toString cfg.hbase.${name}.${x}}")
          (filter (x: hasAttr x cfg.hbase.${name}) ["port" "infoPort"])
      );

      serviceConfig = {
        User = "hbase";
        SyslogIdentifier = "hbase-${toLower name}";
        Restart = "always";
      };
    };

    services.hadoop.hbaseSiteInternal."hbase.rootdir" = cfg.hbase.rootdir;

    networking = {
      firewall.allowedTCPPorts = mkIf cfg.hbase."${name}".openFirewall ports;
      hosts = mkIf (with cfg.hbase.regionServer; enable && overrideHosts) {
        "127.0.0.2" = mkForce [ ];
        "::1" = mkForce [ ];
      };
    };

  });
in
{
  options.services.hadoop = {

    gatewayRole.enableHbaseCli = mkEnableOption (mdDoc "HBase CLI tools");

    hbaseSiteDefault = mkOption {
      default = {
        "hbase.regionserver.ipc.address" = "0.0.0.0";
        "hbase.master.ipc.address" = "0.0.0.0";
        "hbase.master.info.bindAddress" = "0.0.0.0";
        "hbase.regionserver.info.bindAddress" = "0.0.0.0";

        "hbase.cluster.distributed" = "true";
      };
      type = types.attrsOf types.anything;
      description = mdDoc ''
        Default options for hbase-site.xml
      '';
    };
    hbaseSite = mkOption {
      default = {};
      type = with types; attrsOf anything;
      example = literalExpression ''
        {
          "hbase.hregion.max.filesize" = 20*1024*1024*1024;
          "hbase.table.normalization.enabled" = "true";
        }
      '';
      description = mdDoc ''
        Additional options and overrides for hbase-site.xml
        <https://github.com/apache/hbase/blob/rel/2.4.11/hbase-common/src/main/resources/hbase-default.xml>
      '';
    };
    hbaseSiteInternal = mkOption {
      default = {};
      type = with types; attrsOf anything;
      internal = true;
      description = mdDoc ''
        Internal option to add configs to hbase-site.xml based on module options
      '';
    };

    hbase = {

      package = mkOption {
        type = types.package;
        default = pkgs.hbase;
        defaultText = literalExpression "pkgs.hbase";
        description = mdDoc "HBase package";
      };

      rootdir = mkOption {
        description = mdDoc ''
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
        description = mdDoc ''
          This option will set "hbase.zookeeper.quorum" in hbase-site.xml.
          Comma separated list of servers in the ZooKeeper ensemble.
        '';
        type = with types; nullOr commas;
        example = "zk1.internal,zk2.internal,zk3.internal";
        default = null;
      };
    } // (let
      ports = port: infoPort: {
        port = mkOption {
          type = types.int;
          default = port;
          description = mdDoc "RPC port";
        };
        infoPort = mkOption {
          type = types.int;
          default = infoPort;
          description = mdDoc "web UI port";
        };
      };
    in mapAttrs hbaseRoleOption {
      master.initHDFS = mkEnableOption (mdDoc "initialization of the hbase directory on HDFS");
      regionServer.overrideHosts = mkOption {
        type = types.bool;
        default = true;
        description = mdDoc ''
          Remove /etc/hosts entries for "127.0.0.2" and "::1" defined in nixos/modules/config/networking.nix
          Regionservers must be able to resolve their hostnames to their IP addresses, through PTR records
          or /etc/hosts entries.
        '';
      };
      thrift = ports 9090 9095;
      rest = ports 8080 8085;
    });
  };

  config = mkMerge ([

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
  ] ++ (mapAttrsToList hbaseRoleConfig {
    master = [ 16000 16010 ];
    regionServer = [ 16020 16030 ];
    thrift = with cfg.hbase.thrift; [ port infoPort ];
    rest = with cfg.hbase.rest; [ port infoPort ];
  }));
}
