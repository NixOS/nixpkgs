{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.services.etcd;
  opt = options.services.etcd;

in
{

  options.services.etcd = {
    enable = lib.mkOption {
      description = "Whether to enable etcd.";
      default = false;
      type = lib.types.bool;
    };

    package = lib.mkPackageOption pkgs "etcd" { };

    name = lib.mkOption {
      description = "Etcd unique node name.";
      default = config.networking.hostName;
      defaultText = lib.literalExpression "config.networking.hostName";
      type = lib.types.str;
    };

    advertiseClientUrls = lib.mkOption {
      description = "Etcd list of this member's client URLs to advertise to the rest of the cluster.";
      default = cfg.listenClientUrls;
      defaultText = lib.literalExpression "config.${opt.listenClientUrls}";
      type = lib.types.listOf lib.types.str;
    };

    listenClientUrls = lib.mkOption {
      description = "Etcd list of URLs to listen on for client traffic.";
      default = [ "http://127.0.0.1:2379" ];
      type = lib.types.listOf lib.types.str;
    };

    listenPeerUrls = lib.mkOption {
      description = "Etcd list of URLs to listen on for peer traffic.";
      default = [ "http://127.0.0.1:2380" ];
      type = lib.types.listOf lib.types.str;
    };

    initialAdvertisePeerUrls = lib.mkOption {
      description = "Etcd list of this member's peer URLs to advertise to rest of the cluster.";
      default = cfg.listenPeerUrls;
      defaultText = lib.literalExpression "config.${opt.listenPeerUrls}";
      type = lib.types.listOf lib.types.str;
    };

    initialCluster = lib.mkOption {
      description = "Etcd initial cluster configuration for bootstrapping.";
      default = [ "${cfg.name}=http://127.0.0.1:2380" ];
      defaultText = lib.literalExpression ''["''${config.${opt.name}}=http://127.0.0.1:2380"]'';
      type = lib.types.listOf lib.types.str;
    };

    initialClusterState = lib.mkOption {
      description = "Etcd initial cluster configuration for bootstrapping.";
      default = "new";
      type = lib.types.enum [
        "new"
        "existing"
      ];
    };

    initialClusterToken = lib.mkOption {
      description = "Etcd initial cluster token for etcd cluster during bootstrap.";
      default = "etcd-cluster";
      type = lib.types.str;
    };

    discovery = lib.mkOption {
      description = "Etcd discovery url";
      default = "";
      type = lib.types.str;
    };

    clientCertAuth = lib.mkOption {
      description = "Whether to use certs for client authentication";
      default = false;
      type = lib.types.bool;
    };

    trustedCaFile = lib.mkOption {
      description = "Certificate authority file to use for clients";
      default = null;
      type = lib.types.nullOr lib.types.path;
    };

    certFile = lib.mkOption {
      description = "Cert file to use for clients";
      default = null;
      type = lib.types.nullOr lib.types.path;
    };

    keyFile = lib.mkOption {
      description = "Key file to use for clients";
      default = null;
      type = lib.types.nullOr lib.types.path;
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Open etcd ports in the firewall.
        Ports opened:
        - 2379/tcp for client requests
        - 2380/tcp for peer communication
      '';
    };

    peerCertFile = lib.mkOption {
      description = "Cert file to use for peer to peer communication";
      default = cfg.certFile;
      defaultText = lib.literalExpression "config.${opt.certFile}";
      type = lib.types.nullOr lib.types.path;
    };

    peerKeyFile = lib.mkOption {
      description = "Key file to use for peer to peer communication";
      default = cfg.keyFile;
      defaultText = lib.literalExpression "config.${opt.keyFile}";
      type = lib.types.nullOr lib.types.path;
    };

    peerTrustedCaFile = lib.mkOption {
      description = "Certificate authority file to use for peer to peer communication";
      default = cfg.trustedCaFile;
      defaultText = lib.literalExpression "config.${opt.trustedCaFile}";
      type = lib.types.nullOr lib.types.path;
    };

    peerClientCertAuth = lib.mkOption {
      description = "Whether to check all incoming peer requests from the cluster for valid client certificates signed by the supplied CA";
      default = false;
      type = lib.types.bool;
    };

    extraConf = lib.mkOption {
      description = ''
        Etcd extra configuration. See
        <https://github.com/coreos/etcd/blob/master/Documentation/op-guide/configuration.md#configuration-flags>
      '';
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = lib.literalExpression ''
        {
          "CORS" = "*";
          "NAME" = "default-name";
          "MAX_RESULT_BUFFER" = "1024";
          "MAX_CLUSTER_SIZE" = "9";
          "MAX_RETRY_ATTEMPTS" = "3";
        }
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/etcd";
      description = "Etcd data directory.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.settings."10-etcd".${cfg.dataDir}.d = {
      user = "etcd";
      mode = "0700";
    };

    systemd.services.etcd = {
      description = "etcd key-value store";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network-online.target"
      ]
      ++ lib.optional config.networking.firewall.enable "firewall.service";
      wants = [
        "network-online.target"
      ]
      ++ lib.optional config.networking.firewall.enable "firewall.service";

      environment =
        (lib.filterAttrs (n: v: v != null) {
          ETCD_NAME = cfg.name;
          ETCD_DISCOVERY = cfg.discovery;
          ETCD_DATA_DIR = cfg.dataDir;
          ETCD_ADVERTISE_CLIENT_URLS = lib.concatStringsSep "," cfg.advertiseClientUrls;
          ETCD_LISTEN_CLIENT_URLS = lib.concatStringsSep "," cfg.listenClientUrls;
          ETCD_LISTEN_PEER_URLS = lib.concatStringsSep "," cfg.listenPeerUrls;
          ETCD_INITIAL_ADVERTISE_PEER_URLS = lib.concatStringsSep "," cfg.initialAdvertisePeerUrls;
          ETCD_PEER_CLIENT_CERT_AUTH = toString cfg.peerClientCertAuth;
          ETCD_PEER_TRUSTED_CA_FILE = cfg.peerTrustedCaFile;
          ETCD_PEER_CERT_FILE = cfg.peerCertFile;
          ETCD_PEER_KEY_FILE = cfg.peerKeyFile;
          ETCD_CLIENT_CERT_AUTH = toString cfg.clientCertAuth;
          ETCD_TRUSTED_CA_FILE = cfg.trustedCaFile;
          ETCD_CERT_FILE = cfg.certFile;
          ETCD_KEY_FILE = cfg.keyFile;
        })
        // (lib.optionalAttrs (cfg.discovery == "") {
          ETCD_INITIAL_CLUSTER = lib.concatStringsSep "," cfg.initialCluster;
          ETCD_INITIAL_CLUSTER_STATE = cfg.initialClusterState;
          ETCD_INITIAL_CLUSTER_TOKEN = cfg.initialClusterToken;
        })
        // (lib.mapAttrs' (n: v: lib.nameValuePair "ETCD_${n}" v) cfg.extraConf);

      unitConfig = {
        Documentation = "https://github.com/coreos/etcd";
      };

      serviceConfig = {
        Type = "notify";
        Restart = "always";
        RestartSec = "30s";
        ExecStart = "${cfg.package}/bin/etcd";
        User = "etcd";
        LimitNOFILE = 40000;
      };
    };

    environment.systemPackages = [ cfg.package ];

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [
        2379 # for client requests
        2380 # for peer communication
      ];
    };

    users.users.etcd = {
      isSystemUser = true;
      group = "etcd";
      description = "Etcd daemon user";
      home = cfg.dataDir;
    };
    users.groups.etcd = { };
  };
}
