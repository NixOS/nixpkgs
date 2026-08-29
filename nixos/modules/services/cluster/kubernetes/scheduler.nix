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

  # --flag=value form; interpolate path literals so they end up in the store
  optionFormat = option: {
    option = "--${option}";
    sep = "=";
    explicitBool = true;
    formatArg = v: if builtins.isPath v then "${v}" else lib.generators.mkValueStringDefault { } v;
  };
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
        ExecStart = lib.concatStringsSep " " [
          "${top.package}/bin/kube-scheduler"
          (lib.cli.toCommandLineShell optionFormat {
            bind-address = cfg.address;
            feature-gates =
              if cfg.featureGates == { } then
                null
              else
                lib.concatStringsSep "," (lib.mapAttrsToList (n: v: "${n}=${lib.boolToString v}") cfg.featureGates);
            kubeconfig = top.lib.mkKubeConfig "kube-scheduler" cfg.kubeconfig;
            leader-elect = cfg.leaderElect;
            secure-port = cfg.port;
            v = cfg.verbosity;
          })
          cfg.extraOpts
        ];
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
