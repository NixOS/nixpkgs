{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.etcd;

in {

  options.services.etcd = {
    enable = mkOption {
      description = "Whether to enable etcd.";
      default = false;
      type = types.bool;
    };

    name = mkOption {
      description = "Etcd unique node name.";
      default = config.networking.hostName;
      type = types.str;
    };

    advertiseClientUrls = mkOption {
      description = "Etcd list of this member's client URLs to advertise to the rest of the cluster.";
      default = cfg.listenClientUrls;
      type = types.listOf types.str;
    };

    listenClientUrls = mkOption {
      description = "Etcd list of URLs to listen on for client traffic.";
      default = ["http://localhost:4001"];
      type = types.listOf types.str;
    };

    listenPeerUrls = mkOption {
      description = "Etcd list of URLs to listen on for peer traffic.";
      default = ["http://localhost:7001"];
      type = types.listOf types.str;
    };

    initialAdvertisePeerUrls = mkOption {
      description = "Etcd list of this member's peer URLs to advertise to rest of the cluster.";
      default = cfg.listenPeerUrls;
      type = types.listOf types.str;
    };

    initialCluster = mkOption {
      description = "Etcd initial cluster configuration for bootstrapping.";
      default = ["${cfg.name}=http://localhost:7001"];
      type = types.listOf types.str;
    };

    initialClusterState = mkOption {
      description = "Etcd initial cluster configuration for bootstrapping.";
      default = "new";
      type = types.enum ["new" "existing"];
    };

    initialClusterToken = mkOption {
      description = "Etcd initial cluster token for etcd cluster during bootstrap.";
      default = "etcd-cluster";
      type = types.str;
    };

    discovery = mkOption {
      description = "Etcd discovery url";
      default = "";
      type = types.str;
    };

    extraConf = mkOption {
      description = ''
        Etcd extra configuration. See
        <link xlink:href='https://github.com/coreos/etcd/blob/master/Documentation/configuration.md#environment-variables' />
      '';
      type = types.attrsOf types.str;
      default = {};
      example = literalExample ''
        {
          "CORS" = "*";
          "NAME" = "default-name";
          "MAX_RESULT_BUFFER" = "1024";
          "MAX_CLUSTER_SIZE" = "9";
          "MAX_RETRY_ATTEMPTS" = "3";
        }
      '';
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/etcd";
      description = "Etcd data directory.";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.etcd = {
      description = "Etcd Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-interfaces.target" ];

      environment = {
        ETCD_NAME = cfg.name;
        ETCD_DISCOVERY = cfg.discovery;
        ETCD_DATA_DIR = cfg.dataDir;
        ETCD_ADVERTISE_CLIENT_URLS = concatStringsSep "," cfg.advertiseClientUrls;
        ETCD_LISTEN_CLIENT_URLS = concatStringsSep "," cfg.listenClientUrls;
        ETCD_LISTEN_PEER_URLS = concatStringsSep "," cfg.listenPeerUrls;
        ETCD_INITIAL_ADVERTISE_PEER_URLS = concatStringsSep "," cfg.initialAdvertisePeerUrls;
      } // (optionalAttrs (cfg.discovery == ""){
        ETCD_INITIAL_CLUSTER = concatStringsSep "," cfg.initialCluster;
        ETCD_INITIAL_CLUSTER_STATE = cfg.initialClusterState;
        ETCD_INITIAL_CLUSTER_TOKEN = cfg.initialClusterToken;
      }) // (mapAttrs' (n: v: nameValuePair "ETCD_${n}" v) cfg.extraConf);

      serviceConfig = {
        Type = "notify";
        ExecStart = "${pkgs.etcd}/bin/etcd";
        User = "etcd";
        PermissionsStartOnly = true;
      };
      preStart = ''
        mkdir -m 0700 -p ${cfg.dataDir}
        if [ "$(id -u)" = 0 ]; then chown etcd ${cfg.dataDir}; fi
      '';
    };

    environment.systemPackages = [ pkgs.etcdctl ];

    users.extraUsers = singleton {
      name = "etcd";
      uid = config.ids.uids.etcd;
      description = "Etcd daemon user";
      home = cfg.dataDir;
    };
  };
}
