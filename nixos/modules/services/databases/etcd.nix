{
  config,
  lib,
  options,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.etcd;
  opt = options.services.etcd;

in
{

  options.services.etcd = {
    enable = mkOption {
      description = "Whether to enable etcd.";
      default = false;
      type = types.bool;
    };

    package = mkPackageOption pkgs "etcd" { };

    name = mkOption {
      description = "Etcd unique node name.";
      default = config.networking.hostName;
      defaultText = literalExpression "config.networking.hostName";
      type = types.str;
    };

    advertiseClientUrls = mkOption {
      description = "Etcd list of this member's client URLs to advertise to the rest of the cluster.";
      default = cfg.listenClientUrls;
      defaultText = literalExpression "config.${opt.listenClientUrls}";
      type = types.listOf types.str;
    };

    listenClientUrls = mkOption {
      description = "Etcd list of URLs to listen on for client traffic.";
      default = [ "http://127.0.0.1:2379" ];
      type = types.listOf types.str;
    };

    listenPeerUrls = mkOption {
      description = "Etcd list of URLs to listen on for peer traffic.";
      default = [ "http://127.0.0.1:2380" ];
      type = types.listOf types.str;
    };

    initialAdvertisePeerUrls = mkOption {
      description = "Etcd list of this member's peer URLs to advertise to rest of the cluster.";
      default = cfg.listenPeerUrls;
      defaultText = literalExpression "config.${opt.listenPeerUrls}";
      type = types.listOf types.str;
    };

    initialCluster = mkOption {
      description = "Etcd initial cluster configuration for bootstrapping.";
      default = [ "${cfg.name}=http://127.0.0.1:2380" ];
      defaultText = literalExpression ''["''${config.${opt.name}}=http://127.0.0.1:2380"]'';
      type = types.listOf types.str;
    };

    initialClusterState = mkOption {
      description = "Etcd initial cluster configuration for bootstrapping.";
      default = "new";
      type = types.enum [
        "new"
        "existing"
      ];
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

    clientCertAuth = mkOption {
      description = "Whether to use certs for client authentication";
      default = false;
      type = types.bool;
    };

    trustedCaFile = mkOption {
      description = "Certificate authority file to use for clients";
      default = null;
      type = types.nullOr types.path;
    };

    certFile = mkOption {
      description = "Cert file to use for clients";
      default = null;
      type = types.nullOr types.path;
    };

    keyFile = mkOption {
      description = "Key file to use for clients";
      default = null;
      type = types.nullOr types.path;
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Open etcd ports in the firewall.
        Ports opened:
        - 2379/tcp for client requests
        - 2380/tcp for peer communication
      '';
    };

    peerCertFile = mkOption {
      description = "Cert file to use for peer to peer communication";
      default = cfg.certFile;
      defaultText = literalExpression "config.${opt.certFile}";
      type = types.nullOr types.path;
    };

    peerKeyFile = mkOption {
      description = "Key file to use for peer to peer communication";
      default = cfg.keyFile;
      defaultText = literalExpression "config.${opt.keyFile}";
      type = types.nullOr types.path;
    };

    peerTrustedCaFile = mkOption {
      description = "Certificate authority file to use for peer to peer communication";
      default = cfg.trustedCaFile;
      defaultText = literalExpression "config.${opt.trustedCaFile}";
      type = types.nullOr types.path;
    };

    peerClientCertAuth = mkOption {
      description = "Whether to check all incoming peer requests from the cluster for valid client certificates signed by the supplied CA";
      default = false;
      type = types.bool;
    };

    extraConf = mkOption {
      description = ''
        Etcd extra configuration. See
        <https://github.com/coreos/etcd/blob/master/Documentation/op-guide/configuration.md#configuration-flags>
      '';
      type = types.attrsOf types.str;
      default = { };
      example = literalExpression ''
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
    systemd.tmpfiles.settings."10-etcd".${cfg.dataDir}.d = {
      user = "etcd";
      mode = "0700";
    };

    systemd.services.etcd = {
      description = "etcd key-value store";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network-online.target"
      ] ++ lib.optional config.networking.firewall.enable "firewall.service";
      wants = [
        "network-online.target"
      ] ++ lib.optional config.networking.firewall.enable "firewall.service";

      environment =
        (filterAttrs (n: v: v != null) {
          ETCD_NAME = cfg.name;
          ETCD_DISCOVERY = cfg.discovery;
          ETCD_DATA_DIR = cfg.dataDir;
          ETCD_ADVERTISE_CLIENT_URLS = concatStringsSep "," cfg.advertiseClientUrls;
          ETCD_LISTEN_CLIENT_URLS = concatStringsSep "," cfg.listenClientUrls;
          ETCD_LISTEN_PEER_URLS = concatStringsSep "," cfg.listenPeerUrls;
          ETCD_INITIAL_ADVERTISE_PEER_URLS = concatStringsSep "," cfg.initialAdvertisePeerUrls;
          ETCD_PEER_CLIENT_CERT_AUTH = toString cfg.peerClientCertAuth;
          ETCD_PEER_TRUSTED_CA_FILE = cfg.peerTrustedCaFile;
          ETCD_PEER_CERT_FILE = cfg.peerCertFile;
          ETCD_PEER_KEY_FILE = cfg.peerKeyFile;
          ETCD_CLIENT_CERT_AUTH = toString cfg.clientCertAuth;
          ETCD_TRUSTED_CA_FILE = cfg.trustedCaFile;
          ETCD_CERT_FILE = cfg.certFile;
          ETCD_KEY_FILE = cfg.keyFile;
        })
        // (optionalAttrs (cfg.discovery == "") {
          ETCD_INITIAL_CLUSTER = concatStringsSep "," cfg.initialCluster;
          ETCD_INITIAL_CLUSTER_STATE = cfg.initialClusterState;
          ETCD_INITIAL_CLUSTER_TOKEN = cfg.initialClusterToken;
        })
        // (mapAttrs' (n: v: nameValuePair "ETCD_${n}" v) cfg.extraConf);

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
