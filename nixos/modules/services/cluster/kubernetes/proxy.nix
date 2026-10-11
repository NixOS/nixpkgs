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
  cfg = top.proxy;

  # --flag=value form; interpolate path literals so they end up in the store
  optionFormat = option: {
    option = "--${option}";
    sep = "=";
    explicitBool = true;
    formatArg = v: if builtins.isPath v then "${v}" else generators.mkValueStringDefault { } v;
  };
in
{
  imports = [
    (mkRenamedOptionModule
      [ "services" "kubernetes" "proxy" "address" ]
      [ "services" "kubernetes" "proxy" "bindAddress" ]
    )
  ];

  ###### interface
  options.services.kubernetes.proxy = with lib.types; {

    bindAddress = mkOption {
      description = "Kubernetes proxy listening address.";
      default = "0.0.0.0";
      type = str;
    };

    enable = mkEnableOption "Kubernetes proxy";

    extraOpts = mkOption {
      description = "Kubernetes proxy extra command line options.";
      default = "";
      type = separatedString " ";
    };

    featureGates = mkOption {
      description = "Attribute set of feature gates.";
      default = top.featureGates;
      defaultText = literalExpression "config.${otop.featureGates}";
      type = attrsOf bool;
    };

    hostname = mkOption {
      description = "Kubernetes proxy hostname override.";
      default = config.networking.hostName;
      defaultText = literalExpression "config.networking.hostName";
      type = str;
    };

    kubeconfig = top.lib.mkKubeConfigOptions "Kubernetes proxy";

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
    systemd.services.kube-proxy = {
      description = "Kubernetes Proxy Service";
      wantedBy = [ "kubernetes.target" ];
      after = [ "kube-apiserver.service" ];
      path = with pkgs; [
        iptables
        conntrack-tools
      ];
      serviceConfig = {
        Slice = "kubernetes.slice";
        ExecStart = concatStringsSep " " [
          "${top.package}/bin/kube-proxy"
          (cli.toCommandLineShell optionFormat {
            bind-address = cfg.bindAddress;
            cluster-cidr = top.clusterCidr;
            feature-gates =
              if cfg.featureGates == { } then
                null
              else
                concatStringsSep "," (
                  builtins.attrValues (mapAttrs (n: v: "${n}=${trivial.boolToString v}") cfg.featureGates)
                );
            hostname-override = cfg.hostname;
            kubeconfig = top.lib.mkKubeConfig "kube-proxy" cfg.kubeconfig;
            v = cfg.verbosity;
          })
          cfg.extraOpts
        ];
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
