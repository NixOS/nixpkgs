{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.kubernetes;

  skipAttrs = attrs: map (filterAttrs (k: v: k != "enable"))
    (filter (v: !(hasAttr "enable" v) || v.enable) attrs);

  infraContainer = pkgs.dockerTools.buildImage {
    name = "pause";
    tag = "latest";
    contents = cfg.package.pause;
    config.Cmd = "/bin/pause";
  };

  mkKubeConfig = name: cfg: pkgs.writeText "${name}-kubeconfig" (builtins.toJSON {
    apiVersion = "v1";
    kind = "Config";
    clusters = [{
      name = "local";
      cluster.certificate-authority = cfg.caFile;
      cluster.server = cfg.server;
    }];
    users = [{
      name = "kubelet";
      user = {
        client-certificate = cfg.certFile;
        client-key = cfg.keyFile;
      };
    }];
    contexts = [{
      context = {
        cluster = "local";
        user = "kubelet";
      };
      current-context = "kubelet-context";
    }];
  });

  mkKubeConfigOptions = prefix: {
    server = mkOption {
      description = "${prefix} kube-apiserver server address.";
      default = "http://${cfg.apiserver.address}:${toString cfg.apiserver.port}";
      type = types.str;
    };

    caFile = mkOption {
      description = "${prefix} certificate authrority file used to connect to kube-apiserver.";
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

  cniConfig = pkgs.buildEnv {
    name = "kubernetes-cni-config";
    paths = imap (i: entry:
      pkgs.writeTextDir "${toString (10+i)}-${entry.type}.conf" (builtins.toJSON entry)
    ) cfg.kubelet.cni.config;
  };

  manifests = pkgs.buildEnv {
    name = "kubernetes-manifests";
    paths = mapAttrsToList (name: manifest:
      pkgs.writeTextDir "${name}.json" (builtins.toJSON manifest)
    ) cfg.kubelet.manifests;
  };

  addons = pkgs.runCommand "kubernetes-addons" { } ''
    mkdir -p $out
    # since we are mounting the addons to the addon manager, they need to be copied
    ${concatMapStringsSep ";" (a: "cp -v ${a}/* $out/") (mapAttrsToList (name: addon:
      pkgs.writeTextDir "${name}.json" (builtins.toJSON addon)
    ) (cfg.addonManager.addons))}
  '';

  taintOptions = { name, ... }: {
    options = {
      key = mkOption {
        description = "Key of taint.";
        default = name;
        type = types.str;
      };
      value = mkOption {
        description = "Value of taint.";
        type = types.str;
      };
      effect = mkOption {
        description = "Effect of taint.";
        example = "NoSchedule";
        type = types.enum ["NoSchedule" "PreferNoSchedule" "NoExecute"];
      };
    };
  };

  taints = concatMapStringsSep "," (v: "${v.key}=${v.value}:${v.effect}") (mapAttrsToList (n: v: v) cfg.kubelet.taints);

  # needed for flannel to pass options to docker
  mkDockerOpts = pkgs.runCommand "mk-docker-opts" {
    buildInputs = [ pkgs.makeWrapper ];
  } ''
    mkdir -p $out
    cp ${pkgs.kubernetes.src}/cluster/centos/node/bin/mk-docker-opts.sh $out/mk-docker-opts.sh

    # bashInteractive needed for `compgen`
    makeWrapper ${pkgs.bashInteractive}/bin/bash $out/mk-docker-opts --add-flags "$out/mk-docker-opts.sh"
  '';
in {

  ###### interface

  options.services.kubernetes = {
    roles = mkOption {
      description = ''
        Kubernetes role that this machine should take.

        Master role will enable etcd, apiserver, scheduler and controller manager
        services. Node role will enable etcd, docker, kubelet and proxy services.
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

    verbose = mkOption {
      description = "Kubernetes enable verbose mode for debugging.";
      default = false;
      type = types.bool;
    };

    etcd = {
      servers = mkOption {
        description = "List of etcd servers. By default etcd is started, except if this option is changed.";
        default = ["http://127.0.0.1:2379"];
        type = types.listOf types.str;
      };

      keyFile = mkOption {
        description = "Etcd key file.";
        default = null;
        type = types.nullOr types.path;
      };

      certFile = mkOption {
        description = "Etcd cert file.";
        default = null;
        type = types.nullOr types.path;
      };

      caFile = mkOption {
        description = "Etcd ca file.";
        default = cfg.caFile;
        type = types.nullOr types.path;
      };
    };

    kubeconfig = mkKubeConfigOptions "Default kubeconfig";

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

    apiserver = {
      enable = mkOption {
        description = "Whether to enable Kubernetes apiserver.";
        default = false;
        type = types.bool;
      };

      address = mkOption {
        description = "Kubernetes apiserver listening address.";
        default = "127.0.0.1";
        type = types.str;
      };

      publicAddress = mkOption {
        description = ''
          Kubernetes apiserver public listening address used for read only and
          secure port.
        '';
        default = cfg.apiserver.address;
        type = types.str;
      };

      advertiseAddress = mkOption {
        description = ''
          Kubernetes apiserver IP address on which to advertise the apiserver
          to members of the cluster. This address must be reachable by the rest
          of the cluster.
        '';
        default = null;
        type = types.nullOr types.str;
      };

      storageBackend = mkOption {
        description = ''
          Kubernetes apiserver storage backend.
        '';
        default = "etcd3";
        type = types.enum ["etcd2" "etcd3"];
      };

      port = mkOption {
        description = "Kubernetes apiserver listening port.";
        default = 8080;
        type = types.int;
      };

      securePort = mkOption {
        description = "Kubernetes apiserver secure port.";
        default = 443;
        type = types.int;
      };

      tlsCertFile = mkOption {
        description = "Kubernetes apiserver certificate file.";
        default = null;
        type = types.nullOr types.path;
      };

      tlsKeyFile = mkOption {
        description = "Kubernetes apiserver private key file.";
        default = null;
        type = types.nullOr types.path;
      };

      clientCaFile = mkOption {
        description = "Kubernetes apiserver CA file for client auth.";
        default = cfg.caFile;
        type = types.nullOr types.path;
      };

      tokenAuthFile = mkOption {
        description = ''
          Kubernetes apiserver token authentication file. See
          <link xlink:href="http://kubernetes.io/docs/admin/authentication.html"/>
        '';
        default = null;
        type = types.nullOr types.path;
      };

      basicAuthFile = mkOption {
        description = ''
          Kubernetes apiserver basic authentication file. See
          <link xlink:href="http://kubernetes.io/docs/admin/authentication.html"/>
        '';
        default = pkgs.writeText "users" ''
          kubernetes,admin,0
        '';
        type = types.nullOr types.path;
      };

      authorizationMode = mkOption {
        description = ''
          Kubernetes apiserver authorization mode (AlwaysAllow/AlwaysDeny/ABAC/RBAC). See
          <link xlink:href="http://kubernetes.io/docs/admin/authorization.html"/>
        '';
        default = ["RBAC"];
        type = types.listOf (types.enum ["AlwaysAllow" "AlwaysDeny" "ABAC" "RBAC"]);
      };

      authorizationPolicy = mkOption {
        description = ''
          Kubernetes apiserver authorization policy file. See
          <link xlink:href="http://kubernetes.io/v1.0/docs/admin/authorization.html"/>
        '';
        default = [];
        type = types.listOf types.attrs;
      };

      allowPrivileged = mkOption {
        description = "Whether to allow privileged containers on Kubernetes.";
        default = true;
        type = types.bool;
      };

      serviceClusterIpRange = mkOption {
        description = ''
          A CIDR notation IP range from which to assign service cluster IPs.
          This must not overlap with any IP ranges assigned to nodes for pods.
        '';
        default = "10.0.0.0/24";
        type = types.str;
      };

      runtimeConfig = mkOption {
        description = ''
          Api runtime configuration. See
          <link xlink:href="http://kubernetes.io/v1.0/docs/admin/cluster-management.html"/>
        '';
        default = "";
        example = "api/all=false,api/v1=true";
        type = types.str;
      };

      admissionControl = mkOption {
        description = ''
          Kubernetes admission control plugins to use. See
          <link xlink:href="http://kubernetes.io/docs/admin/admission-controllers/"/>
        '';
        default = ["NamespaceLifecycle" "LimitRanger" "ServiceAccount" "ResourceQuota" "DefaultStorageClass" "DefaultTolerationSeconds"];
        example = [
          "NamespaceLifecycle" "NamespaceExists" "LimitRanger"
          "SecurityContextDeny" "ServiceAccount" "ResourceQuota"
          "PodSecurityPolicy" "NodeRestriction" "DefaultStorageClass"
        ];
        type = types.listOf types.str;
      };

      serviceAccountKeyFile = mkOption {
        description = ''
          Kubernetes apiserver PEM-encoded x509 RSA private or public key file,
          used to verify ServiceAccount tokens. By default tls private key file
          is used.
        '';
        default = null;
        type = types.nullOr types.path;
      };

      kubeletClientCaFile = mkOption {
        description = "Path to a cert file for connecting to kubelet.";
        default = cfg.caFile;
        type = types.nullOr types.path;
      };

      kubeletClientCertFile = mkOption {
        description = "Client certificate to use for connections to kubelet.";
        default = null;
        type = types.nullOr types.path;
      };

      kubeletClientKeyFile = mkOption {
        description = "Key to use for connections to kubelet.";
        default = null;
        type = types.nullOr types.path;
      };

      kubeletHttps = mkOption {
        description = "Whether to use https for connections to kubelet.";
        default = true;
        type = types.bool;
      };

      extraOpts = mkOption {
        description = "Kubernetes apiserver extra command line options.";
        default = "";
        type = types.str;
      };
    };

    scheduler = {
      enable = mkOption {
        description = "Whether to enable Kubernetes scheduler.";
        default = false;
        type = types.bool;
      };

      address = mkOption {
        description = "Kubernetes scheduler listening address.";
        default = "127.0.0.1";
        type = types.str;
      };

      port = mkOption {
        description = "Kubernetes scheduler listening port.";
        default = 10251;
        type = types.int;
      };

      leaderElect = mkOption {
        description = "Whether to start leader election before executing main loop.";
        type = types.bool;
        default = true;
      };

      kubeconfig = mkKubeConfigOptions "Kubernetes scheduler";

      extraOpts = mkOption {
        description = "Kubernetes scheduler extra command line options.";
        default = "";
        type = types.str;
      };
    };

    controllerManager = {
      enable = mkOption {
        description = "Whether to enable Kubernetes controller manager.";
        default = false;
        type = types.bool;
      };

      address = mkOption {
        description = "Kubernetes controller manager listening address.";
        default = "127.0.0.1";
        type = types.str;
      };

      port = mkOption {
        description = "Kubernetes controller manager listening port.";
        default = 10252;
        type = types.int;
      };

      leaderElect = mkOption {
        description = "Whether to start leader election before executing main loop.";
        type = types.bool;
        default = true;
      };

      serviceAccountKeyFile = mkOption {
        description = ''
          Kubernetes controller manager PEM-encoded private RSA key file used to
          sign service account tokens
        '';
        default = null;
        type = types.nullOr types.path;
      };

      rootCaFile = mkOption {
        description = ''
          Kubernetes controller manager certificate authority file included in
          service account's token secret.
        '';
        default = cfg.caFile;
        type = types.nullOr types.path;
      };

      kubeconfig = mkKubeConfigOptions "Kubernetes controller manager";

      extraOpts = mkOption {
        description = "Kubernetes controller manager extra command line options.";
        default = "";
        type = types.str;
      };
    };

    kubelet = {
      enable = mkOption {
        description = "Whether to enable Kubernetes kubelet.";
        default = false;
        type = types.bool;
      };

      registerNode = mkOption {
        description = "Whether to auto register kubelet with API server.";
        default = true;
        type = types.bool;
      };

      address = mkOption {
        description = "Kubernetes kubelet info server listening address.";
        default = "0.0.0.0";
        type = types.str;
      };

      port = mkOption {
        description = "Kubernetes kubelet info server listening port.";
        default = 10250;
        type = types.int;
      };

      tlsCertFile = mkOption {
        description = "File containing x509 Certificate for HTTPS.";
        default = null;
        type = types.nullOr types.path;
      };

      tlsKeyFile = mkOption {
        description = "File containing x509 private key matching tlsCertFile.";
        default = null;
        type = types.nullOr types.path;
      };

      healthz = {
        bind = mkOption {
          description = "Kubernetes kubelet healthz listening address.";
          default = "127.0.0.1";
          type = types.str;
        };

        port = mkOption {
          description = "Kubernetes kubelet healthz port.";
          default = 10248;
          type = types.int;
        };
      };

      hostname = mkOption {
        description = "Kubernetes kubelet hostname override.";
        default = config.networking.hostName;
        type = types.str;
      };

      allowPrivileged = mkOption {
        description = "Whether to allow Kubernetes containers to request privileged mode.";
        default = true;
        type = types.bool;
      };

      cadvisorPort = mkOption {
        description = "Kubernetes kubelet local cadvisor port.";
        default = 4194;
        type = types.int;
      };

      clusterDns = mkOption {
        description = "Use alternative DNS.";
        default = "10.10.0.1";
        type = types.str;
      };

      clusterDomain = mkOption {
        description = "Use alternative domain.";
        default = "cluster.local";
        type = types.str;
      };

      networkPlugin = mkOption {
        description = "Network plugin to use by Kubernetes.";
        type = types.nullOr (types.enum ["cni" "kubenet"]);
        default = "kubenet";
      };

      cni = {
        packages = mkOption {
          description = "List of network plugin packages to install.";
          type = types.listOf types.package;
          default = [];
        };

        config = mkOption {
          description = "Kubernetes CNI configuration.";
          type = types.listOf types.attrs;
          default = [];
          example = literalExample ''
            [{
              "cniVersion": "0.2.0",
              "name": "mynet",
              "type": "bridge",
              "bridge": "cni0",
              "isGateway": true,
              "ipMasq": true,
              "ipam": {
                  "type": "host-local",
                  "subnet": "10.22.0.0/16",
                  "routes": [
                      { "dst": "0.0.0.0/0" }
                  ]
              }
            } {
              "cniVersion": "0.2.0",
              "type": "loopback"
            }]
          '';
        };
      };

      manifests = mkOption {
        description = "List of manifests to bootstrap with kubelet (only pods can be created as manifest entry)";
        type = types.attrsOf types.attrs;
        default = {};
      };

      applyManifests = mkOption {
        description = "Whether to apply manifests (this is true for master node).";
        default = false;
        type = types.bool;
      };

      unschedulable = mkOption {
        description = "Whether to set node taint to unschedulable=true as it is the case of node that has only master role.";
        default = false;
        type = types.bool;
      };

      taints = mkOption {
        description = "Node taints (https://kubernetes.io/docs/concepts/configuration/assign-pod-node/).";
        default = {};
        type = types.attrsOf (types.submodule [ taintOptions ]);
      };

      nodeIp = mkOption {
        description = "IP address of the node. If set, kubelet will use this IP address for the node.";
        default = null;
        type = types.nullOr types.str;
      };

      kubeconfig = mkKubeConfigOptions "Kubelet";

      extraOpts = mkOption {
        description = "Kubernetes kubelet extra command line options.";
        default = "";
        type = types.str;
      };
    };

    proxy = {
      enable = mkOption {
        description = "Whether to enable Kubernetes proxy.";
        default = false;
        type = types.bool;
      };

      address = mkOption {
        description = "Kubernetes proxy listening address.";
        default = "0.0.0.0";
        type = types.str;
      };

      kubeconfig = mkKubeConfigOptions "Kubernetes proxy";

      extraOpts = mkOption {
        description = "Kubernetes proxy extra command line options.";
        default = "";
        type = types.str;
      };
    };

    addonManager = {
      enable = mkOption {
        description = "Whether to enable Kubernetes addon manager.";
        default = false;
        type = types.bool;
      };

      versionTag = mkOption {
        description = "Version tag of Kubernetes addon manager image.";
        default = "v6.4-beta.1";
        type = types.str;
      };

      addons = mkOption {
        description = "Kubernetes addons (any kind of Kubernetes resource can be an addon).";
        default = { };
        type = types.attrsOf types.attrs;
        example = literalExample ''
          {
            "my-service" = {
              "apiVersion" = "v1";
              "kind" = "Service";
              "metadata" = {
                "name" = "my-service";
                "namespace" = "default";
              };
              "spec" = { ... };
            };
          }
          // import <nixpkgs/nixos/modules/services/cluster/kubernetes/dashboard.nix> { cfg = config.services.kubernetes; };
        '';
      };
    };

    dns = {
      enable = mkEnableOption "Kubernetes DNS service.";

      port = mkOption {
        description = "Kubernetes DNS listening port.";
        default = 53;
        type = types.int;
      };

      domain = mkOption  {
        description = "Kubernetes DNS domain under which to create names.";
        default = cfg.kubelet.clusterDomain;
        type = types.str;
      };

      kubeconfig = mkKubeConfigOptions "Kubernetes dns";

      extraOpts = mkOption {
        description = "Kubernetes DNS extra command line options.";
        default = "";
        type = types.str;
      };
    };

    path = mkOption {
      description = "Packages added to the services' PATH environment variable. Both the bin and sbin subdirectories of each package are added.";
      type = types.listOf types.package;
      default = [];
    };

    clusterCidr = mkOption {
      description = "Kubernetes controller manager and proxy CIDR Range for Pods in cluster.";
      default = "10.1.0.0/16";
      type = types.str;
    };

    flannel.enable = mkOption {
      description = "Whether to enable flannel networking";
      default = false;
      type = types.bool;
    };

  };

  ###### implementation

  config = mkMerge [
    (mkIf cfg.kubelet.enable {
      systemd.services.kubelet = {
        description = "Kubernetes Kubelet Service";
        wantedBy = [ "kubernetes.target" ];
        after = [ "network.target" "docker.service" "kube-apiserver.service" ];
        path = with pkgs; [ gitMinimal openssh docker utillinux iproute ethtool thin-provisioning-tools iptables ] ++ cfg.path;
        preStart = ''
          docker load < ${infraContainer}
          rm /opt/cni/bin/* || true
          ${concatMapStringsSep "\n" (p: "ln -fs ${p.plugins}/* /opt/cni/bin") cfg.kubelet.cni.packages}
        '';
        serviceConfig = {
          Slice = "kubernetes.slice";
          ExecStart = ''${cfg.package}/bin/kubelet \
            ${optionalString cfg.kubelet.applyManifests
              "--pod-manifest-path=${manifests}"} \
            ${optionalString (taints != "")
              "--register-with-taints=${taints}"} \
            --kubeconfig=${mkKubeConfig "kubelet" cfg.kubelet.kubeconfig} \
            --require-kubeconfig \
            --address=${cfg.kubelet.address} \
            --port=${toString cfg.kubelet.port} \
            --register-node=${boolToString cfg.kubelet.registerNode} \
            ${optionalString (cfg.kubelet.tlsCertFile != null)
              "--tls-cert-file=${cfg.kubelet.tlsCertFile}"} \
            ${optionalString (cfg.kubelet.tlsKeyFile != null)
              "--tls-private-key-file=${cfg.kubelet.tlsKeyFile}"} \
            --healthz-bind-address=${cfg.kubelet.healthz.bind} \
            --healthz-port=${toString cfg.kubelet.healthz.port} \
            --hostname-override=${cfg.kubelet.hostname} \
            --allow-privileged=${boolToString cfg.kubelet.allowPrivileged} \
            --root-dir=${cfg.dataDir} \
            --cadvisor_port=${toString cfg.kubelet.cadvisorPort} \
            ${optionalString (cfg.kubelet.clusterDns != "")
              "--cluster-dns=${cfg.kubelet.clusterDns}"} \
            ${optionalString (cfg.kubelet.clusterDomain != "")
              "--cluster-domain=${cfg.kubelet.clusterDomain}"} \
            --pod-infra-container-image=pause \
            ${optionalString (cfg.kubelet.networkPlugin != null)
              "--network-plugin=${cfg.kubelet.networkPlugin}"} \
            --cni-conf-dir=${cniConfig} \
            --hairpin-mode=hairpin-veth \
            ${optionalString (cfg.kubelet.nodeIp != null)
              "--node-ip=${cfg.kubelet.nodeIp}"} \
            ${optionalString cfg.verbose "--v=6 --log_flush_frequency=1s"} \
            ${cfg.kubelet.extraOpts}
          '';
          WorkingDirectory = cfg.dataDir;
        };
      };

      # Allways include cni plugins
      services.kubernetes.kubelet.cni.packages = [pkgs.cni];

      boot.kernelModules = ["br_netfilter"];

      services.kubernetes.kubelet.kubeconfig = kubeConfigDefaults;
    })

    (mkIf (cfg.kubelet.applyManifests && cfg.kubelet.enable) {
      environment.etc = mapAttrs' (name: manifest:
        nameValuePair "kubernetes/manifests/${name}.json" {
          text = builtins.toJSON manifest;
          mode = "0755";
        }
      ) cfg.kubelet.manifests;
    })

    (mkIf (cfg.kubelet.unschedulable && cfg.kubelet.enable) {
      services.kubernetes.kubelet.taints.unschedulable = {
        value = "true";
        effect = "NoSchedule";
      };
    })

    (mkIf cfg.apiserver.enable {
      systemd.services.kube-apiserver = {
        description = "Kubernetes Kubelet Service";
        wantedBy = [ "kubernetes.target" ];
        after = [ "network.target" "docker.service" ];
        serviceConfig = {
          Slice = "kubernetes.slice";
          ExecStart = ''${cfg.package}/bin/kube-apiserver \
            --etcd-servers=${concatStringsSep "," cfg.etcd.servers} \
            ${optionalString (cfg.etcd.caFile != null)
              "--etcd-cafile=${cfg.etcd.caFile}"} \
            ${optionalString (cfg.etcd.certFile != null)
              "--etcd-certfile=${cfg.etcd.certFile}"} \
            ${optionalString (cfg.etcd.keyFile != null)
              "--etcd-keyfile=${cfg.etcd.keyFile}"} \
            --insecure-port=${toString cfg.apiserver.port} \
            --bind-address=0.0.0.0 \
            ${optionalString (cfg.apiserver.advertiseAddress != null)
              "--advertise-address=${cfg.apiserver.advertiseAddress}"} \
            --allow-privileged=${boolToString cfg.apiserver.allowPrivileged}\
            ${optionalString (cfg.apiserver.tlsCertFile != null)
              "--tls-cert-file=${cfg.apiserver.tlsCertFile}"} \
            ${optionalString (cfg.apiserver.tlsKeyFile != null)
              "--tls-private-key-file=${cfg.apiserver.tlsKeyFile}"} \
            ${optionalString (cfg.apiserver.tokenAuthFile != null)
              "--token-auth-file=${cfg.apiserver.tokenAuthFile}"} \
            ${optionalString (cfg.apiserver.basicAuthFile != null)
              "--basic-auth-file=${cfg.apiserver.basicAuthFile}"} \
            --kubelet-https=${if cfg.apiserver.kubeletHttps then "true" else "false"} \
            ${optionalString (cfg.apiserver.kubeletClientCaFile != null)
              "--kubelet-certificate-authority=${cfg.apiserver.kubeletClientCaFile}"} \
            ${optionalString (cfg.apiserver.kubeletClientCertFile != null)
              "--kubelet-client-certificate=${cfg.apiserver.kubeletClientCertFile}"} \
            ${optionalString (cfg.apiserver.kubeletClientKeyFile != null)
              "--kubelet-client-key=${cfg.apiserver.kubeletClientKeyFile}"} \
            ${optionalString (cfg.apiserver.clientCaFile != null)
              "--client-ca-file=${cfg.apiserver.clientCaFile}"} \
            --authorization-mode=${concatStringsSep "," cfg.apiserver.authorizationMode} \
            ${optionalString (elem "ABAC" cfg.apiserver.authorizationMode)
              "--authorization-policy-file=${
                pkgs.writeText "kube-auth-policy.jsonl"
                (concatMapStringsSep "\n" (l: builtins.toJSON l) cfg.apiserver.authorizationPolicy)
              }"
            } \
            --secure-port=${toString cfg.apiserver.securePort} \
            --service-cluster-ip-range=${cfg.apiserver.serviceClusterIpRange} \
            ${optionalString (cfg.apiserver.runtimeConfig != "")
              "--runtime-config=${cfg.apiserver.runtimeConfig}"} \
            --admission_control=${concatStringsSep "," cfg.apiserver.admissionControl} \
            ${optionalString (cfg.apiserver.serviceAccountKeyFile!=null)
              "--service-account-key-file=${cfg.apiserver.serviceAccountKeyFile}"} \
            ${optionalString cfg.verbose "--v=6"} \
            ${optionalString cfg.verbose "--log-flush-frequency=1s"} \
            --storage-backend=${cfg.apiserver.storageBackend} \
            ${cfg.apiserver.extraOpts}
          '';
          WorkingDirectory = cfg.dataDir;
          User = "kubernetes";
          Group = "kubernetes";
          AmbientCapabilities = "cap_net_bind_service";
          Restart = "on-failure";
          RestartSec = 5;
        };
      };
    })

    (mkIf cfg.scheduler.enable {
      systemd.services.kube-scheduler = {
        description = "Kubernetes Scheduler Service";
        wantedBy = [ "kubernetes.target" ];
        after = [ "kube-apiserver.service" ];
        serviceConfig = {
          Slice = "kubernetes.slice";
          ExecStart = ''${cfg.package}/bin/kube-scheduler \
            --address=${cfg.scheduler.address} \
            --port=${toString cfg.scheduler.port} \
            --leader-elect=${boolToString cfg.scheduler.leaderElect} \
            --kubeconfig=${mkKubeConfig "kube-scheduler" cfg.scheduler.kubeconfig} \
            ${optionalString cfg.verbose "--v=6"} \
            ${optionalString cfg.verbose "--log-flush-frequency=1s"} \
            ${cfg.scheduler.extraOpts}
          '';
          WorkingDirectory = cfg.dataDir;
          User = "kubernetes";
          Group = "kubernetes";
        };
      };

      services.kubernetes.scheduler.kubeconfig = kubeConfigDefaults;
    })

    (mkIf cfg.controllerManager.enable {
      systemd.services.kube-controller-manager = {
        description = "Kubernetes Controller Manager Service";
        wantedBy = [ "kubernetes.target" ];
        after = [ "kube-apiserver.service" ];
        serviceConfig = {
          RestartSec = "30s";
          Restart = "on-failure";
          Slice = "kubernetes.slice";
          ExecStart = ''${cfg.package}/bin/kube-controller-manager \
            --address=${cfg.controllerManager.address} \
            --port=${toString cfg.controllerManager.port} \
            --kubeconfig=${mkKubeConfig "kube-controller-manager" cfg.controllerManager.kubeconfig} \
            --leader-elect=${boolToString cfg.controllerManager.leaderElect} \
            ${if (cfg.controllerManager.serviceAccountKeyFile!=null)
              then "--service-account-private-key-file=${cfg.controllerManager.serviceAccountKeyFile}"
              else "--service-account-private-key-file=/var/run/kubernetes/apiserver.key"} \
            ${if (cfg.controllerManager.rootCaFile!=null)
              then "--root-ca-file=${cfg.controllerManager.rootCaFile}"
              else "--root-ca-file=/var/run/kubernetes/apiserver.crt"} \
            ${optionalString (cfg.clusterCidr!=null)
              "--cluster-cidr=${cfg.clusterCidr}"} \
            --allocate-node-cidrs=true \
            ${optionalString cfg.verbose "--v=6"} \
            ${optionalString cfg.verbose "--log-flush-frequency=1s"} \
            ${cfg.controllerManager.extraOpts}
          '';
          WorkingDirectory = cfg.dataDir;
          User = "kubernetes";
          Group = "kubernetes";
        };
        path = cfg.path;
      };

      services.kubernetes.controllerManager.kubeconfig = kubeConfigDefaults;
    })

    (mkIf cfg.proxy.enable {
      systemd.services.kube-proxy = {
        description = "Kubernetes Proxy Service";
        wantedBy = [ "kubernetes.target" ];
        after = [ "kube-apiserver.service" ];
        path = [pkgs.iptables pkgs.conntrack_tools];
        serviceConfig = {
          Slice = "kubernetes.slice";
          ExecStart = ''${cfg.package}/bin/kube-proxy \
            --kubeconfig=${mkKubeConfig "kube-proxy" cfg.proxy.kubeconfig} \
            --bind-address=${cfg.proxy.address} \
            ${optionalString cfg.verbose "--v=6"} \
            ${optionalString cfg.verbose "--log-flush-frequency=1s"} \
            ${optionalString (cfg.clusterCidr!=null)
              "--cluster-cidr=${cfg.clusterCidr}"} \
            ${cfg.proxy.extraOpts}
          '';
          WorkingDirectory = cfg.dataDir;
        };
      };

      # kube-proxy needs iptables
      networking.firewall.enable = mkDefault true;

      services.kubernetes.proxy.kubeconfig = kubeConfigDefaults;
    })

    (mkIf (any (el: el == "master") cfg.roles) {
      virtualisation.docker.enable = mkDefault true;
      services.kubernetes.kubelet.enable = mkDefault true;
      services.kubernetes.kubelet.allowPrivileged = mkDefault true;
      services.kubernetes.kubelet.applyManifests = mkDefault true;
      services.kubernetes.apiserver.enable = mkDefault true;
      services.kubernetes.scheduler.enable = mkDefault true;
      services.kubernetes.controllerManager.enable = mkDefault true;
      services.kubernetes.dns.enable = mkDefault true;
      services.etcd.enable = mkDefault (cfg.etcd.servers == ["http://127.0.0.1:2379"]);
    })

    # if this node is only a master make it unschedulable by default
    (mkIf (all (el: el == "master") cfg.roles) {
      services.kubernetes.kubelet.unschedulable = mkDefault true;
    })

    (mkIf (any (el: el == "node") cfg.roles) {
      virtualisation.docker = {
        enable = mkDefault true;

        # kubernetes needs access to logs
        logDriver = mkDefault "json-file";

        # iptables must be disabled for kubernetes
        extraOptions = "--iptables=false --ip-masq=false";
      };

      services.kubernetes.kubelet.enable = mkDefault true;
      services.kubernetes.proxy.enable = mkDefault true;
      services.kubernetes.dns.enable = mkDefault true;
    })

    (mkIf cfg.addonManager.enable {
      services.kubernetes.kubelet.manifests = import ./kube-addon-manager.nix { inherit cfg addons; };
      environment.etc."kubernetes/addons".source = "${addons}/";
    })

    (mkIf cfg.dns.enable {
      systemd.services.kube-dns = {
        description = "Kubernetes DNS Service";
        wantedBy = [ "kubernetes.target" ];
        after = [ "kube-apiserver.service" ];
        serviceConfig = {
          Slice = "kubernetes.slice";
          ExecStart = ''${pkgs.kube-dns}/bin/kube-dns \
            --kubecfg-file=${mkKubeConfig "kube-dns" cfg.dns.kubeconfig} \
            --dns-port=${toString cfg.dns.port} \
            --domain=${cfg.dns.domain} \
            ${optionalString cfg.verbose "--v=6"} \
            ${optionalString cfg.verbose "--log-flush-frequency=1s"} \
            ${cfg.dns.extraOpts}
          '';
          WorkingDirectory = cfg.dataDir;
          User = "kubernetes";
          Group = "kubernetes";
          AmbientCapabilities = "cap_net_bind_service";
          SendSIGHUP = true;
          RestartSec = "30s";
          Restart = "always";
          StartLimitInterval = "1m";
        };
      };

      networking.firewall.extraCommands = ''
        # allow container to host communication for DNS traffic
        ${pkgs.iptables}/bin/iptables -I nixos-fw -p tcp -m tcp -d ${cfg.clusterCidr} --dport 53 -j nixos-fw-accept
        ${pkgs.iptables}/bin/iptables -I nixos-fw -p udp -m udp -d ${cfg.clusterCidr} --dport 53 -j nixos-fw-accept
      '';

      services.kubernetes.dns.kubeconfig = kubeConfigDefaults;
    })

    (mkIf (
        cfg.apiserver.enable ||
        cfg.scheduler.enable ||
        cfg.controllerManager.enable ||
        cfg.kubelet.enable ||
        cfg.proxy.enable ||
        cfg.dns.enable
    ) {
      systemd.targets.kubernetes = {
        description = "Kubernetes";
        wantedBy = [ "multi-user.target" ];
      };

      systemd.tmpfiles.rules = [
        "d /opt/cni/bin 0755 root root -"
        "d /var/run/kubernetes 0755 kubernetes kubernetes -"
        "d /var/lib/kubernetes 0755 kubernetes kubernetes -"
      ];

      environment.systemPackages = [ cfg.package ];
      users.extraUsers = singleton {
        name = "kubernetes";
        uid = config.ids.uids.kubernetes;
        description = "Kubernetes user";
        extraGroups = [ "docker" ];
        group = "kubernetes";
        home = cfg.dataDir;
        createHome = true;
      };
      users.extraGroups.kubernetes.gid = config.ids.gids.kubernetes;
    })

    (mkIf cfg.flannel.enable {
      services.flannel = {
        enable = mkDefault true;
        network = mkDefault cfg.clusterCidr;
        etcd = mkDefault {
          endpoints = cfg.etcd.servers;
          inherit (cfg.etcd) caFile certFile keyFile;
        };
      };

      services.kubernetes.kubelet = {
        networkPlugin = mkDefault "cni";
        cni.config = mkDefault [{
          name = "mynet";
          type = "flannel";
          delegate = {
            isDefaultGateway = true;
            bridge = "docker0";
          };
        }];
      };

      systemd.services."mk-docker-opts" = {
        description = "Pre-Docker Actions";
        wantedBy = [ "flannel.service" ];
        before = [ "docker.service" ];
        after = [ "flannel.service" ];
        path = [ pkgs.gawk pkgs.gnugrep ];
        script = ''
          mkdir -p /run/flannel
          ${mkDockerOpts}/mk-docker-opts -d /run/flannel/docker
        '';
        serviceConfig.Type = "oneshot";
      };
      systemd.services.docker.serviceConfig.EnvironmentFile = "/run/flannel/docker";

      # read environment variables generated by mk-docker-opts
      virtualisation.docker.extraOptions = "$DOCKER_OPTS";

      networking.firewall.allowedUDPPorts = [
        8285  # flannel udp
        8472  # flannel vxlan
      ];
    })
  ];
}
