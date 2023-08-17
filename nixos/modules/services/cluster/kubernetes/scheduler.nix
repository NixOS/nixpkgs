{ config, lib, pkgs, ... }:

with lib;

let
  top = config.services.kubernetes;
  cfg = top.scheduler;

  # TODO: Remove in NixOS 24.05
  removedOptions = {
    "extraOpts" = "Use freeform settings";
  };

  # TODO: Remove in NixOS 24.05
  optName = n: builtins.filter (f: f != []) (builtins.split "\\." n);

  # TODO: Remove in NixOS 24.05
  renamedOptions = {
    "address" = "bind-address";
    "featureGates" = "feature-gates";
    "kubeconfig" = "kubeconfig";
    "leaderElect" = "leader-elect";
    "port" = "secure-port";
    "verbosity" = "v";
  };
in
{
  # TODO: Remove in NixOS 24.05
  imports =
    let
      base = ["services" "kubernetes" "scheduler"];
    in
      (mapAttrsToList (n: v: mkRemovedOptionModule (base ++ [n]) v) removedOptions) ++
      (mapAttrsToList (n: v: mkRenamedOptionModule (base ++ (optName n)) (base ++ ["settings" v])) renamedOptions);

  ###### interface
  options.services.kubernetes.scheduler = with lib.types; {

    enable = mkEnableOption (lib.mdDoc "Kubernetes scheduler");

    settings = mkOption {
      description = ''
        Configuration for kube-scheduler, see:
          <https://kubernetes.io/docs/reference/command-line-tools-reference/kube-scheduler>.
        All attrs defined here translates directly to flags of syntax `--<name>="<value>"`
        which is provided as command line argument to the kube-scheduler binary.
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
    systemd.services.kube-scheduler = {
      description = "Kubernetes Scheduler Service";
      wantedBy = [ "kubernetes.target" ];
      after = [ "kube-apiserver.service" ];
      serviceConfig = {
        Slice = "kubernetes.slice";
        ExecStart = ''${top.package}/bin/kube-scheduler \
          ${concatStringsSep " \\\n" (mapAttrsToList (n: v: ''--${n}="${top.lib.renderArg v}"'') cfg.settings)}
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
  };

  meta.buildDocsInSandbox = false;
}
