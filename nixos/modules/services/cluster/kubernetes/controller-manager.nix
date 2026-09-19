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
  cfg = top.controllerManager;

  # --flag=value form; interpolate path literals so they end up in the store
  optionFormat = option: {
    option = "--${option}";
    sep = "=";
    explicitBool = option != "use-service-account-credentials";
    formatArg = v: if builtins.isPath v then "${v}" else lib.generators.mkValueStringDefault { } v;
  };
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "kubernetes" "controllerManager" "address" ]
      [ "services" "kubernetes" "controllerManager" "bindAddress" ]
    )
    (lib.mkRemovedOptionModule [ "services" "kubernetes" "controllerManager" "insecurePort" ] "")
  ];

  ###### interface
  options.services.kubernetes.controllerManager = with lib.types; {

    allocateNodeCIDRs = lib.mkOption {
      description = "Whether to automatically allocate CIDR ranges for cluster nodes.";
      default = true;
      type = bool;
    };

    bindAddress = lib.mkOption {
      description = "Kubernetes controller manager listening address.";
      default = "127.0.0.1";
      type = str;
    };

    clusterCidr = lib.mkOption {
      description = "Kubernetes CIDR Range for Pods in cluster.";
      default = top.clusterCidr;
      defaultText = lib.literalExpression "config.${otop.clusterCidr}";
      type = str;
    };

    enable = lib.mkEnableOption "Kubernetes controller manager";

    extraOpts = lib.mkOption {
      description = "Kubernetes controller manager extra command line options.";
      default = "";
      type = separatedString " ";
    };

    featureGates = lib.mkOption {
      description = "Attribute set of feature gates.";
      default = top.featureGates;
      defaultText = lib.literalExpression "config.${otop.featureGates}";
      type = attrsOf bool;
    };

    kubeconfig = top.lib.mkKubeConfigOptions "Kubernetes controller manager";

    leaderElect = lib.mkOption {
      description = "Whether to start leader election before executing main loop.";
      type = bool;
      default = true;
    };

    rootCaFile = lib.mkOption {
      description = ''
        Kubernetes controller manager certificate authority file included in
        service account's token secret.
      '';
      default = top.caFile;
      defaultText = lib.literalExpression "config.${otop.caFile}";
      type = nullOr path;
    };

    securePort = lib.mkOption {
      description = "Kubernetes controller manager secure listening port.";
      default = 10252;
      type = int;
    };

    serviceAccountKeyFile = lib.mkOption {
      description = ''
        Kubernetes controller manager PEM-encoded private RSA key file used to
        sign service account tokens
      '';
      default = null;
      type = nullOr path;
    };

    tlsCertFile = lib.mkOption {
      description = "Kubernetes controller-manager certificate file.";
      default = null;
      type = nullOr path;
    };

    tlsKeyFile = lib.mkOption {
      description = "Kubernetes controller-manager private key file.";
      default = null;
      type = nullOr path;
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
  config = lib.mkIf cfg.enable {
    systemd.services.kube-controller-manager = {
      description = "Kubernetes Controller Manager Service";
      wantedBy = [ "kubernetes.target" ];
      after = [ "kube-apiserver.service" ];
      serviceConfig = {
        RestartSec = "30s";
        Restart = "on-failure";
        Slice = "kubernetes.slice";
        ExecStart = lib.concatStringsSep " " [
          "${top.package}/bin/kube-controller-manager"
          (lib.cli.toCommandLineShell optionFormat {
            allocate-node-cidrs = cfg.allocateNodeCIDRs;
            bind-address = cfg.bindAddress;
            cluster-cidr = cfg.clusterCidr;
            feature-gates =
              if cfg.featureGates != { } then
                lib.concatStringsSep "," (
                  builtins.attrValues (lib.mapAttrs (n: v: "${n}=${lib.trivial.boolToString v}") cfg.featureGates)
                )
              else
                null;
            kubeconfig = top.lib.mkKubeConfig "kube-controller-manager" cfg.kubeconfig;
            leader-elect = cfg.leaderElect;
            root-ca-file = cfg.rootCaFile;
            secure-port = cfg.securePort;
            service-account-private-key-file = cfg.serviceAccountKeyFile;
            tls-cert-file = cfg.tlsCertFile;
            tls-private-key-file = cfg.tlsKeyFile;
            use-service-account-credentials = lib.elem "RBAC" top.apiserver.authorizationMode;
            v = cfg.verbosity;
          })
          cfg.extraOpts
        ];
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

    services.kubernetes.controllerManager.kubeconfig.server = lib.mkDefault top.apiserverAddress;
  };

  meta.buildDocsInSandbox = false;
}
