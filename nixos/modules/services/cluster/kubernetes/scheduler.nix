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
  cfg = top.scheduler;
in
{
  ###### interface
  options.services.kubernetes.scheduler = with lib.types; {

    address = lib.mkOption {
      description = "Kubernetes scheduler listening address.";
      default = "127.0.0.1";
      type = str;
    };

    enable = lib.mkEnableOption "Kubernetes scheduler";

    extraOpts = lib.mkOption {
      description = "Kubernetes scheduler extra command line options.";
      default = "";
      type = separatedString " ";
    };

    featureGates = lib.mkOption {
      description = "Attribute set of feature gates.";
      default = top.featureGates;
      defaultText = lib.literalExpression "config.${otop.featureGates}";
      type = attrsOf bool;
    };

    kubeconfig = top.lib.mkKubeConfigOptions "Kubernetes scheduler";

    leaderElect = lib.mkOption {
      description = "Whether to start leader election before executing main loop.";
      type = bool;
      default = true;
    };

    port = lib.mkOption {
      description = "Kubernetes scheduler listening port.";
      default = 10251;
      type = port;
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
                      lib.optionalString (cfg.featureGates != { })
                        "--feature-gates=${
                          lib.concatStringsSep "," (
                            builtins.attrValues (lib.mapAttrs (n: v: "${n}=${lib.trivial.boolToString v}") cfg.featureGates)
                          )
                        }"
                    } \
                    --kubeconfig=${top.lib.mkKubeConfig "kube-scheduler" cfg.kubeconfig} \
                    --leader-elect=${lib.boolToString cfg.leaderElect} \
                    --secure-port=${toString cfg.port} \
                    ${lib.optionalString (cfg.verbosity != null) "--v=${toString cfg.verbosity}"} \
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

    services.kubernetes.scheduler.kubeconfig.server = lib.mkDefault top.apiserverAddress;
  };

  meta.buildDocsInSandbox = false;
}
