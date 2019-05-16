{ config, lib, pkgs, ... }:

with lib;

let
  top = config.services.kubernetes;
  cfg = top.kubelet;

  cniConfig =
    if cfg.cni.config != [] && !(isNull cfg.cni.configDir) then
      throw "Verbatim CNI-config and CNI configDir cannot both be set."
    else if !(isNull cfg.cni.configDir) then
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
    config.Cmd = "/bin/pause";
  };

  kubeconfig = top.lib.mkKubeConfig "kubelet" cfg.kubeconfig;

  manifests = pkgs.buildEnv {
    name = "kubernetes-manifests";
    paths = mapAttrsToList (name: manifest:
      pkgs.writeTextDir "${name}.json" (builtins.toJSON manifest)
    ) cfg.manifests;
  };

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
  ###### interface
  options.services.kubernetes.kubelet = with lib.types; {

    address = mkOption {
      description = "Kubernetes kubelet info server listening address.";
      default = "0.0.0.0";
      type = str;
    };

    allowPrivileged = mkOption {
      description = "Whether to allow Kubernetes containers to request privileged mode.";
      default = false;
      type = bool;
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

      configDir = mkOption {
        description = "Path to Kubernetes CNI configuration directory.";
        type = nullOr path;
        default = null;
      };
    };

    enable = mkEnableOption "Kubernetes kubelet.";

    extraOpts = mkOption {
      description = "Kubernetes kubelet extra command line options.";
      default = "";
      type = str;
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
    (let

      kubeletPaths = filter (a: a != null) [
        cfg.kubeconfig.caFile
        cfg.kubeconfig.certFile
        cfg.kubeconfig.keyFile
        cfg.clientCaFile
        cfg.tlsCertFile
        cfg.tlsKeyFile
      ];

    in mkIf cfg.enable {
      services.kubernetes.kubelet.seedDockerImages = [infraContainer];

      systemd.services.kubelet = {
        description = "Kubernetes Kubelet Service";
        wantedBy = [ "kubelet.target" ];
        after = [ "kube-control-plane-online.target" ];
        before = [ "kubelet.target" ];
        path = with pkgs; [ gitMinimal openssh docker utillinux iproute ethtool thin-provisioning-tools iptables socat ] ++ top.path;
        preStart = ''
          rm -f /opt/cni/bin/* || true
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
            --allow-privileged=${boolToString cfg.allowPrivileged} \
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
            ${cfg.extraOpts}
          '';
          WorkingDirectory = top.dataDir;
        };
        unitConfig.ConditionPathExists = kubeletPaths;
      };

      systemd.paths.kubelet = {
        wantedBy =  [ "kubelet.service" ];
        pathConfig = {
          PathExists = kubeletPaths;
          PathChanged = kubeletPaths;
        };
      };

      systemd.services.docker.before = [ "kubelet.service" ];

      systemd.services.docker-seed-images = {
        wantedBy = [ "docker.service" ];
        after = [ "docker.service" ];
        before = [ "kubelet.service" ];
        path = with pkgs; [ docker ];
        preStart = ''
          ${concatMapStrings (img: ''
            echo "Seeding docker image: ${img}"
            docker load <${img}
          '') cfg.seedDockerImages}
        '';
        script = "echo Ok";
        serviceConfig.Type = "oneshot";
        serviceConfig.RemainAfterExit = true;
        serviceConfig.Slice = "kubernetes.slice";
      };

      systemd.services.kubelet-online = {
        wantedBy = [ "kube-node-online.target" ];
        after = [ "flannel.target" "kubelet.target" ];
        before = [ "kube-node-online.target" ];
        # it is complicated. flannel needs kubelet to run the pause container before
        # it discusses the node CIDR with apiserver and afterwards configures and restarts
        # dockerd. Until then prevent creating any pods because they have to be recreated anyway
        # because the network of docker0 has been changed by flannel.
        script = let
          docker-env = "/run/flannel/docker";
          flannel-date = "stat --print=%Y ${docker-env}";
          docker-date = "systemctl show --property=ActiveEnterTimestamp --value docker";
        in ''
          until test -f ${docker-env} ; do sleep 1 ; done
          while test `${flannel-date}` -gt `date +%s --date="$(${docker-date})"` ; do
            sleep 1
          done
        '';
        serviceConfig.Type = "oneshot";
        serviceConfig.Slice = "kubernetes.slice";
      };

      # Allways include cni plugins
      services.kubernetes.kubelet.cni.packages = [pkgs.cni-plugins];

      boot.kernelModules = ["br_netfilter"];

      services.kubernetes.kubelet.hostname = with config.networking;
        mkDefault (hostName + optionalString (!isNull domain) ".${domain}");

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

    {
      systemd.targets.kubelet = {
        wantedBy = [ "kube-node-online.target" ];
        before = [ "kube-node-online.target" ];
      };

      systemd.targets.kube-node-online = {
        wantedBy = [ "kubernetes.target" ];
        before = [ "kubernetes.target" ];
      };
    }
  ];
}
