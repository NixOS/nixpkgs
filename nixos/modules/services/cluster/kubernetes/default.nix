{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.kubernetes;

  mkKubeConfig = name: conf: pkgs.writeText "${name}-kubeconfig" (builtins.toJSON {
    apiVersion = "v1";
    kind = "Config";
    clusters = [{
      name = "local";
      cluster.certificate-authority = conf.caFile or cfg.caFile;
      cluster.server = conf.server;
    }];
    users = [{
      inherit name;
      user = {
        client-certificate = conf.certFile;
        client-key = conf.keyFile;
      };
    }];
    contexts = [{
      context = {
        cluster = "local";
        user = name;
      };
      current-context = "local";
    }];
  });

  caCert = secret "ca";

  etcdEndpoints = ["https://${cfg.masterAddress}:2379"];

  mkCert = { name, CN, hosts ? [], fields ? {}, action ? "",
             privateKeyOwner ? "kubernetes" }: rec {
    inherit name caCert CN hosts fields action;
    cert = secret name;
    key = secret "${name}-key";
    privateKeyOptions = {
      owner = privateKeyOwner;
      group = "nogroup";
      mode = "0600";
      path = key;
    };
  };

  secret = name: "${cfg.secretsPath}/${name}.pem";

  mkKubeConfigOptions = prefix: {
    server = mkOption {
      description = "${prefix} kube-apiserver server address.";
      type = types.str;
    };

    caFile = mkOption {
      description = "${prefix} certificate authority file used to connect to kube-apiserver.";
      type = types.nullOr types.path;
      default = cfg.caFile;
    };

    certFile = mkOption {
      description = "${prefix} client certificate file used to connect to kube-apiserver.";
      type = types.nullOr types.path;
      default = null;
    };

    keyFile = mkOption {
      description = "${prefix} client key file used to connect to kube-apiserver.";
      type = types.nullOr types.path;
      default = null;
    };
  };

  kubeConfigDefaults = {
    server = mkDefault cfg.kubeconfig.server;
    caFile = mkDefault cfg.kubeconfig.caFile;
    certFile = mkDefault cfg.kubeconfig.certFile;
    keyFile = mkDefault cfg.kubeconfig.keyFile;
  };
in {

  ###### interface

  options.services.kubernetes = {
    roles = mkOption {
      description = ''
        Kubernetes role that this machine should take.

        Master role will enable etcd, apiserver, scheduler, controller manager
        addon manager, flannel and proxy services.
        Node role will enable flannel, docker, kubelet and proxy services.
      '';
      default = [];
      type = types.listOf (types.enum ["master" "node"]);
    };

    package = mkOption {
      description = "Kubernetes package to use.";
      type = types.package;
      default = pkgs.kubernetes;
      defaultText = "pkgs.kubernetes";
    };

    kubeconfig = mkKubeConfigOptions "Default kubeconfig";

    apiserverAddress = mkOption {
      description = ''
        Clusterwide accessible address for the kubernetes apiserver,
        including protocol and optional port.
      '';
      example = "https://kubernetes-apiserver.example.com:6443";
      type = types.str;
    };

    caFile = mkOption {
      description = "Default kubernetes certificate authority";
      type = types.nullOr types.path;
      default = null;
    };

    dataDir = mkOption {
      description = "Kubernetes root directory for managing kubelet files.";
      default = "/var/lib/kubernetes";
      type = types.path;
    };

    easyCerts = mkOption {
      description = "Automatically setup x509 certificates and keys for the entire cluster.";
      default = false;
      type = types.bool;
    };

    featureGates = mkOption {
      description = "List set of feature gates.";
      default = [];
      type = types.listOf types.str;
    };

    masterAddress = mkOption {
      description = "Clusterwide available network address or hostname for the kubernetes master server.";
      example = "master.example.com";
      type = types.str;
    };

    path = mkOption {
      description = "Packages added to the services' PATH environment variable. Both the bin and sbin subdirectories of each package are added.";
      type = types.listOf types.package;
      default = [];
    };

    clusterCidr = mkOption {
      description = "Kubernetes controller manager and proxy CIDR Range for Pods in cluster.";
      default = "10.1.0.0/16";
      type = types.nullOr types.str;
    };

    lib = mkOption {
      description = "Common functions for the kubernetes modules.";
      default = {
        inherit mkCert;
        inherit mkKubeConfig;
        inherit mkKubeConfigOptions;
      };
      type = types.attrs;
    };

    secretsPath = mkOption {
      description = "Default location for kubernetes secrets. Not a store location.";
      type = types.path;
      default = cfg.dataDir + "/secrets";
    };
  };

  ###### implementation

  config = mkMerge [

    (mkIf cfg.easyCerts {
      services.kubernetes.pki.enable = mkDefault true;
      services.kubernetes.caFile = caCert;
    })

    (mkIf (elem "master" cfg.roles) {
      services.kubernetes.apiserver.enable = mkDefault true;
      services.kubernetes.scheduler.enable = mkDefault true;
      services.kubernetes.controllerManager.enable = mkDefault true;
      services.kubernetes.addonManager.enable = mkDefault true;
      services.kubernetes.proxy.enable = mkDefault true;
      services.etcd.enable = true; # Cannot mkDefault because of flannel default options
      services.kubernetes.kubelet = {
        enable = mkDefault true;
        taints = mkIf (!(elem "node" cfg.roles)) {
          master = {
            key = "node-role.kubernetes.io/master";
            value = "true";
            effect = "NoSchedule";
          };
        };
      };
    })


    (mkIf (all (el: el == "master") cfg.roles) {
      # if this node is only a master make it unschedulable by default
      services.kubernetes.kubelet.unschedulable = mkDefault true;
    })

    (mkIf (elem "node" cfg.roles) {
      services.kubernetes.kubelet.enable = mkDefault true;
      services.kubernetes.proxy.enable = mkDefault true;
    })

    # Using "services.kubernetes.roles" will automatically enable easyCerts and flannel
    (mkIf (cfg.roles != []) {
      services.kubernetes.flannel.enable = mkDefault true;
      services.flannel.etcd.endpoints = mkDefault etcdEndpoints;
      services.kubernetes.easyCerts = mkDefault true;
    })

    (mkIf cfg.apiserver.enable {
      services.kubernetes.pki.etcClusterAdminKubeconfig = mkDefault "kubernetes/cluster-admin.kubeconfig";
      services.kubernetes.apiserver.etcd.servers = mkDefault etcdEndpoints;
    })

    (mkIf cfg.kubelet.enable {
      virtualisation.docker = {
        enable = mkDefault true;

        # kubernetes needs access to logs
        logDriver = mkDefault "json-file";

        # iptables must be disabled for kubernetes
        extraOptions = "--iptables=false --ip-masq=false";
      };
    })

    (mkIf (cfg.apiserver.enable || cfg.controllerManager.enable) {
      services.kubernetes.pki.certs = {
        serviceAccount = mkCert {
          name = "service-account";
          CN = "system:service-account-signer";
          action = ''
            systemctl reload \
              kube-apiserver.service \
              kube-controller-manager.service
          '';
        };
      };
    })

    (mkIf (
        cfg.apiserver.enable ||
        cfg.scheduler.enable ||
        cfg.controllerManager.enable ||
        cfg.kubelet.enable ||
        cfg.proxy.enable ||
        cfg.addonManager.enable
    ) {
      systemd.targets.kubernetes = {
        description = "Kubernetes";
        wantedBy = [ "multi-user.target" ];
      };

      systemd.targets.kube-control-plane-online = {
        wantedBy = [ "kubernetes.target" ];
        before = [ "kubernetes.target" ];
      };

      systemd.services.kube-control-plane-online = rec {
        description = "Kubernetes control plane is online";
        wantedBy = [ "kube-control-plane-online.target" ];
        after = [ "kube-scheduler.service" "kube-controller-manager.service" ];
        before = [ "kube-control-plane-online.target" ];
        path = [ pkgs.curl ];
        preStart = ''
          until curl -Ssf ${cfg.apiserverAddress}/healthz do
            echo curl -Ssf ${cfg.apiserverAddress}/healthz: exit status $?
            sleep 3
          done
        '';
        script = "echo Ok";
        serviceConfig = {
          TimeoutSec = "500";
        };
      };

      systemd.tmpfiles.rules = [
        "d /opt/cni/bin 0755 root root -"
        "d /run/kubernetes 0755 kubernetes kubernetes -"
        "d /var/lib/kubernetes 0755 kubernetes kubernetes -"
      ];

      users.users = singleton {
        name = "kubernetes";
        uid = config.ids.uids.kubernetes;
        description = "Kubernetes user";
        extraGroups = [ "docker" ];
        group = "kubernetes";
        home = cfg.dataDir;
        createHome = true;
      };
      users.groups.kubernetes.gid = config.ids.gids.kubernetes;

      # dns addon is enabled by default
      services.kubernetes.addons.dns.enable = mkDefault true;

      services.kubernetes.apiserverAddress = mkDefault ("https://${if cfg.apiserver.advertiseAddress != null
                          then cfg.apiserver.advertiseAddress
                          else "${cfg.masterAddress}:${toString cfg.apiserver.securePort}"}");

      services.kubernetes.kubeconfig.server = mkDefault cfg.apiserverAddress;
    })
  ];
}
