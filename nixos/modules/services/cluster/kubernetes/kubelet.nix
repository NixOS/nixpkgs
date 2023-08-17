{ config, lib, pkgs, ... }:

with lib;

let
  top = config.services.kubernetes;
  cfg = top.kubelet;

  # TODO: Remove in NixOS 24.05
  removedOptions = {
    "extraOpts" = "Use freeform settings";
    "manifests" = "Build and set services.kubernetes.kubelet.settings.pod-manifest-path";
    "unschedulable" = "Set services.kubernetes.kubelet.settings.register-with-tains manually";
  };

  # TODO: Remove in NixOS 24.05
  optName = n: builtins.filter (f: f != []) (builtins.split "\\." n);

  # TODO: Remove in NixOS 24.05
  renamedOptions = {
    "address" = "address";
    "clusterDns" = "cluster-dns";
    "clusterDomain" = "cluster-domain";
    "clientCaFile" = "client-ca-file";
    "containerRuntimeEndpoint" = "container-runtime-endpoint";
    "featureGates" = "feature-gates";
    "healthz.bind" = "healthz-bind-address";
    "healthz.port" = "healthz-port";
    "kubeconfig" = "kubeconfig";
    "nodeIp" = "node-ip";
    "registerNode" = "register-node";
    "taints" = "register-with-taints";
    "tlsCertFile" = "tls-cert-file";
    "tlsKeyFile" = "tls-private-key-file";
    "port" = "port";
    "verbosity" = "v";
  };

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
    copyToRoot = pkgs.buildEnv {
      name = "image-root";
      pathsToLink = [ "/bin" ];
      paths = [ top.package.pause ];
    };
    config.Cmd = ["/bin/pause"];
  };
in
{
  # TODO: Remove in NixOS 24.05
  imports =
    let
      base = ["services" "kubernetes" "kubelet"];
    in
      (mapAttrsToList (n: v: mkRemovedOptionModule (base ++ [n]) v) removedOptions) ++
      (mapAttrsToList (n: v: mkRenamedOptionModule (base ++ (optName n)) (base ++ ["settings" v])) renamedOptions);

  ###### interface
  options.services.kubernetes.kubelet = with lib.types; {
    cni = {
      packages = mkOption {
        description = lib.mdDoc "List of network plugin packages to install.";
        type = listOf package;
        default = [];
      };

      config = mkOption {
        description = lib.mdDoc "Kubernetes CNI configuration.";
        type = listOf attrs;
        default = [];
        example = literalExpression ''
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
        description = lib.mdDoc "Path to Kubernetes CNI configuration directory.";
        type = nullOr path;
        default = null;
      };
    };

    enable = mkEnableOption (lib.mdDoc "Kubernetes kubelet");

    hostname = mkOption {
      description = lib.mdDoc "Kubernetes kubelet hostname override.";
      defaultText = literalExpression "config.networking.fqdnOrHostName";
      type = str;
    };

    seedDockerImages = mkOption {
      description = lib.mdDoc "List of docker images to preload on system";
      default = [];
      type = listOf package;
    };

    settings = mkOption {
      description = ''
        Configuration for kubelet, see:
          <https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet>.
        All attrs defined here translates directly to flags of syntax `--<name>="<value>"`
        which is provided as command line argument to the kubelet binary.
      '';
      type = types.submodule {
        freeformType = attrsOf (oneOf [
          bool
          float
          int
          (listOf str)
          package
          path
          str
        ]);
      };
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
            ${concatStringsSep " \\\n" (mapAttrsToList (n: v: ''--${n}="${top.lib.renderArg v}"'') cfg.settings)}
          '';
          WorkingDirectory = top.dataDir;
        };
        unitConfig = {
          StartLimitIntervalSec = 0;
        };
      };

      # Always include cni plugins
      services.kubernetes.kubelet.cni.packages = [pkgs.cni-plugins pkgs.cni-plugin-flannel];

      services.kubernetes.kubelet.settings.hostname-override = mkDefault cfg.hostname;

      boot.kernelModules = ["br_netfilter" "overlay"];

      services.kubernetes.kubelet.hostname =
        mkDefault config.networking.fqdnOrHostName;

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
    })
  ];

  meta.buildDocsInSandbox = false;
}
