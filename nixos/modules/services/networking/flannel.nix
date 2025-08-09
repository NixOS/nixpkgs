{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.flannel;

  networkConfig =
    (lib.filterAttrs (n: v: v != null) {
      Network = cfg.network;
      SubnetLen = cfg.subnetLen;
      SubnetMin = cfg.subnetMin;
      SubnetMax = cfg.subnetMax;
      Backend = cfg.backend;
    })
    // cfg.extraNetworkConfig;
in
{
  options.services.flannel = {
    enable = lib.mkEnableOption "flannel";

    package = lib.mkPackageOption pkgs "flannel" { };

    publicIp = lib.mkOption {
      description = ''
        IP accessible by other nodes for inter-host communication.
        Defaults to the IP of the interface being used for communication.
      '';
      type = lib.types.nullOr lib.types.str;
      default = null;
    };

    iface = lib.mkOption {
      description = ''
        Interface to use (IP or name) for inter-host communication.
        Defaults to the interface for the default route on the machine.
      '';
      type = lib.types.nullOr lib.types.str;
      default = null;
    };

    etcd = {
      endpoints = lib.mkOption {
        description = "Etcd endpoints";
        type = lib.types.listOf lib.types.str;
        default = [ "http://127.0.0.1:2379" ];
      };

      prefix = lib.mkOption {
        description = "Etcd key prefix";
        type = lib.types.str;
        default = "/coreos.com/network";
      };

      caFile = lib.mkOption {
        description = "Etcd certificate authority file";
        type = lib.types.nullOr lib.types.path;
        default = null;
      };

      certFile = lib.mkOption {
        description = "Etcd cert file";
        type = lib.types.nullOr lib.types.path;
        default = null;
      };

      keyFile = lib.mkOption {
        description = "Etcd key file";
        type = lib.types.nullOr lib.types.path;
        default = null;
      };
    };

    kubeconfig = lib.mkOption {
      description = ''
        Path to kubeconfig to use for storing flannel config using the
        Kubernetes API
      '';
      type = lib.types.nullOr lib.types.path;
      default = null;
    };

    network = lib.mkOption {
      description = "IPv4 network in CIDR format to use for the entire flannel network";
      type = lib.types.str;
    };

    nodeName = lib.mkOption {
      description = ''
        Needed when running with Kubernetes as backend as this cannot be auto-detected";
      '';
      type = lib.types.nullOr lib.types.str;
      default = config.networking.fqdnOrHostName;
      defaultText = lib.literalExpression "config.networking.fqdnOrHostName";
      example = "node1.example.com";
    };

    storageBackend = lib.mkOption {
      description = "Determines where flannel stores its configuration at runtime";
      type = lib.types.enum [
        "etcd"
        "kubernetes"
      ];
      default = "etcd";
    };

    subnetLen = lib.mkOption {
      description = ''
        The size of the subnet allocated to each host. Defaults to 24 (i.e. /24)
        unless the Network was configured to be smaller than a /24 in which case
        it is one less than the network.
      '';
      type = lib.types.int;
      default = 24;
    };

    subnetMin = lib.mkOption {
      description = ''
        The beginning of IP range which the subnet allocation should start with.
        Defaults to the first subnet of Network.
      '';
      type = lib.types.nullOr lib.types.str;
      default = null;
    };

    subnetMax = lib.mkOption {
      description = ''
        The end of IP range which the subnet allocation should start with.
        Defaults to the last subnet of Network.
      '';
      type = lib.types.nullOr lib.types.str;
      default = null;
    };

    backend = lib.mkOption {
      description = "Type of backend to use and specific configurations for that backend.";
      type = lib.types.attrs;
      default = {
        Type = "vxlan";
      };
    };

    extraNetworkConfig = lib.mkOption {
      description = "Extra configuration to be added to the net-conf.json/etcd-backed network configuration.";
      type = (pkgs.formats.json { }).type;
      default = { };
      example = {
        EnableIPv6 = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.flannel = {
      description = "Flannel Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = {
        FLANNELD_PUBLIC_IP = cfg.publicIp;
        FLANNELD_IFACE = cfg.iface;
      }
      // lib.optionalAttrs (cfg.storageBackend == "etcd") {
        FLANNELD_ETCD_ENDPOINTS = lib.concatStringsSep "," cfg.etcd.endpoints;
        FLANNELD_ETCD_KEYFILE = cfg.etcd.keyFile;
        FLANNELD_ETCD_CERTFILE = cfg.etcd.certFile;
        FLANNELD_ETCD_CAFILE = cfg.etcd.caFile;
        ETCDCTL_CERT = cfg.etcd.certFile;
        ETCDCTL_KEY = cfg.etcd.keyFile;
        ETCDCTL_CACERT = cfg.etcd.caFile;
        ETCDCTL_ENDPOINTS = lib.concatStringsSep "," cfg.etcd.endpoints;
        ETCDCTL_API = "3";
      }
      // lib.optionalAttrs (cfg.storageBackend == "kubernetes") {
        FLANNELD_KUBE_SUBNET_MGR = "true";
        FLANNELD_KUBECONFIG_FILE = cfg.kubeconfig;
        NODE_NAME = cfg.nodeName;
      };
      path = [ pkgs.iptables ];
      preStart = lib.optionalString (cfg.storageBackend == "etcd") ''
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

    boot.kernelModules = [ "br_netfilter" ];

    services.etcd.enable = lib.mkDefault (
      cfg.storageBackend == "etcd" && cfg.etcd.endpoints == [ "http://127.0.0.1:2379" ]
    );

    # for some reason, flannel doesn't let you configure this path
    # see: https://github.com/coreos/flannel/blob/master/Documentation/configuration.md#configuration
    environment.etc."kube-flannel/net-conf.json" = lib.mkIf (cfg.storageBackend == "kubernetes") {
      source = pkgs.writeText "net-conf.json" (builtins.toJSON networkConfig);
    };
  };
}
