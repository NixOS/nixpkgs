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
  config = mkIf cfg.enable {
    systemd.services.kube-proxy = {
      description = "Kubernetes Proxy Service";
      wantedBy = [ "kubernetes.target" ];
      after = [ "kube-apiserver.service" ];
      path = with pkgs; [ iptables conntrack_tools ];
      serviceConfig = {
        Slice = "kubernetes.slice";
        ExecStart = ''${top.package}/bin/kube-proxy \
          --bind-address=${cfg.bindAddress} \
          ${optionalString (top.clusterCidr!=null)
            "--cluster-cidr=${top.clusterCidr}"} \
          ${optionalString (cfg.featureGates != [])
            "--feature-gates=${concatMapStringsSep "," (feature: "${feature}=true") cfg.featureGates}"} \
          --kubeconfig=${top.lib.mkKubeConfig "kube-proxy" cfg.kubeconfig} \
          ${optionalString (cfg.verbosity != null) "--v=${toString cfg.verbosity}"} \
          ${cfg.extraOpts}
        '';
        WorkingDirectory = top.dataDir;
        Restart = "on-failure";
        RestartSec = 5;
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
