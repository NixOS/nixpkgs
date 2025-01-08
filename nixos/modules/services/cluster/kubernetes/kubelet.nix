{
  config,
  lib,
  options,
  pkgs,
  ...
}:

let
  top = config.services.kubernetes;
  otop = options.services.kubernetes;
  cfg = top.kubelet;

  cniConfig =
    if cfg.cni.config != [ ] && cfg.cni.configDir != null then
      throw "Verbatim CNI-config and CNI configDir cannot both be set."
    else if cfg.cni.configDir != null then
      cfg.cni.configDir
    else
      (pkgs.buildEnv {
        name = "kubernetes-cni-config";
        paths = lib.imap (
          i: entry: pkgs.writeTextDir "${toString (10 + i)}-${entry.type}.conf" (builtins.toJSON entry)
        ) cfg.cni.config;
      });

  infraContainer = pkgs.dockerTools.buildImage {
    name = "pause";
    tag = "latest";
    copyToRoot = pkgs.buildEnv {
      name = "image-root";
      pathsToLink = [ "/bin" ];
      paths = [ top.package.pause ];
    };
    config.Cmd = [ "/bin/pause" ];
  };

  kubeconfig = top.lib.mkKubeConfig "kubelet" cfg.kubeconfig;

  # Flag based settings are deprecated, use the `--config` flag with a
  # `KubeletConfiguration` struct.
  # https://kubernetes.io/docs/tasks/administer-cluster/kubelet-config-file/
  #
  # NOTE: registerWithTaints requires a []core/v1.Taint, therefore requires
  # additional work to be put in config format.
  #
  kubeletConfig = pkgs.writeText "kubelet-config" (
    builtins.toJSON (
      {
        apiVersion = "kubelet.config.k8s.io/v1beta1";
        kind = "KubeletConfiguration";
        address = cfg.address;
        port = cfg.port;
        authentication = {
          x509 = lib.optionalAttrs (cfg.clientCaFile != null) { clientCAFile = cfg.clientCaFile; };
          webhook = {
            enabled = true;
            cacheTTL = "10s";
          };
        };
        authorization = {
          mode = "Webhook";
        };
        cgroupDriver = "systemd";
        hairpinMode = "hairpin-veth";
        registerNode = cfg.registerNode;
        containerRuntimeEndpoint = cfg.containerRuntimeEndpoint;
        healthzPort = cfg.healthz.port;
        healthzBindAddress = cfg.healthz.bind;
      }
      // lib.optionalAttrs (cfg.tlsCertFile != null) { tlsCertFile = cfg.tlsCertFile; }
      // lib.optionalAttrs (cfg.tlsKeyFile != null) { tlsPrivateKeyFile = cfg.tlsKeyFile; }
      // lib.optionalAttrs (cfg.clusterDomain != "") { clusterDomain = cfg.clusterDomain; }
      // lib.optionalAttrs (cfg.clusterDns != [ ]) { clusterDNS = cfg.clusterDns; }
      // lib.optionalAttrs (cfg.featureGates != { }) { featureGates = cfg.featureGates; }
      // lib.optionalAttrs (cfg.extraConfig != { }) cfg.extraConfig
    )
  );

  manifestPath = "kubernetes/manifests";

  taintOptions =
    with lib.types;
    { name, ... }:
    {
      options = {
        key = lib.mkOption {
          description = "Key of taint.";
          default = name;
          defaultText = literalMD "Name of this submodule.";
          type = str;
        };
        value = lib.mkOption {
          description = "Value of taint.";
          type = str;
        };
        effect = lib.mkOption {
          description = "Effect of taint.";
          example = "NoSchedule";
          type = enum [
            "NoSchedule"
            "PreferNoSchedule"
            "NoExecute"
          ];
        };
      };
    };

  taints = lib.concatMapStringsSep "," (v: "${v.key}=${v.value}:${v.effect}") (
    lib.mapAttrsToList (n: v: v) cfg.taints
  );
in
{
  imports = [
    (lib.mkRemovedOptionModule [ "services" "kubernetes" "kubelet" "applyManifests" ] "")
    (lib.mkRemovedOptionModule [ "services" "kubernetes" "kubelet" "cadvisorPort" ] "")
    (lib.mkRemovedOptionModule [ "services" "kubernetes" "kubelet" "allowPrivileged" ] "")
    (lib.mkRemovedOptionModule [ "services" "kubernetes" "kubelet" "networkPlugin" ] "")
    (lib.mkRemovedOptionModule [ "services" "kubernetes" "kubelet" "containerRuntime" ] "")
  ];

  ###### interface
  options.services.kubernetes.kubelet = with lib.types; {

    address = lib.mkOption {
      description = "Kubernetes kubelet info server listening address.";
      default = "0.0.0.0";
      type = str;
    };

    clusterDns = lib.mkOption {
      description = "Use alternative DNS.";
      default = [ "10.1.0.1" ];
      type = listOf str;
    };

    clusterDomain = lib.mkOption {
      description = "Use alternative domain.";
      default = config.services.kubernetes.addons.dns.clusterDomain;
      defaultText = lib.literalExpression "config.${options.services.kubernetes.addons.dns.clusterDomain}";
      type = str;
    };

    clientCaFile = lib.mkOption {
      description = "Kubernetes apiserver CA file for client authentication.";
      default = top.caFile;
      defaultText = lib.literalExpression "config.${otop.caFile}";
      type = nullOr path;
    };

    cni = {
      packages = lib.mkOption {
        description = "List of network plugin packages to install.";
        type = listOf package;
        default = [ ];
      };

      config = lib.mkOption {
        description = "Kubernetes CNI configuration.";
        type = listOf attrs;
        default = [ ];
        example = lib.literalExpression ''
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

      configDir = lib.mkOption {
        description = "Path to Kubernetes CNI configuration directory.";
        type = nullOr path;
        default = null;
      };
    };

    containerRuntimeEndpoint = lib.mkOption {
      description = "Endpoint at which to find the container runtime api interface/socket";
      type = str;
      default = "unix:///run/containerd/containerd.sock";
    };

    enable = lib.mkEnableOption "Kubernetes kubelet";

    extraOpts = lib.mkOption {
      description = "Kubernetes kubelet extra command line options.";
      default = "";
      type = separatedString " ";
    };

    extraConfig = lib.mkOption {
      description = ''
        Kubernetes kubelet extra configuration file entries.

        See also [Set Kubelet Parameters Via A Configuration File](https://kubernetes.io/docs/tasks/administer-cluster/kubelet-config-file/)
        and [Kubelet Configuration](https://kubernetes.io/docs/reference/config-api/kubelet-config.v1beta1/).
      '';
      default = { };
      type = attrsOf ((pkgs.formats.json { }).type);
    };

    featureGates = lib.mkOption {
      description = "Attribute set of feature gate";
      default = top.featureGates;
      defaultText = lib.literalExpression "config.${otop.featureGates}";
      type = attrsOf bool;
    };

    healthz = {
      bind = lib.mkOption {
        description = "Kubernetes kubelet healthz listening address.";
        default = "127.0.0.1";
        type = str;
      };

      port = lib.mkOption {
        description = "Kubernetes kubelet healthz port.";
        default = 10248;
        type = port;
      };
    };

    hostname = lib.mkOption {
      description = "Kubernetes kubelet hostname override.";
      defaultText = lib.literalExpression "config.networking.fqdnOrHostName";
      type = str;
    };

    kubeconfig = top.lib.mkKubeConfigOptions "Kubelet";

    manifests = lib.mkOption {
      description = "List of manifests to bootstrap with kubelet (only pods can be created as manifest entry)";
      type = attrsOf attrs;
      default = { };
    };

    nodeIp = lib.mkOption {
      description = "IP address of the node. If set, kubelet will use this IP address for the node.";
      default = null;
      type = nullOr str;
    };

    registerNode = lib.mkOption {
      description = "Whether to auto register kubelet with API server.";
      default = true;
      type = bool;
    };

    port = lib.mkOption {
      description = "Kubernetes kubelet info server listening port.";
      default = 10250;
      type = port;
    };

    seedDockerImages = lib.mkOption {
      description = "List of docker images to preload on system";
      default = [ ];
      type = listOf package;
    };

    taints = lib.mkOption {
      description = "Node taints (https://kubernetes.io/docs/concepts/configuration/assign-pod-node/).";
      default = { };
      type = attrsOf (submodule [ taintOptions ]);
    };

    tlsCertFile = lib.mkOption {
      description = "File containing x509 Certificate for HTTPS.";
      default = null;
      type = nullOr path;
    };

    tlsKeyFile = lib.mkOption {
      description = "File containing x509 private key matching tlsCertFile.";
      default = null;
      type = nullOr path;
    };

    unschedulable = lib.mkOption {
      description = "Whether to set node taint to unschedulable=true as it is the case of node that has only master role.";
      default = false;
      type = bool;
    };

    verbosity = lib.mkOption {
      description = ''
        Optional glog verbosity level for logging statements. See
        <https://github.com/kubernetes/community/blob/master/contributors/devel/logging.md>
      '';
      default = null;
      type = nullOr int;
    };

  };

  ###### implementation
  config = lib.mkMerge [
    (lib.mkIf cfg.enable {

      environment.etc."cni/net.d".source = cniConfig;

      services.kubernetes.kubelet.seedDockerImages = [ infraContainer ];

      boot.kernel.sysctl = {
        "net.bridge.bridge-nf-call-iptables" = 1;
        "net.ipv4.ip_forward" = 1;
        "net.bridge.bridge-nf-call-ip6tables" = 1;
      };

      systemd.services.kubelet = {
        description = "Kubernetes Kubelet Service";
        wantedBy = [ "kubernetes.target" ];
        after = [
          "containerd.service"
          "network.target"
          "kube-apiserver.service"
        ];
        path =
          with pkgs;
          [
            gitMinimal
            openssh
            util-linux
            iproute2
            ethtool
            thin-provisioning-tools
            iptables
            socat
          ]
          ++ lib.optional config.boot.zfs.enabled config.boot.zfs.package
          ++ top.path;
        preStart = ''
          ${lib.concatMapStrings (img: ''
            echo "Seeding container image: ${img}"
            ${
              if (lib.hasSuffix "gz" img) then
                ''${pkgs.gzip}/bin/zcat "${img}" | ${pkgs.containerd}/bin/ctr -n k8s.io image import -''
              else
                ''${pkgs.coreutils}/bin/cat "${img}" | ${pkgs.containerd}/bin/ctr -n k8s.io image import -''
            }
          '') cfg.seedDockerImages}

          rm /opt/cni/bin/* || true
          ${lib.concatMapStrings (package: ''
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
          ExecStart = ''
            ${top.package}/bin/kubelet \
                        --config=${kubeletConfig} \
                        --hostname-override=${cfg.hostname} \
                        --kubeconfig=${kubeconfig} \
                        ${lib.optionalString (cfg.nodeIp != null) "--node-ip=${cfg.nodeIp}"} \
                        --pod-infra-container-image=pause \
                        ${lib.optionalString (cfg.manifests != { }) "--pod-manifest-path=/etc/${manifestPath}"} \
                        ${lib.optionalString (taints != "") "--register-with-taints=${taints}"} \
                        --root-dir=${top.dataDir} \
                        ${lib.optionalString (cfg.verbosity != null) "--v=${toString cfg.verbosity}"} \
                        ${cfg.extraOpts}
          '';
          WorkingDirectory = top.dataDir;
        };
        unitConfig = {
          StartLimitIntervalSec = 0;
        };
      };

      # Always include cni plugins
      services.kubernetes.kubelet.cni.packages = [
        pkgs.cni-plugins
        pkgs.cni-plugin-flannel
      ];

      boot.kernelModules = [
        "br_netfilter"
        "overlay"
      ];

      services.kubernetes.kubelet.hostname = lib.mkDefault (lib.toLower config.networking.fqdnOrHostName);

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

      services.kubernetes.kubelet.kubeconfig.server = lib.mkDefault top.apiserverAddress;
    })

    (lib.mkIf (cfg.enable && cfg.manifests != { }) {
      environment.etc = lib.mapAttrs' (
        name: manifest:
        lib.nameValuePair "${manifestPath}/${name}.json" {
          text = builtins.toJSON manifest;
          mode = "0755";
        }
      ) cfg.manifests;
    })

    (lib.mkIf (cfg.unschedulable && cfg.enable) {
      services.kubernetes.kubelet.taints.unschedulable = {
        value = "true";
        effect = "NoSchedule";
      };
    })

  ];

  meta.buildDocsInSandbox = false;
}
