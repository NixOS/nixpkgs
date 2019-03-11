{ config, lib, pkgs, ... }:

with lib;

let
  top = config.services.kubernetes;
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

    enable = mkEnableOption "Whether to enable Kubernetes scheduler.";

    extraOpts = mkOption {
      description = "Kubernetes scheduler extra command line options.";
      default = "";
      type = str;
    };

    featureGates = mkOption {
      description = "List set of feature gates";
      default = top.featureGates;
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
      type = int;
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
  config =  let

    schedulerPaths = filter (a: a != null) [
      cfg.kubeconfig.caFile
      cfg.kubeconfig.certFile
      cfg.kubeconfig.keyFile
    ];

  in mkIf cfg.enable {
    systemd.services.kube-scheduler = rec {
      description = "Kubernetes Scheduler Service";
      wantedBy = [ "kube-control-plane-online.target" ];
      after = [ "kube-apiserver.service" ];
      before = [ "kube-control-plane-online.target" ];
      environment.KUBECONFIG = top.lib.mkKubeConfig "kube-scheduler" cfg.kubeconfig;
      path = [ pkgs.kubectl ];
      preStart = ''
        until kubectl auth can-i get /api -q 2>/dev/null; do
          echo kubectl auth can-i get /api: exit status $?
          sleep 2
        done
      '';
      serviceConfig = {
        Slice = "kubernetes.slice";
        ExecStart = ''${top.package}/bin/kube-scheduler \
          --address=${cfg.address} \
          ${optionalString (cfg.featureGates != [])
            "--feature-gates=${concatMapStringsSep "," (feature: "${feature}=true") cfg.featureGates}"} \
          --kubeconfig=${environment.KUBECONFIG} \
          --leader-elect=${boolToString cfg.leaderElect} \
          --port=${toString cfg.port} \
          ${optionalString (cfg.verbosity != null) "--v=${toString cfg.verbosity}"} \
          ${cfg.extraOpts}
        '';
        WorkingDirectory = top.dataDir;
        User = "kubernetes";
        Group = "kubernetes";
        Restart = "on-failure";
        RestartSec = 5;
      };
      unitConfig.ConditionPathExists = schedulerPaths;
    };

    systemd.paths.kube-scheduler = {
      wantedBy = [ "kube-scheduler.service" ];
      pathConfig = {
        PathExists = schedulerPaths;
        PathChanged = schedulerPaths;
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
}
