{ config, lib, options, pkgs, ... }:

with lib;

let
  top = config.services.kubernetes;
  otop = options.services.kubernetes;
  cfg = top.proxy;
in
{
  imports = [
    (mkRenamedOptionModule [ "services" "kubernetes" "proxy" "address" ] ["services" "kubernetes" "proxy" "bindAddress"])
  ];

  ###### interface
  options.services.kubernetes.proxy = with lib.types; {

    bindAddress = mkOption {
      description = lib.mdDoc "Kubernetes proxy listening address.";
      default = "0.0.0.0";
      type = str;
    };

    enable = mkEnableOption "Kubernetes proxy";

    extraOpts = mkOption {
      description = lib.mdDoc "Kubernetes proxy extra command line options.";
      default = "";
      type = separatedString " ";
    };

    featureGates = mkOption {
      description = lib.mdDoc "List set of feature gates";
      default = top.featureGates;
      defaultText = literalExpression "config.${otop.featureGates}";
      type = listOf str;
    };

    hostname = mkOption {
      description = lib.mdDoc "Kubernetes proxy hostname override.";
      default = config.networking.hostName;
      defaultText = literalExpression "config.networking.hostName";
      type = str;
    };

    kubeconfig = top.lib.mkKubeConfigOptions "Kubernetes proxy";

    verbosity = mkOption {
      description = lib.mdDoc ''
        Optional glog verbosity level for logging statements. See
        <https://github.com/kubernetes/community/blob/master/contributors/devel/logging.md>
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
      path = with pkgs; [ iptables conntrack-tools ];
      serviceConfig = {
        Slice = "kubernetes.slice";
        ExecStart = ''${top.package}/bin/kube-proxy \
          --bind-address=${cfg.bindAddress} \
          ${optionalString (top.clusterCidr!=null)
            "--cluster-cidr=${top.clusterCidr}"} \
          ${optionalString (cfg.featureGates != [])
            "--feature-gates=${concatMapStringsSep "," (feature: "${feature}=true") cfg.featureGates}"} \
          --hostname-override=${cfg.hostname} \
          --kubeconfig=${top.lib.mkKubeConfig "kube-proxy" cfg.kubeconfig} \
          ${optionalString (cfg.verbosity != null) "--v=${toString cfg.verbosity}"} \
          ${cfg.extraOpts}
        '';
        WorkingDirectory = top.dataDir;
        Restart = "on-failure";
        RestartSec = 5;
      };
      unitConfig = {
        StartLimitIntervalSec = 0;
      };
    };

    services.kubernetes.proxy.hostname = with config.networking; mkDefault hostName;

    services.kubernetes.pki.certs = {
      kubeProxyClient = top.lib.mkCert {
        name = "kube-proxy-client";
        CN = "system:kube-proxy";
        action = "systemctl restart kube-proxy.service";
      };
    };

    services.kubernetes.proxy.kubeconfig.server = mkDefault top.apiserverAddress;
  };

  meta.buildDocsInSandbox = false;
}
