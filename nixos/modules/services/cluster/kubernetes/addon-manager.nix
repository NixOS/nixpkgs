{ config, lib, pkgs, ... }:

with lib;

let
  top = config.services.kubernetes;
  cfg = top.addonManager;

  isRBACEnabled = elem "RBAC" top.apiserver.authorizationMode;

  addons = pkgs.runCommand "kubernetes-addons" { } ''
    mkdir -p $out
    # since we are mounting the addons to the addon manager, they need to be copied
    ${concatMapStringsSep ";" (a: "cp -v ${a}/* $out/") (mapAttrsToList (name: addon:
      pkgs.writeTextDir "${name}.json" (builtins.toJSON addon)
    ) (cfg.addons))}
  '';
in
{
  ###### interface
  options.services.kubernetes.addonManager = with lib.types; {

    bootstrapAddons = mkOption {
      description = ''
        Bootstrap addons are like regular addons, but they are applied with cluster-admin rigths.
        They are applied at addon-manager startup only.
      '';
      default = { };
      type = attrsOf attrs;
      example = literalExample ''
        {
          "my-service" = {
            "apiVersion" = "v1";
            "kind" = "Service";
            "metadata" = {
              "name" = "my-service";
              "namespace" = "default";
            };
            "spec" = { ... };
          };
        }
      '';
    };

    addons = mkOption {
      description = "Kubernetes addons (any kind of Kubernetes resource can be an addon).";
      default = { };
      type = attrsOf (either attrs (listOf attrs));
      example = literalExample ''
        {
          "my-service" = {
            "apiVersion" = "v1";
            "kind" = "Service";
            "metadata" = {
              "name" = "my-service";
              "namespace" = "default";
            };
            "spec" = { ... };
          };
        }
        // import <nixpkgs/nixos/modules/services/cluster/kubernetes/dashboard.nix> { cfg = config.services.kubernetes; };
      '';
    };

    enable = mkEnableOption "Whether to enable Kubernetes addon manager.";

    kubeconfig = top.lib.mkKubeConfigOptions "Kubernetes addon manager";
    bootstrapAddonsKubeconfig = top.lib.mkKubeConfigOptions "Kubernetes addon manager bootstrap";
  };

  ###### implementation
  config = let

    addonManagerPaths = filter (a: a != null) [
      cfg.kubeconfig.caFile
      cfg.kubeconfig.certFile
      cfg.kubeconfig.keyFile
    ];
    bootstrapAddonsPaths = filter (a: a != null) [
      cfg.bootstrapAddonsKubeconfig.caFile
      cfg.bootstrapAddonsKubeconfig.certFile
      cfg.bootstrapAddonsKubeconfig.keyFile
    ];

  in mkIf cfg.enable {
    environment.etc."kubernetes/addons".source = "${addons}/";

    #TODO: Get rid of kube-addon-manager in the future for the following reasons
    # - it is basically just a shell script wrapped around kubectl
    # - it assumes that it is clusterAdmin or can gain clusterAdmin rights through serviceAccount
    # - it is designed to be used with k8s system components only
    # - it would be better with a more Nix-oriented way of managing addons
    systemd.services.kube-addon-manager = {
      description = "Kubernetes addon manager";
      wantedBy = [ "kubernetes.target" ];
      after = [ "kube-node-online.target" ];
      before = [ "kubernetes.target" ];
      environment = {
        ADDON_PATH = "/etc/kubernetes/addons/";
        KUBECONFIG = top.lib.mkKubeConfig "kube-addon-manager" cfg.kubeconfig;
      };
      path = with pkgs; [ gawk kubectl ];
      preStart = ''
        until kubectl -n kube-system get serviceaccounts/default 2>/dev/null; do
          echo kubectl -n kube-system get serviceaccounts/default: exit status $?
          sleep 2
        done
      '';
      serviceConfig = {
        Slice = "kubernetes.slice";
        ExecStart = "${top.package}/bin/kube-addons";
        WorkingDirectory = top.dataDir;
        User = "kubernetes";
        Group = "kubernetes";
        Restart = "on-failure";
        RestartSec = 10;
      };
      unitConfig.ConditionPathExists = addonManagerPaths;
    };

    systemd.paths.kube-addon-manager = {
      wantedBy = [ "kube-addon-manager.service" ];
      pathConfig = {
        PathExists = addonManagerPaths;
        PathChanged = addonManagerPaths;
      };
    };

    services.kubernetes.addonManager.kubeconfig.server = mkDefault top.apiserverAddress;

    systemd.services.kube-addon-manager-bootstrap = mkIf (top.apiserver.enable && top.addonManager.bootstrapAddons != {}) {
      wantedBy = [ "kube-control-plane-online.target" ];
      after = [ "kube-apiserver.service" ];
      before = [ "kube-control-plane-online.target" ];
      path = [ pkgs.kubectl ];
      environment = {
        KUBECONFIG = top.lib.mkKubeConfig "kube-addon-manager-bootstrap" cfg.bootstrapAddonsKubeconfig;
      };
      preStart = with pkgs; let
        files = mapAttrsToList (n: v: writeText "${n}.json" (builtins.toJSON v))
          cfg.bootstrapAddons;
      in ''
        until kubectl auth can-i '*' '*' -q 2>/dev/null; do
          echo kubectl auth can-i '*' '*': exit status $?
          sleep 2
        done

        kubectl apply -f ${concatStringsSep " \\\n -f " files}
      '';
      script = "echo Ok";
      unitConfig.ConditionPathExists = bootstrapAddonsPaths;
    };

    systemd.paths.kube-addon-manager-bootstrap = {
      wantedBy = [ "kube-addon-manager-bootstrap.service" ];
      pathConfig = {
        PathExists = bootstrapAddonsPaths;
        PathChanged = bootstrapAddonsPaths;
      };
    };

    services.kubernetes.addonManager.bootstrapAddonsKubeconfig.server = mkDefault top.apiserverAddress;

    services.kubernetes.addonManager.bootstrapAddons = mkIf isRBACEnabled
    (let
      name = system:kube-addon-manager;
      namespace = "kube-system";
    in
    {

      kube-addon-manager-r = {
        apiVersion = "rbac.authorization.k8s.io/v1";
        kind = "Role";
        metadata = {
          inherit name namespace;
        };
        rules = [{
          apiGroups = ["*"];
          resources = ["*"];
          verbs = ["*"];
        }];
      };

      kube-addon-manager-rb = {
        apiVersion = "rbac.authorization.k8s.io/v1";
        kind = "RoleBinding";
        metadata = {
          inherit name namespace;
        };
        roleRef = {
          apiGroup = "rbac.authorization.k8s.io";
          kind = "Role";
          inherit name;
        };
        subjects = [{
          apiGroup = "rbac.authorization.k8s.io";
          kind = "User";
          inherit name;
        }];
      };

      kube-addon-manager-cluster-lister-cr = {
        apiVersion = "rbac.authorization.k8s.io/v1";
        kind = "ClusterRole";
        metadata = {
          name = "${name}:cluster-lister";
        };
        rules = [{
          apiGroups = ["*"];
          resources = ["*"];
          verbs = ["list"];
        }];
      };

      kube-addon-manager-cluster-lister-crb = {
        apiVersion = "rbac.authorization.k8s.io/v1";
        kind = "ClusterRoleBinding";
        metadata = {
          name = "${name}:cluster-lister";
        };
        roleRef = {
          apiGroup = "rbac.authorization.k8s.io";
          kind = "ClusterRole";
          name = "${name}:cluster-lister";
        };
        subjects = [{
          kind = "User";
          inherit name;
        }];
      };
    });

    services.kubernetes.pki.certs = {
      addonManager = top.lib.mkCert {
        name = "kube-addon-manager";
        CN = "system:kube-addon-manager";
        action = "systemctl restart kube-addon-manager.service";
      };
    };
  };

}
