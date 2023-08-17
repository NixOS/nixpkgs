{ config, lib, pkgs, ... }: with lib;
let
  top = config.services.kubernetes;
  cfg = top.controllerManager;

  # TODO: Remove in NixOS 24.05
  removedOptions = {
    "extraOpts" = "Use freeform settings";
  };

  # TODO: Remove in NixOS 24.05
  optName = n: builtins.filter (f: f != []) (builtins.split "\\." n);

  # TODO: Remove in NixOS 24.05
  renamedOptions = {
    "allocateNodeCIDRs" = "allocate-node-cidrs";
    "bindAddress" = "bind-address";
    "clusterCidr" = "cluster-cidr";
    "featureGates" = "feature-gates";
    "kubeconfig" = "kubeconfig";
    "leaderElect" = "leader-elect";
    "rootCaFile" = "root-ca-file";
    "securePort" = "secure-port";
    "serviceAccountKeyFile" = "service-account-private-key-file";
    "tlsCertFile" = "tls-cert-file";
    "tlsKeyFile" = "tls-private-key-file";
    "verbosity" = "v";
  };
in
{
  # TODO: Remove in NixOS 24.05
  imports =
    let
      base = ["services" "kubernetes" "controllerManager"];
    in
      (mapAttrsToList (n: v: mkRemovedOptionModule (base ++ [n]) v) removedOptions) ++
      (mapAttrsToList (n: v: mkRenamedOptionModule (base ++ (optName n)) (base ++ ["settings" v])) renamedOptions);

  ###### interface
  options.services.kubernetes.controllerManager = with types; {
    enable = mkEnableOption (mdDoc "Kubernetes controller manager");

    settings = mkOption {
      description = ''
        Configuration for kube-controller-manager, see:
          <https://kubernetes.io/docs/reference/command-line-tools-reference/kube-controller-manager>.
        All attrs defined here translates directly to flags of syntax `--<name>="<value>"`
        which is provided as command line argument to the kube-controller-manager binary.
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
  config = mkIf cfg.enable {
    systemd.services.kube-controller-manager = {
      description = "Kubernetes Controller Manager Service";
      wantedBy = [ "kubernetes.target" ];
      after = [ "kube-apiserver.service" ];
      serviceConfig = {
        RestartSec = "30s";
        Restart = "on-failure";
        Slice = "kubernetes.slice";
        ExecStart = ''${top.package}/bin/kube-controller-manager \
          ${concatStringsSep " \\\n" (mapAttrsToList (n: v: ''--${n}="${top.lib.renderArg v}"'') cfg.settings)}
        '';
        WorkingDirectory = top.dataDir;
        User = "kubernetes";
        Group = "kubernetes";
      };
      unitConfig = {
        StartLimitIntervalSec = 0;
      };
      path = top.path;
    };

    services.kubernetes.pki.certs = with top.lib; {
      controllerManager = mkCert {
        name = "kube-controller-manager";
        CN = "kube-controller-manager";
        action = "systemctl restart kube-controller-manager.service";
      };
      controllerManagerClient = mkCert {
        name = "kube-controller-manager-client";
        CN = "system:kube-controller-manager";
        action = "systemctl restart kube-controller-manager.service";
      };
    };
  };

  meta.buildDocsInSandbox = false;
}
