{ config, lib, pkgs, ... }:

with lib;

let
  top = config.services.kubernetes;
  cfg = top.proxy;
in
{

  ###### interface
  options.services.kubernetes.proxy = with lib.types; {

    bindAddress = mkOption {
      description = "Kubernetes proxy listening address.";
      default = "0.0.0.0";
      type = str;
    };

    enable = mkEnableOption "Whether to enable Kubernetes proxy.";

    extraOpts = mkOption {
      description = "Kubernetes proxy extra command line options.";
      default = "";
      type = str;
    };

    featureGates = mkOption {
      description = "List set of feature gates";
      default = top.featureGates;
      type = listOf str;
    };

    kubeconfig = top.lib.mkKubeConfigOptions "Kubernetes proxy";

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

    proxyPaths = filter (a: a != null) [
      cfg.kubeconfig.caFile
      cfg.kubeconfig.certFile
      cfg.kubeconfig.keyFile
    ];

  in mkIf cfg.enable {
    systemd.services.kube-proxy = rec {
      description = "Kubernetes Proxy Service";
      wantedBy = [ "kube-node-online.target" ];
      after = [ "kubelet-online.service" ];
      before = [ "kube-node-online.target" ];
      environment.KUBECONFIG = top.lib.mkKubeConfig "kube-proxy" cfg.kubeconfig;
      path = with pkgs; [ iptables conntrack_tools kubectl ];
      preStart = ''
        until kubectl auth can-i get nodes/${top.kubelet.hostname} -q 2>/dev/null; do
          echo kubectl auth can-i get nodes/${top.kubelet.hostname}: exit status $?
          sleep 2
        done
      '';
      serviceConfig = {
        Slice = "kubernetes.slice";
        ExecStart = ''${top.package}/bin/kube-proxy \
          --bind-address=${cfg.bindAddress} \
          ${optionalString (top.clusterCidr!=null)
            "--cluster-cidr=${top.clusterCidr}"} \
          ${optionalString (cfg.featureGates != [])
            "--feature-gates=${concatMapStringsSep "," (feature: "${feature}=true") cfg.featureGates}"} \
          --kubeconfig=${environment.KUBECONFIG} \
          ${optionalString (cfg.verbosity != null) "--v=${toString cfg.verbosity}"} \
          ${cfg.extraOpts}
        '';
        WorkingDirectory = top.dataDir;
        Restart = "on-failure";
        RestartSec = 5;
      };
      unitConfig.ConditionPathExists = proxyPaths;
    };

    systemd.paths.kube-proxy = {
      wantedBy = [ "kube-proxy.service" ];
      pathConfig = {
        PathExists = proxyPaths;
        PathChanged = proxyPaths;
      };
    };

    services.kubernetes.pki.certs = {
      kubeProxyClient = top.lib.mkCert {
        name = "kube-proxy-client";
        CN = "system:kube-proxy";
        action = "systemctl restart kube-proxy.service";
      };
    };

    services.kubernetes.proxy.kubeconfig.server = mkDefault top.apiserverAddress;
  };
}
