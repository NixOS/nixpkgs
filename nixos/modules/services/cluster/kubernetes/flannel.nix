{ config, lib, pkgs, ... }:

with lib;

let
  top = config.services.kubernetes;
  cfg = top.flannel;

  # we want flannel to use kubernetes itself as configuration backend, not direct etcd
  storageBackend = "kubernetes";
in
{
  ###### interface
  options.services.kubernetes.flannel = {
    enable = mkEnableOption (lib.mdDoc "flannel networking");
  };

  ###### implementation
  config = mkIf cfg.enable {
    services.flannel = {

      enable = mkDefault true;
      network = mkDefault top.clusterCidr;
      inherit storageBackend;
      nodeName = config.services.kubernetes.kubelet.hostname;
    };

    services.kubernetes.kubelet = {
      cni.config = mkDefault [{
        name = "mynet";
        type = "flannel";
        cniVersion = "0.3.1";
        delegate = {
          isDefaultGateway = true;
          bridge = "mynet";
        };
      }];
    };

    networking = {
      firewall.allowedUDPPorts = [
        8285  # flannel udp
        8472  # flannel vxlan
      ];
      dhcpcd.denyInterfaces = [ "mynet*" "flannel*" ];
    };

    services.kubernetes.pki.certs = {
      flannelClient = top.lib.mkCert {
        name = "flannel-client";
        CN = "flannel-client";
        action = "systemctl restart flannel.service";
      };
    };

    # give flannel som kubernetes rbac permissions if applicable
    services.kubernetes.addonManager.bootstrapAddons = mkIf ((storageBackend == "kubernetes") && (elem "RBAC" top.apiserver.authorizationMode)) {

      flannel-cr = {
        apiVersion = "rbac.authorization.k8s.io/v1";
        kind = "ClusterRole";
        metadata = { name = "flannel"; };
        rules = [{
          apiGroups = [ "" ];
          resources = [ "pods" ];
          verbs = [ "get" ];
        }
        {
          apiGroups = [ "" ];
          resources = [ "nodes" ];
          verbs = [ "list" "watch" ];
        }
        {
          apiGroups = [ "" ];
          resources = [ "nodes/status" ];
          verbs = [ "patch" ];
        }];
      };

      flannel-crb = {
        apiVersion = "rbac.authorization.k8s.io/v1";
        kind = "ClusterRoleBinding";
        metadata = { name = "flannel"; };
        roleRef = {
          apiGroup = "rbac.authorization.k8s.io";
          kind = "ClusterRole";
          name = "flannel";
        };
        subjects = [{
          kind = "User";
          name = "flannel-client";
        }];
      };

    };
  };

  meta.buildDocsInSandbox = false;
}
