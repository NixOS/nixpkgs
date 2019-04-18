{ config, lib, pkgs, ... }:

with lib;

let
  top = config.services.kubernetes;
  cfg = top.controllerManager;
in
{
  ###### interface
  options.services.kubernetes.controllerManager = with lib.types; {

    allocateNodeCIDRs = mkOption {
      description = "Whether to automatically allocate CIDR ranges for cluster nodes.";
      default = true;
      type = bool;
    };

    bindAddress = mkOption {
      description = "Kubernetes controller manager listening address.";
      default = "127.0.0.1";
      type = str;
    };

    clusterCidr = mkOption {
      description = "Kubernetes CIDR Range for Pods in cluster.";
      default = top.clusterCidr;
      type = str;
    };

    enable = mkEnableOption "Kubernetes controller manager.";

    extraOpts = mkOption {
      description = "Kubernetes controller manager extra command line options.";
      default = "";
      type = str;
    };

    featureGates = mkOption {
      description = "List set of feature gates";
      default = top.featureGates;
      type = listOf str;
    };

    insecurePort = mkOption {
      description = "Kubernetes controller manager insecure listening port.";
      default = 0;
      type = int;
    };

    kubeconfig = top.lib.mkKubeConfigOptions "Kubernetes controller manager";

    leaderElect = mkOption {
      description = "Whether to start leader election before executing main loop.";
      type = bool;
      default = true;
    };

    rootCaFile = mkOption {
      description = ''
        Kubernetes controller manager certificate authority file included in
        service account's token secret.
      '';
      default = top.caFile;
      type = nullOr path;
    };

    securePort = mkOption {
      description = "Kubernetes controller manager secure listening port.";
      default = 10252;
      type = int;
    };

    serviceAccountKeyFile = mkOption {
      description = ''
        Kubernetes controller manager PEM-encoded private RSA key file used to
        sign service account tokens
      '';
      default = null;
      type = nullOr path;
    };

    tlsCertFile = mkOption {
      description = "Kubernetes controller-manager certificate file.";
      default = null;
      type = nullOr path;
    };

    tlsKeyFile = mkOption {
      description = "Kubernetes controller-manager private key file.";
      default = null;
      type = nullOr path;
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
  config = let

    controllerManagerPaths = filter (a: a != null) [
      cfg.kubeconfig.caFile
      cfg.kubeconfig.certFile
      cfg.kubeconfig.keyFile
      cfg.rootCaFile
      cfg.serviceAccountKeyFile
      cfg.tlsCertFile
      cfg.tlsKeyFile
    ];

  in mkIf cfg.enable {
    systemd.services.kube-controller-manager = rec {
      description = "Kubernetes Controller Manager Service";
      wantedBy = [ "kube-control-plane-online.target" ];
      after = [ "kube-apiserver.service" ];
      before = [ "kube-control-plane-online.target" ];
      environment.KUBECONFIG = top.lib.mkKubeConfig "kube-controller-manager" cfg.kubeconfig;
      preStart = ''
        until kubectl auth can-i get /api -q 2>/dev/null; do
          echo kubectl auth can-i get /api: exit status $?
          sleep 2
        done
      '';
      serviceConfig = {
        RestartSec = "30s";
        Restart = "on-failure";
        Slice = "kubernetes.slice";
        ExecStart = ''${top.package}/bin/kube-controller-manager \
          --allocate-node-cidrs=${boolToString cfg.allocateNodeCIDRs} \
          --bind-address=${cfg.bindAddress} \
          ${optionalString (cfg.clusterCidr!=null)
            "--cluster-cidr=${cfg.clusterCidr}"} \
          ${optionalString (cfg.featureGates != [])
            "--feature-gates=${concatMapStringsSep "," (feature: "${feature}=true") cfg.featureGates}"} \
          --kubeconfig=${environment.KUBECONFIG} \
          --leader-elect=${boolToString cfg.leaderElect} \
          ${optionalString (cfg.rootCaFile!=null)
            "--root-ca-file=${cfg.rootCaFile}"} \
          --port=${toString cfg.insecurePort} \
          --secure-port=${toString cfg.securePort} \
          ${optionalString (cfg.serviceAccountKeyFile!=null)
            "--service-account-private-key-file=${cfg.serviceAccountKeyFile}"} \
          ${optionalString (cfg.tlsCertFile!=null)
            "--tls-cert-file=${cfg.tlsCertFile}"} \
          ${optionalString (cfg.tlsKeyFile!=null)
            "--tls-private-key-file=${cfg.tlsKeyFile}"} \
          ${optionalString (elem "RBAC" top.apiserver.authorizationMode)
            "--use-service-account-credentials"} \
          ${optionalString (cfg.verbosity != null) "--v=${toString cfg.verbosity}"} \
          ${cfg.extraOpts}
        '';
        WorkingDirectory = top.dataDir;
        User = "kubernetes";
        Group = "kubernetes";
      };
      path = top.path ++ [ pkgs.kubectl ];
      unitConfig.ConditionPathExists = controllerManagerPaths;
    };

    systemd.paths.kube-controller-manager = {
      wantedBy = [ "kube-controller-manager.service" ];
      pathConfig = {
        PathExists = controllerManagerPaths;
        PathChanged = controllerManagerPaths;
      };
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

    services.kubernetes.controllerManager.kubeconfig.server = mkDefault top.apiserverAddress;
  };
}
