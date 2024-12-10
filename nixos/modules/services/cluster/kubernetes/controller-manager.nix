{
  config,
  lib,
  options,
  pkgs,
  ...
}:

with lib;

let
  top = config.services.kubernetes;
  otop = options.services.kubernetes;
  cfg = top.controllerManager;
in
{
  imports = [
    (mkRenamedOptionModule
      [ "services" "kubernetes" "controllerManager" "address" ]
      [ "services" "kubernetes" "controllerManager" "bindAddress" ]
    )
    (mkRemovedOptionModule [ "services" "kubernetes" "controllerManager" "insecurePort" ] "")
  ];

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
      defaultText = literalExpression "config.${otop.clusterCidr}";
      type = str;
    };

    enable = mkEnableOption "Kubernetes controller manager";

    extraOpts = mkOption {
      description = "Kubernetes controller manager extra command line options.";
      default = "";
      type = separatedString " ";
    };

    featureGates = mkOption {
      description = "Attribute set of feature gates.";
      default = top.featureGates;
      defaultText = literalExpression "config.${otop.featureGates}";
      type = attrsOf bool;
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
      defaultText = literalExpression "config.${otop.caFile}";
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
        <https://github.com/kubernetes/community/blob/master/contributors/devel/logging.md>
      '';
      default = null;
      type = nullOr int;
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
        ExecStart = ''
          ${top.package}/bin/kube-controller-manager \
                    --allocate-node-cidrs=${boolToString cfg.allocateNodeCIDRs} \
                    --bind-address=${cfg.bindAddress} \
                    ${optionalString (cfg.clusterCidr != null) "--cluster-cidr=${cfg.clusterCidr}"} \
                    ${
                      optionalString (cfg.featureGates != { })
                        "--feature-gates=${
                          concatStringsSep "," (
                            builtins.attrValues (mapAttrs (n: v: "${n}=${trivial.boolToString v}") cfg.featureGates)
                          )
                        }"
                    } \
                    --kubeconfig=${top.lib.mkKubeConfig "kube-controller-manager" cfg.kubeconfig} \
                    --leader-elect=${boolToString cfg.leaderElect} \
                    ${optionalString (cfg.rootCaFile != null) "--root-ca-file=${cfg.rootCaFile}"} \
                    --secure-port=${toString cfg.securePort} \
                    ${
                      optionalString (
                        cfg.serviceAccountKeyFile != null
                      ) "--service-account-private-key-file=${cfg.serviceAccountKeyFile}"
                    } \
                    ${optionalString (cfg.tlsCertFile != null) "--tls-cert-file=${cfg.tlsCertFile}"} \
                    ${optionalString (cfg.tlsKeyFile != null) "--tls-private-key-file=${cfg.tlsKeyFile}"} \
                    ${optionalString (elem "RBAC" top.apiserver.authorizationMode) "--use-service-account-credentials"} \
                    ${optionalString (cfg.verbosity != null) "--v=${toString cfg.verbosity}"} \
                    ${cfg.extraOpts}
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

    services.kubernetes.controllerManager.kubeconfig.server = mkDefault top.apiserverAddress;
  };

  meta.buildDocsInSandbox = false;
}
