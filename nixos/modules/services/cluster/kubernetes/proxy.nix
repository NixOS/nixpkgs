{ config, lib, pkgs, ... }: with lib;
let
  top = config.services.kubernetes;
  cfg = top.proxy;

  # TODO: Remove in NixOS 24.05
  removedOptions = {
    "extraOpts" = "Use freeform settings";
  };

  # TODO: Remove in NixOS 24.05
  optName = n: builtins.filter (f: f != []) (builtins.split "\\." n);

  # TODO: Remove in NixOS 24.05
  renamedOptions = {
    "bindAddress" = "bind-address";
    "featureGates" = "feature-gates";
    "hostname" = "hostname-override";
    "kubeconfig" = "kubeconfig";
    "verbosity" = "v";
  };
in
{
  # TODO: Remove in NixOS 24.05
  imports =
    let
      base = ["services" "kubernetes" "proxy"];
    in
      (mapAttrsToList (n: v: mkRemovedOptionModule (base ++ [n]) v) removedOptions) ++
      (mapAttrsToList (n: v: mkRenamedOptionModule (base ++ (optName n)) (base ++ ["settings" v])) renamedOptions);

  ###### interface
  options.services.kubernetes.proxy = with lib.types; {

    enable = mkEnableOption (lib.mdDoc "Kubernetes proxy");

    settings = mkOption {
      description = ''
        Configuration for kube-proxy, see:
          <https://kubernetes.io/docs/reference/command-line-tools-reference/kube-proxy>.
        All attrs defined here translates directly to flags of syntax `--<name>="<value>"`
        which is provided as command line argument to the kube-proxy binary.
      '';
      type = types.submodule {
        freeformType = attrsOf (oneOf [
          bool
          float
          int
          (listOf str)
          package
          path
          str
        ]);
      };
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
          ${concatStringsSep " \\\n" (mapAttrsToList (n: v: ''--${n}="${top.lib.renderArg v}"'') cfg.settings)}
        '';
        WorkingDirectory = top.dataDir;
        Restart = "on-failure";
        RestartSec = 5;
      };
      unitConfig = {
        StartLimitIntervalSec = 0;
      };
    };

    services.kubernetes.pki.certs = {
      kubeProxyClient = top.lib.mkCert {
        name = "kube-proxy-client";
        CN = "system:kube-proxy";
        action = "systemctl restart kube-proxy.service";
      };
    };
  };

  meta.buildDocsInSandbox = false;
}
