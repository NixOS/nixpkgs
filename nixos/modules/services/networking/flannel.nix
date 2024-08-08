{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.flannel;

  networkConfig = filterAttrs (n: v: v != null) {
    EnableIPv6 = cfg.ipv6Network != null;
    Network = cfg.network;
    IPv6Network = cfg.ipv6Network;
    SubnetLen = cfg.subnetLen;
    SubnetMin = cfg.subnetMin;
    SubnetMax = cfg.subnetMax;
    Ipv6SubnetLen = cfg.ipv6SubnetLen;
    Ipv6SubnetMin = cfg.ipv6SubnetMin;
    Ipv6SubnetMax = cfg.ipv6SubnetMax;
    Backend = cfg.backend;
  };
in {
  options.services.flannel = {
    enable = mkEnableOption "flannel";

    package = mkPackageOption pkgs "flannel" { };

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

    ipv6Network = mkOption {
      description = " IPv6 network in CIDR format to use for the entire flannel network.";
      type = types.nullOr types.str;
    };

    nodeName = mkOption {
      description = ''
        Needed when running with Kubernetes as backend as this cannot be auto-detected";
      '';
      type = types.nullOr types.str;
      default = config.networking.fqdnOrHostName;
      defaultText = literalExpression "config.networking.fqdnOrHostName";
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

    ipv6SubnetLen = mkOption {
      description = ''
        The size of the ipv6 subnet allocated to each host. Defaults to 64 (i.e. /64)
        unless Ipv6Network was configured to be smaller than a /62 in which case
        it is two less than the network.
      '';
      type = types.int;
      default = 24;
    };

    ipv6SubnetMin = mkOption {
      description = ''
        The beginning of IPv6 range which the subnet allocation should start with.
        Defaults to the second subnet of Ipv6Network.
      '';
      type = types.nullOr types.str;
      default = null;
    };

    ipv6SubnetMax = mkOption {
      description = ''
        The end of the IPv6 range at which the subnet allocation should end with.
        Defaults to the last subnet of Ipv6Network.
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
        ETCDCTL_CERT = cfg.etcd.certFile;
        ETCDCTL_KEY = cfg.etcd.keyFile;
        ETCDCTL_CACERT = cfg.etcd.caFile;
        ETCDCTL_ENDPOINTS = concatStringsSep "," cfg.etcd.endpoints;
        ETCDCTL_API = "3";
      } // optionalAttrs (cfg.storageBackend == "kubernetes") {
        FLANNELD_KUBE_SUBNET_MGR = "true";
        FLANNELD_KUBECONFIG_FILE = cfg.kubeconfig;
        NODE_NAME = cfg.nodeName;
      };
      path = [ pkgs.iptables ];
      preStart = optionalString (cfg.storageBackend == "etcd") ''
        echo "setting network configuration"
        until ${pkgs.etcd}/bin/etcdctl put /coreos.com/network/config '${builtins.toJSON networkConfig}'
        do
          echo "setting network configuration, retry"
          sleep 1
        done
      '';
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/flannel";
        Restart = "always";
        RestartSec = "10s";
        RuntimeDirectory = "flannel";
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
