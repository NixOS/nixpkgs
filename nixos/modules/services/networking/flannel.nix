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
    enable = mkEnableOption (lib.mdDoc "flannel");

    package = mkOption {
      description = lib.mdDoc "Package to use for flannel";
      type = types.package;
      default = pkgs.flannel;
      defaultText = literalExpression "pkgs.flannel";
    };

    publicIp = mkOption {
      description = lib.mdDoc ''
        IP accessible by other nodes for inter-host communication.
        Defaults to the IP of the interface being used for communication.
      '';
      type = types.nullOr types.str;
      default = null;
    };

    iface = mkOption {
      description = lib.mdDoc ''
        Interface to use (IP or name) for inter-host communication.
        Defaults to the interface for the default route on the machine.
      '';
      type = types.nullOr types.str;
      default = null;
    };

    etcd = {
      endpoints = mkOption {
        description = lib.mdDoc "Etcd endpoints";
        type = types.listOf types.str;
        default = ["http://127.0.0.1:2379"];
      };

      prefix = mkOption {
        description = lib.mdDoc "Etcd key prefix";
        type = types.str;
        default = "/coreos.com/network";
      };

      caFile = mkOption {
        description = lib.mdDoc "Etcd certificate authority file";
        type = types.nullOr types.path;
        default = null;
      };

      certFile = mkOption {
        description = lib.mdDoc "Etcd cert file";
        type = types.nullOr types.path;
        default = null;
      };

      keyFile = mkOption {
        description = lib.mdDoc "Etcd key file";
        type = types.nullOr types.path;
        default = null;
      };
    };

    kubeconfig = mkOption {
      description = lib.mdDoc ''
        Path to kubeconfig to use for storing flannel config using the
        Kubernetes API
      '';
      type = types.nullOr types.path;
      default = null;
    };

    network = mkOption {
      description = lib.mdDoc " IPv4 network in CIDR format to use for the entire flannel network.";
      type = types.str;
    };

    nodeName = mkOption {
      description = lib.mdDoc ''
        Needed when running with Kubernetes as backend as this cannot be auto-detected";
      '';
      type = types.nullOr types.str;
      default = with config.networking; (hostName + optionalString (domain != null) ".${domain}");
      defaultText = literalExpression ''
        with config.networking; (hostName + optionalString (domain != null) ".''${domain}")
      '';
      example = "node1.example.com";
    };

    storageBackend = mkOption {
      description = lib.mdDoc "Determines where flannel stores its configuration at runtime";
      type = types.enum ["etcd" "kubernetes"];
      default = "etcd";
    };

    subnetLen = mkOption {
      description = lib.mdDoc ''
        The size of the subnet allocated to each host. Defaults to 24 (i.e. /24)
        unless the Network was configured to be smaller than a /24 in which case
        it is one less than the network.
      '';
      type = types.int;
      default = 24;
    };

    subnetMin = mkOption {
      description = lib.mdDoc ''
        The beginning of IP range which the subnet allocation should start with.
        Defaults to the first subnet of Network.
      '';
      type = types.nullOr types.str;
      default = null;
    };

    subnetMax = mkOption {
      description = lib.mdDoc ''
        The end of IP range which the subnet allocation should start with.
        Defaults to the last subnet of Network.
      '';
      type = types.nullOr types.str;
      default = null;
    };

    backend = mkOption {
      description = lib.mdDoc "Type of backend to use and specific configurations for that backend.";
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
