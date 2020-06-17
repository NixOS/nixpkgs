{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.flannel;

  networkConfig = filterAttrs (n: v: v != null) {
    Network = cfg.network;
    SubnetLen = cfg.subnetLen;
    SubnetMin = cfg.subnetMin;
    SubnetMax = cfg.subnetMax;
    Backend = cfg.backend;
  };
in {
  options.services.flannel = {
    enable = mkEnableOption "flannel";

    package = mkOption {
      description = "Package to use for flannel";
      type = types.package;
      default = pkgs.flannel;
      defaultText = "pkgs.flannel";
    };

    publicIp = mkOption {
      description = ''
        IP accessible by other nodes for inter-host communication.
        Defaults to the IP of the interface being used for communication.
      '';
      type = types.nullOr types.str;
      default = null;
    };

    iface = mkOption {
      description = ''
        Interface to use (IP or name) for inter-host communication.
        Defaults to the interface for the default route on the machine.
      '';
      type = types.nullOr types.str;
      default = null;
    };

    etcd = {
      endpoints = mkOption {
        description = "Etcd endpoints";
        type = types.listOf types.str;
        default = ["http://127.0.0.1:2379"];
      };

      prefix = mkOption {
        description = "Etcd key prefix";
        type = types.str;
        default = "/coreos.com/network";
      };

      caFile = mkOption {
        description = "Etcd certificate authority file";
        type = types.nullOr types.path;
        default = null;
      };

      certFile = mkOption {
        description = "Etcd cert file";
        type = types.nullOr types.path;
        default = null;
      };

      keyFile = mkOption {
        description = "Etcd key file";
        type = types.nullOr types.path;
        default = null;
      };
    };

    kubeconfig = mkOption {
      description = ''
        Path to kubeconfig to use for storing flannel config using the
        Kubernetes API
      '';
      type = types.nullOr types.path;
      default = null;
    };

    network = mkOption {
      description = " IPv4 network in CIDR format to use for the entire flannel network.";
      type = types.str;
    };

    nodeName = mkOption {
      description = ''
        Needed when running with Kubernetes as backend as this cannot be auto-detected";
      '';
      type = types.nullOr types.str;
      default = with config.networking; (hostName + optionalString (domain != null) ".${domain}");
      example = "node1.example.com";
    };

    storageBackend = mkOption {
      description = "Determines where flannel stores its configuration at runtime";
      type = types.enum ["etcd" "kubernetes"];
      default = "etcd";
    };

    subnetLen = mkOption {
      description = ''
        The size of the subnet allocated to each host. Defaults to 24 (i.e. /24)
        unless the Network was configured to be smaller than a /24 in which case
        it is one less than the network.
      '';
      type = types.int;
      default = 24;
    };

    subnetMin = mkOption {
      description = ''
        The beginning of IP range which the subnet allocation should start with.
        Defaults to the first subnet of Network.
      '';
      type = types.nullOr types.str;
      default = null;
    };

    subnetMax = mkOption {
      description = ''
        The end of IP range which the subnet allocation should start with.
        Defaults to the last subnet of Network.
      '';
      type = types.nullOr types.str;
      default = null;
    };

    backend = mkOption {
      description = "Type of backend to use and specific configurations for that backend.";
      type = types.attrs;
      default = {
        Type = "vxlan";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.flannel = {
      description = "Flannel Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = {
        FLANNELD_PUBLIC_IP = cfg.publicIp;
        FLANNELD_IFACE = cfg.iface;
      } // optionalAttrs (cfg.storageBackend == "etcd") {
        FLANNELD_ETCD_ENDPOINTS = concatStringsSep "," cfg.etcd.endpoints;
        FLANNELD_ETCD_KEYFILE = cfg.etcd.keyFile;
        FLANNELD_ETCD_CERTFILE = cfg.etcd.certFile;
        FLANNELD_ETCD_CAFILE = cfg.etcd.caFile;
        ETCDCTL_CERT_FILE = cfg.etcd.certFile;
        ETCDCTL_KEY_FILE = cfg.etcd.keyFile;
        ETCDCTL_CA_FILE = cfg.etcd.caFile;
        ETCDCTL_PEERS = concatStringsSep "," cfg.etcd.endpoints;
      } // optionalAttrs (cfg.storageBackend == "kubernetes") {
        FLANNELD_KUBE_SUBNET_MGR = "true";
        FLANNELD_KUBECONFIG_FILE = cfg.kubeconfig;
        NODE_NAME = cfg.nodeName;
      };
      path = [ pkgs.iptables ];
      preStart = ''
        mkdir -p /run/flannel
        touch /run/flannel/docker
      '' + optionalString (cfg.storageBackend == "etcd") ''
        echo "setting network configuration"
        until ${pkgs.etcdctl}/bin/etcdctl set /coreos.com/network/config '${builtins.toJSON networkConfig}'
        do
          echo "setting network configuration, retry"
          sleep 1
        done
      '';
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/flannel";
        Restart = "always";
        RestartSec = "10s";
      };
    };

    services.etcd.enable = mkDefault (cfg.storageBackend == "etcd" && cfg.etcd.endpoints == ["http://127.0.0.1:2379"]);

    # for some reason, flannel doesn't let you configure this path
    # see: https://github.com/coreos/flannel/blob/master/Documentation/configuration.md#configuration
    environment.etc."kube-flannel/net-conf.json" = mkIf (cfg.storageBackend == "kubernetes") {
      source = pkgs.writeText "net-conf.json" (builtins.toJSON networkConfig);
    };
  };
}
