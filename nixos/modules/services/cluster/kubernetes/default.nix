{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.services.kubernetes;
  opt = options.services.kubernetes;

  defaultContainerdSettings = {
    version = 2;
    root = "/var/lib/containerd";
    state = "/run/containerd";
    oom_score = 0;

    grpc = {
      address = "/run/containerd/containerd.sock";
    };

    plugins."io.containerd.grpc.v1.cri" = {
      sandbox_image = "pause:latest";

      cni = {
        bin_dir = "/opt/cni/bin";
        max_conf_num = 0;
      };

      containerd.runtimes.runc = {
        runtime_type = "io.containerd.runc.v2";
        options.SystemdCgroup = true;
      };
    };
  };

  mkKubeConfig =
    name: conf:
    pkgs.writeText "${name}-kubeconfig" (
      builtins.toJSON {
        apiVersion = "v1";
        kind = "Config";
        clusters = [
          {
            name = "local";
            cluster.certificate-authority = conf.caFile or cfg.caFile;
            cluster.server = conf.server;
          }
        ];
        users = [
          {
            inherit name;
            user = {
              client-certificate = conf.certFile;
              client-key = conf.keyFile;
            };
          }
        ];
        contexts = [
          {
            context = {
              cluster = "local";
              user = name;
            };
            name = "local";
          }
        ];
        current-context = "local";
      }
    );

  caCert = secret "ca";

  etcdEndpoints = [ "https://${cfg.masterAddress}:2379" ];

  mkCert =
    {
      name,
      CN,
      hosts ? [ ],
      fields ? { },
      action ? "",
      privateKeyOwner ? "kubernetes",
      privateKeyGroup ? "kubernetes",
    }:
    rec {
      inherit
        name
        caCert
        CN
        hosts
        fields
        action
        ;
      cert = secret name;
      key = secret "${name}-key";
      privateKeyOptions = {
        owner = privateKeyOwner;
        group = privateKeyGroup;
        mode = "0600";
        path = key;
      };
    };

  secret = name: "${cfg.secretsPath}/${name}.pem";

  mkKubeConfigOptions = prefix: {
    server = lib.mkOption {
      description = "${prefix} kube-apiserver server address.";
      type = lib.types.str;
    };

    caFile = lib.mkOption {
      description = "${prefix} certificate authority file used to connect to kube-apiserver.";
      type = lib.types.nullOr lib.types.path;
      default = cfg.caFile;
      defaultText = lib.literalExpression "config.${opt.caFile}";
    };

    certFile = lib.mkOption {
      description = "${prefix} client certificate file used to connect to kube-apiserver.";
      type = lib.types.nullOr lib.types.path;
      default = null;
    };

    keyFile = lib.mkOption {
      description = "${prefix} client key file used to connect to kube-apiserver.";
      type = lib.types.nullOr lib.types.path;
      default = null;
    };
  };
in
{

  imports = [
    (lib.mkRemovedOptionModule [
      "services"
      "kubernetes"
      "addons"
      "dashboard"
    ] "Removed due to it being an outdated version")
    (lib.mkRemovedOptionModule [ "services" "kubernetes" "verbose" ] "")
  ];

  ###### interface

  options.services.kubernetes = {
    roles = lib.mkOption {
      description = ''
        Kubernetes role that this machine should take.

        Master role will enable etcd, apiserver, scheduler, controller manager
        addon manager, flannel and proxy services.
        Node role will enable flannel, docker, kubelet and proxy services.
      '';
      default = [ ];
      type = lib.types.listOf (
        lib.types.enum [
          "master"
          "node"
        ]
      );
    };

    package = lib.mkPackageOption pkgs "kubernetes" { };

    kubeconfig = mkKubeConfigOptions "Default kubeconfig";

    apiserverAddress = lib.mkOption {
      description = ''
        Clusterwide accessible address for the kubernetes apiserver,
        including protocol and optional port.
      '';
      example = "https://kubernetes-apiserver.example.com:6443";
      type = lib.types.str;
    };

    caFile = lib.mkOption {
      description = "Default kubernetes certificate authority";
      type = lib.types.nullOr lib.types.path;
      default = null;
    };

    dataDir = lib.mkOption {
      description = "Kubernetes root directory for managing kubelet files.";
      default = "/var/lib/kubernetes";
      type = lib.types.path;
    };

    easyCerts = lib.mkOption {
      description = "Automatically setup x509 certificates and keys for the entire cluster.";
      default = false;
      type = lib.types.bool;
    };

    featureGates = lib.mkOption {
      description = "List set of feature gates.";
      default = { };
      type = lib.types.attrsOf lib.types.bool;
    };

    masterAddress = lib.mkOption {
      description = "Clusterwide available network address or hostname for the kubernetes master server.";
      example = "master.example.com";
      type = lib.types.str;
    };

    path = lib.mkOption {
      description = "Packages added to the services' PATH environment variable. Both the bin and sbin subdirectories of each package are added.";
      type = lib.types.listOf lib.types.package;
      default = [ ];
    };

    clusterCidr = lib.mkOption {
      description = "Kubernetes controller manager and proxy CIDR Range for Pods in cluster.";
      default = "10.1.0.0/16";
      type = lib.types.nullOr lib.types.str;
    };

    lib = lib.mkOption {
      description = "Common functions for the kubernetes modules.";
      default = {
        inherit mkCert;
        inherit mkKubeConfig;
        inherit mkKubeConfigOptions;
      };
      type = lib.types.attrs;
    };

    secretsPath = lib.mkOption {
      description = "Default location for kubernetes secrets. Not a store location.";
      type = lib.types.path;
      default = cfg.dataDir + "/secrets";
      defaultText = lib.literalExpression ''
        config.${opt.dataDir} + "/secrets"
      '';
    };
  };

  ###### implementation

  config = lib.mkMerge [

    (lib.mkIf cfg.easyCerts {
      services.kubernetes.pki.enable = lib.mkDefault true;
      services.kubernetes.caFile = caCert;
    })

    (lib.mkIf (lib.elem "master" cfg.roles) {
      services.kubernetes.apiserver.enable = lib.mkDefault true;
      services.kubernetes.scheduler.enable = lib.mkDefault true;
      services.kubernetes.controllerManager.enable = lib.mkDefault true;
      services.kubernetes.addonManager.enable = lib.mkDefault true;
      services.kubernetes.proxy.enable = lib.mkDefault true;
      services.etcd.enable = true; # Cannot mkDefault because of flannel default options
      services.kubernetes.kubelet = {
        enable = lib.mkDefault true;
        taints = lib.mkIf (!(lib.elem "node" cfg.roles)) {
          master = {
            key = "node-role.kubernetes.io/master";
            value = "true";
            effect = "NoSchedule";
          };
        };
      };
    })

    (lib.mkIf (lib.all (el: el == "master") cfg.roles) {
      # if this node is only a master make it unschedulable by default
      services.kubernetes.kubelet.unschedulable = lib.mkDefault true;
    })

    (lib.mkIf (lib.elem "node" cfg.roles) {
      services.kubernetes.kubelet.enable = lib.mkDefault true;
      services.kubernetes.proxy.enable = lib.mkDefault true;
    })

    # Using "services.kubernetes.roles" will automatically enable easyCerts and flannel
    (lib.mkIf (cfg.roles != [ ]) {
      services.kubernetes.flannel.enable = lib.mkDefault true;
      services.flannel.etcd.endpoints = lib.mkDefault etcdEndpoints;
      services.kubernetes.easyCerts = lib.mkDefault true;
    })

    (lib.mkIf cfg.apiserver.enable {
      services.kubernetes.pki.etcClusterAdminKubeconfig = lib.mkDefault "kubernetes/cluster-admin.kubeconfig";
      services.kubernetes.apiserver.etcd.servers = lib.mkDefault etcdEndpoints;
    })

    (lib.mkIf cfg.kubelet.enable {
      virtualisation.containerd = {
        enable = lib.mkDefault true;
        settings = lib.mapAttrsRecursive (name: lib.mkDefault) defaultContainerdSettings;
      };
    })

    (lib.mkIf (cfg.apiserver.enable || cfg.controllerManager.enable) {
      services.kubernetes.pki.certs = {
        serviceAccount = mkCert {
          name = "service-account";
          CN = "system:service-account-signer";
          action = ''
            systemctl restart \
              kube-apiserver.service \
              kube-controller-manager.service
          '';
        };
      };
    })

    (lib.mkIf
      (
        cfg.apiserver.enable
        || cfg.scheduler.enable
        || cfg.controllerManager.enable
        || cfg.kubelet.enable
        || cfg.proxy.enable
        || cfg.addonManager.enable
      )
      {
        systemd.targets.kubernetes = {
          description = "Kubernetes";
          wantedBy = [ "multi-user.target" ];
        };

        systemd.tmpfiles.rules = [
          "d /opt/cni/bin 0755 root root -"
          "d /run/kubernetes 0755 kubernetes kubernetes -"
          "d ${cfg.dataDir} 0755 kubernetes kubernetes -"
        ];

        users.users.kubernetes = {
          uid = config.ids.uids.kubernetes;
          description = "Kubernetes user";
          group = "kubernetes";
          home = cfg.dataDir;
          createHome = true;
          homeMode = "755";
        };
        users.groups.kubernetes.gid = config.ids.gids.kubernetes;

        # dns addon is enabled by default
        services.kubernetes.addons.dns.enable = lib.mkDefault true;

        services.kubernetes.apiserverAddress = lib.mkDefault (
          "https://${
            if cfg.apiserver.advertiseAddress != null then
              cfg.apiserver.advertiseAddress
            else
              "${cfg.masterAddress}:${toString cfg.apiserver.securePort}"
          }"
        );
      }
    )
  ];

  meta.buildDocsInSandbox = false;
}
