{
  config,
  lib,
  pkgs,
  ...
}:
let
  top = config.services.kubernetes;
  cfg = top.flannel;

  # we want flannel to use kubernetes itself as configuration backend, not direct etcd
  storageBackend = "kubernetes";
in
{
  ###### interface
  options.services.kubernetes.flannel = {
    enable = lib.mkEnableOption "flannel networking";

    openFirewallPorts = lib.mkOption {
      description = ''Whether to open the Flannel UDP ports in the firewall on all interfaces.'';
      type = lib.types.bool;
      default = true;
    };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.flannel = {

      enable = lib.mkDefault true;
      network = lib.mkDefault top.clusterCidr;
      inherit storageBackend;
      nodeName = config.services.kubernetes.kubelet.hostname;
    };

    services.kubernetes.kubelet = {
      cni.config = lib.mkDefault [
        {
          name = "mynet";
          type = "flannel";
          cniVersion = "0.3.1";
          delegate = {
            isDefaultGateway = true;
            hairpinMode = true;
            bridge = "mynet";
          };
        }
      ];
    };

    networking = {
      firewall.allowedUDPPorts = lib.mkIf cfg.openFirewallPorts [
        8285 # flannel udp
        8472 # flannel vxlan
      ];
      dhcpcd.denyInterfaces = [
        "mynet*"
        "flannel*"
      ];
    };

    services.kubernetes.pki.certs = {
      flannelClient = top.lib.mkCert {
        name = "flannel-client";
        CN = "flannel-client";
        action = "systemctl restart flannel.service";
      };
    };

    # give flannel some kubernetes rbac permissions if applicable
    services.kubernetes.addonManager.bootstrapAddons =
      lib.mkIf ((storageBackend == "kubernetes") && (lib.elem "RBAC" top.apiserver.authorizationMode))
        {

          flannel-cr = {
            apiVersion = "rbac.authorization.k8s.io/v1";
            kind = "ClusterRole";
            metadata = {
              name = "flannel";
            };
            rules = [
              {
                apiGroups = [ "" ];
                resources = [ "pods" ];
                verbs = [ "get" ];
              }
              {
                apiGroups = [ "" ];
                resources = [ "nodes" ];
                verbs = [
                  "list"
                  "watch"
                ];
              }
              {
                apiGroups = [ "" ];
                resources = [ "nodes/status" ];
                verbs = [ "patch" ];
              }
            ];
          };

          flannel-crb = {
            apiVersion = "rbac.authorization.k8s.io/v1";
            kind = "ClusterRoleBinding";
            metadata = {
              name = "flannel";
            };
            roleRef = {
              apiGroup = "rbac.authorization.k8s.io";
              kind = "ClusterRole";
              name = "flannel";
            };
            subjects = [
              {
                kind = "User";
                name = "flannel-client";
              }
            ];
          };

        };
  };

  meta.buildDocsInSandbox = false;
}
