{ config, lib, options, pkgs, ... }:

let
  top = config.services.kubernetes;
  otop = options.services.kubernetes;
  cfg = top.proxy;
in
{
  imports = [
    (lib.mkRenamedOptionModule [ "services" "kubernetes" "proxy" "address" ] ["services" "kubernetes" "proxy" "bindAddress"])
  ];

  ###### interface
  options.services.kubernetes.proxy = with lib.types; {

    bindAddress = lib.mkOption {
      description = "Kubernetes proxy listening address.";
      default = "0.0.0.0";
      type = str;
    };

    enable = lib.mkEnableOption "Kubernetes proxy";

    extraOpts = lib.mkOption {
      description = "Kubernetes proxy extra command line options.";
      default = "";
      type = separatedString " ";
    };

    featureGates = lib.mkOption {
      description = "Attribute set of feature gates.";
      default = top.featureGates;
      defaultText = lib.literalExpression "config.${otop.featureGates}";
      type = attrsOf bool;
    };

    hostname = lib.mkOption {
      description = "Kubernetes proxy hostname override.";
      default = config.networking.hostName;
      defaultText = lib.literalExpression "config.networking.hostName";
      type = str;
    };

    kubeconfig = top.lib.mkKubeConfigOptions "Kubernetes proxy";

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
    systemd.services.kube-proxy = {
      description = "Kubernetes Proxy Service";
      wantedBy = [ "kubernetes.target" ];
      after = [ "kube-apiserver.service" ];
      path = with pkgs; [ iptables conntrack-tools ];
      serviceConfig = {
        Slice = "kubernetes.slice";
        ExecStart = ''${top.package}/bin/kube-proxy \
          --bind-address=${cfg.bindAddress} \
          ${lib.optionalString (top.clusterCidr!=null)
            "--cluster-cidr=${top.clusterCidr}"} \
          ${lib.optionalString (cfg.featureGates != {})
            "--feature-gates=${lib.concatStringsSep "," (builtins.attrValues (lib.mapAttrs (n: v: "${n}=${lib.trivial.boolToString v}") cfg.featureGates))}"} \
          --hostname-override=${cfg.hostname} \
          --kubeconfig=${top.lib.mkKubeConfig "kube-proxy" cfg.kubeconfig} \
          ${lib.optionalString (cfg.verbosity != null) "--v=${toString cfg.verbosity}"} \
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

    services.kubernetes.proxy.kubeconfig.server = lib.mkDefault top.apiserverAddress;
  };

  meta.buildDocsInSandbox = false;
}
