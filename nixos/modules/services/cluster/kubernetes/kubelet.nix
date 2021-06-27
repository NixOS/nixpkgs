{ config, lib, pkgs, ... }:

with lib;

let
  top = config.services.kubernetes;
  cfg = top.kubelet;

  cniConfig =
    if cfg.cni.config != [] && cfg.cni.configDir != null then
      throw "Verbatim CNI-config and CNI configDir cannot both be set."
    else if cfg.cni.configDir != null then
      cfg.cni.configDir
    else
      (pkgs.buildEnv {
        name = "kubernetes-cni-config";
        paths = imap (i: entry:
          pkgs.writeTextDir "${toString (10+i)}-${entry.type}.conf" (builtins.toJSON entry)
        ) cfg.cni.config;
      });

  infraContainer = pkgs.dockerTools.buildImage {
    name = "pause";
    tag = "latest";
    contents = top.package.pause;
    config.Cmd = ["/bin/pause"];
  };

  kubeconfig = top.lib.mkKubeConfig "kubelet" cfg.kubeconfig;

  manifestPath = "kubernetes/manifests";

  taintOptions = with lib.types; { name, ... }: {
    options = {
      key = mkOption {
        description = "Key of taint.";
        default = name;
        type = str;
      };
      value = mkOption {
        description = "Value of taint.";
        type = str;
      };
      effect = mkOption {
        description = "Effect of taint.";
        example = "NoSchedule";
        type = enum ["NoSchedule" "PreferNoSchedule" "NoExecute"];
      };
    };
  };

  taints = concatMapStringsSep "," (v: "${v.key}=${v.value}:${v.effect}") (mapAttrsToList (n: v: v) cfg.taints);
in
{
  imports = [
    (mkRemovedOptionModule [ "services" "kubernetes" "kubelet" "applyManifests" ] "")
    (mkRemovedOptionModule [ "services" "kubernetes" "kubelet" "cadvisorPort" ] "")
    (mkRemovedOptionModule [ "services" "kubernetes" "kubelet" "allowPrivileged" ] "")
  ];

  ###### interface
  options.services.kubernetes.kubelet = with lib.types; {

    address = mkOption {
      description = "Kubernetes kubelet info server listening address.";
      default = "0.0.0.0";
      type = str;
    };

    clusterDns = mkOption {
      description = "Use alternative DNS.";
      default = "10.1.0.1";
      type = str;
    };

    clusterDomain = mkOption {
      description = "Use alternative domain.";
      default = config.services.kubernetes.addons.dns.clusterDomain;
      type = str;
    };

    clientCaFile = mkOption {
      description = "Kubernetes apiserver CA file for client authentication.";
      default = top.caFile;
      type = nullOr path;
    };

    cni = {
      packages = mkOption {
        description = "List of network plugin packages to install.";
        type = listOf package;
        default = [];
      };

      config = mkOption {
        description = "Kubernetes CNI configuration.";
        type = listOf attrs;
        default = [];
        example = literalExample ''
          [{
            "cniVersion": "0.3.1",
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
            "cniVersion": "0.3.1",
            "type": "loopback"
          }]
        '';
      };

      configDir = mkOption {
        description = "Path to Kubernetes CNI configuration directory.";
        type = nullOr path;
        default = null;
      };
    };

    containerRuntime = mkOption {
      description = "Which container runtime type to use";
      type = enum ["docker" "remote"];
      default = "remote";
    };

    containerRuntimeEndpoint = mkOption {
      description = "Endpoint at which to find the container runtime api interface/socket";
      type = str;
      default = "unix:///run/containerd/containerd.sock";
    };

    enable = mkEnableOption "Kubernetes kubelet.";

    extraOpts = mkOption {
      description = "Kubernetes kubelet extra command line options.";
      default = "";
      type = separatedString " ";
    };

    featureGates = mkOption {
      description = "List set of feature gates";
      default = top.featureGates;
      type = listOf str;
    };

    healthz = {
      bind = mkOption {
        description = "Kubernetes kubelet healthz listening address.";
        default = "127.0.0.1";
        type = str;
      };

      port = mkOption {
        description = "Kubernetes kubelet healthz port.";
        default = 10248;
        type = int;
      };
    };

    hostname = mkOption {
      description = "Kubernetes kubelet hostname override.";
      default = config.networking.hostName;
      type = str;
    };

    kubeconfig = top.lib.mkKubeConfigOptions "Kubelet";

    manifests = mkOption {
      description = "List of manifests to bootstrap with kubelet (only pods can be created as manifest entry)";
      type = attrsOf attrs;
      default = {};
    };

    networkPlugin = mkOption {
      description = "Network plugin to use by Kubernetes.";
      type = nullOr (enum ["cni" "kubenet"]);
      default = "kubenet";
    };

    nodeIp = mkOption {
      description = "IP address of the node. If set, kubelet will use this IP address for the node.";
      default = null;
      type = nullOr str;
    };

    registerNode = mkOption {
      description = "Whether to auto register kubelet with API server.";
      default = true;
      type = bool;
    };

    port = mkOption {
      description = "Kubernetes kubelet info server listening port.";
      default = 10250;
      type = int;
    };

    seedDockerImages = mkOption {
      description = "List of docker images to preload on system";
      default = [];
      type = listOf package;
    };

    taints = mkOption {
      description = "Node taints (https://kubernetes.io/docs/concepts/configuration/assign-pod-node/).";
      default = {};
      type = attrsOf (submodule [ taintOptions ]);
    };

    tlsCertFile = mkOption {
      description = "File containing x509 Certificate for HTTPS.";
      default = null;
      type = nullOr path;
    };

    tlsKeyFile = mkOption {
      description = "File containing x509 private key matching tlsCertFile.";
      default = null;
      type = nullOr path;
    };

    unschedulable = mkOption {
      description = "Whether to set node taint to unschedulable=true as it is the case of node that has only master role.";
      default = false;
      type = bool;
    };

    verbosity = mkOption {
      description = ''
        Optional glog verbosity level for logging statements. See
        <link xlink:href="https://github.com/kubernetes/community/blob/master/contributors/devel/logging.md"/>
      '';
      default = null;
      type = nullOr int;
    };

  };

  ###### implementation
  config = mkMerge [
    (mkIf cfg.enable {

      environment.etc."cni/net.d".source = cniConfig;

      services.kubernetes.kubelet.seedDockerImages = [infraContainer];

      boot.kernel.sysctl = {
        "net.bridge.bridge-nf-call-iptables"  = 1;
        "net.ipv4.ip_forward"                 = 1;
        "net.bridge.bridge-nf-call-ip6tables" = 1;
      };

      systemd.services.kubelet = {
        description = "Kubernetes Kubelet Service";
        wantedBy = [ "kubernetes.target" ];
        after = [ "containerd.service" "network.target" "kube-apiserver.service" ];
        path = with pkgs; [
          gitMinimal
          openssh
          util-linux
          iproute2
          ethtool
          thin-provisioning-tools
          iptables
          socat
        ] ++ lib.optional config.boot.zfs.enabled config.boot.zfs.package ++ top.path;
        preStart = ''
          ${concatMapStrings (img: ''
            echo "Seeding container image: ${img}"
            ${if (lib.hasSuffix "gz" img) then
              ''${pkgs.gzip}/bin/zcat "${img}" | ${pkgs.containerd}/bin/ctr -n k8s.io image import --all-platforms -''
            else
              ''${pkgs.coreutils}/bin/cat "${img}" | ${pkgs.containerd}/bin/ctr -n k8s.io image import --all-platforms -''
            }
          '') cfg.seedDockerImages}

          rm /opt/cni/bin/* || true
          ${concatMapStrings (package: ''
            echo "Linking cni package: ${package}"
            ln -fs ${package}/bin/* /opt/cni/bin
          '') cfg.cni.packages}
        '';
        serviceConfig = {
          Slice = "kubernetes.slice";
          CPUAccounting = true;
          MemoryAccounting = true;
          Restart = "on-failure";
          RestartSec = "1000ms";
          ExecStart = ''${top.package}/bin/kubelet \
            --address=${cfg.address} \
            --authentication-token-webhook \
            --authentication-token-webhook-cache-ttl="10s" \
            --authorization-mode=Webhook \
            ${optionalString (cfg.clientCaFile != null)
              "--client-ca-file=${cfg.clientCaFile}"} \
            ${optionalString (cfg.clusterDns != "")
              "--cluster-dns=${cfg.clusterDns}"} \
            ${optionalString (cfg.clusterDomain != "")
              "--cluster-domain=${cfg.clusterDomain}"} \
            --cni-conf-dir=${cniConfig} \
            ${optionalString (cfg.featureGates != [])
              "--feature-gates=${concatMapStringsSep "," (feature: "${feature}=true") cfg.featureGates}"} \
            --hairpin-mode=hairpin-veth \
            --healthz-bind-address=${cfg.healthz.bind} \
            --healthz-port=${toString cfg.healthz.port} \
            --hostname-override=${cfg.hostname} \
            --kubeconfig=${kubeconfig} \
            ${optionalString (cfg.networkPlugin != null)
              "--network-plugin=${cfg.networkPlugin}"} \
            ${optionalString (cfg.nodeIp != null)
              "--node-ip=${cfg.nodeIp}"} \
            --pod-infra-container-image=pause \
            ${optionalString (cfg.manifests != {})
              "--pod-manifest-path=/etc/${manifestPath}"} \
            --port=${toString cfg.port} \
            --register-node=${boolToString cfg.registerNode} \
            ${optionalString (taints != "")
              "--register-with-taints=${taints}"} \
            --root-dir=${top.dataDir} \
            ${optionalString (cfg.tlsCertFile != null)
              "--tls-cert-file=${cfg.tlsCertFile}"} \
            ${optionalString (cfg.tlsKeyFile != null)
              "--tls-private-key-file=${cfg.tlsKeyFile}"} \
            ${optionalString (cfg.verbosity != null) "--v=${toString cfg.verbosity}"} \
            --container-runtime=${cfg.containerRuntime} \
            --container-runtime-endpoint=${cfg.containerRuntimeEndpoint} \
            --cgroup-driver=systemd \
            ${cfg.extraOpts}
          '';
          WorkingDirectory = top.dataDir;
        };
      };

      # Allways include cni plugins
      services.kubernetes.kubelet.cni.packages = [pkgs.cni-plugins];

      boot.kernelModules = ["br_netfilter" "overlay"];

      services.kubernetes.kubelet.hostname = with config.networking;
        mkDefault (hostName + optionalString (domain != null) ".${domain}");

      services.kubernetes.pki.certs = with top.lib; {
        kubelet = mkCert {
          name = "kubelet";
          CN = top.kubelet.hostname;
          action = "systemctl restart kubelet.service";

        };
        kubeletClient = mkCert {
          name = "kubelet-client";
          CN = "system:node:${top.kubelet.hostname}";
          fields = {
            O = "system:nodes";
          };
          action = "systemctl restart kubelet.service";
        };
      };

      services.kubernetes.kubelet.kubeconfig.server = mkDefault top.apiserverAddress;
    })

    (mkIf (cfg.enable && cfg.manifests != {}) {
      environment.etc = mapAttrs' (name: manifest:
        nameValuePair "${manifestPath}/${name}.json" {
          text = builtins.toJSON manifest;
          mode = "0755";
        }
      ) cfg.manifests;
    })

    (mkIf (cfg.unschedulable && cfg.enable) {
      services.kubernetes.kubelet.taints.unschedulable = {
        value = "true";
        effect = "NoSchedule";
      };
    })

  ];
}
