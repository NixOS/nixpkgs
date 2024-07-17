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
  cfg = top.scheduler;
in
{
  ###### interface
  options.services.kubernetes.scheduler = with lib.types; {

    address = mkOption {
      description = "Kubernetes scheduler listening address.";
      default = "127.0.0.1";
      type = str;
    };

    enable = mkEnableOption "Kubernetes scheduler";

    extraOpts = mkOption {
      description = "Kubernetes scheduler extra command line options.";
      default = "";
      type = separatedString " ";
    };

    featureGates = mkOption {
      description = "List set of feature gates";
      default = top.featureGates;
      defaultText = literalExpression "config.${otop.featureGates}";
      type = listOf str;
    };

    kubeconfig = top.lib.mkKubeConfigOptions "Kubernetes scheduler";

    leaderElect = mkOption {
      description = "Whether to start leader election before executing main loop.";
      type = bool;
      default = true;
    };

    port = mkOption {
      description = "Kubernetes scheduler listening port.";
      default = 10251;
      type = port;
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
    systemd.services.kube-scheduler = {
      description = "Kubernetes Scheduler Service";
      wantedBy = [ "kubernetes.target" ];
      after = [ "kube-apiserver.service" ];
      serviceConfig = {
        Slice = "kubernetes.slice";
        ExecStart = ''
          ${top.package}/bin/kube-scheduler \
                    --bind-address=${cfg.address} \
                    ${
                      optionalString (cfg.featureGates != [ ])
                        "--feature-gates=${concatMapStringsSep "," (feature: "${feature}=true") cfg.featureGates}"
                    } \
                    --kubeconfig=${top.lib.mkKubeConfig "kube-scheduler" cfg.kubeconfig} \
                    --leader-elect=${boolToString cfg.leaderElect} \
                    --secure-port=${toString cfg.port} \
                    ${optionalString (cfg.verbosity != null) "--v=${toString cfg.verbosity}"} \
                    ${cfg.extraOpts}
        '';
        WorkingDirectory = top.dataDir;
        User = "kubernetes";
        Group = "kubernetes";
        Restart = "on-failure";
        RestartSec = 5;
      };
      unitConfig = {
        StartLimitIntervalSec = 0;
      };
    };

    services.kubernetes.pki.certs = {
      schedulerClient = top.lib.mkCert {
        name = "kube-scheduler-client";
        CN = "system:kube-scheduler";
        action = "systemctl restart kube-scheduler.service";
      };
    };

    services.kubernetes.scheduler.kubeconfig.server = mkDefault top.apiserverAddress;
  };

  meta.buildDocsInSandbox = false;
}
