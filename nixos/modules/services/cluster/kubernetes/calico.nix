{ config, lib, pkgs, ... }:

with lib;

let
  top = config.services.kubernetes;
  cfg = top.calico;

  # we want calico to use kubernetes itself as configuration backend, not direct etcd
  storageBackend = "kubernetes";
in
{
  ###### interface
  options.services.kubernetes.calico = {
    enable = mkEnableOption "enable calico networking";
  };

  ###### implementation
  config = mkIf cfg.enable {
    services.calico = {

      enable = mkDefault true;
      network = mkDefault top.clusterCidr;
      inherit storageBackend;
      nodeName = config.services.kubernetes.kubelet.hostname;
    };

    services.kubernetes.kubelet = {
      networkPlugin = mkDefault "cni";
      cni.config = mkDefault [{
        name = "k8s-pod-network";
        cniVersion = "0.3.1";
        plugins = [
          {
            type = "calico";
            log_level = "info";
            datastore_type = "kubernetes";
            mtu = 1500;
            ipam.type = "calico-ipam";
            policy.type = "k8s";
            kubernetes.kubeconfig = "/etc/cni/net.d/calico-kubeconfig";
          }
          {
            type = "portmap";
            snat = true;
            capabilities.portMappings = true;
          }
        ];
      }];
    };

    networking = {
      firewall.allowedUDPPorts = [
        8285  # calico udp
        8472  # calico vxlan
      ];
      dhcpcd.denyInterfaces = [ "mynet*" "calico*" ];
    };

    services.kubernetes.pki.certs = {
      calicoCni = top.lib.mkCert {
        name = "calico-cni";
        CN = "calico-cni";
        action = "systemctl restart calico.service";
      };
    };

    # give calico som kubernetes rbac permissions if applicable
    services.kubernetes.addonManager.bootstrapAddons = mkIf (elem "RBAC" top.apiserver.authorizationMode) {
      calico-cni-cr = {
        apiVersion = "rbac.authorization.k8s.io/v1";
        kind = "ClusterRole";
        metadata = { name = "calico-cni"; };
        rules = [
          {
            apiGroups = [ "" ];
            resources = [ "pods" "nodes" "namespaces" ];
            verbs = [ "get" ];
          }
          {
            apiGroups = [ "" ];
            resources = [ "pods/status" ];
            verbs = [ "patch" ];
          }
          {
            apiGroups = [ "crd.projectcalico.org" ];
            resources = [
              "blockaffinities"
              "ipamblocks"
              "ipamhandles"
            ];
            verbs = [
              "get"
              "list"
              "create"
              "update"
              "delete"
            ];
          }
          {
            apiGroups = [ "crd.projectcalico.org" ];
            resources = [
              "ipamconfigs"
              "clusterinformations"
              "ippools"
            ];
            verbs = [ "get" "list" ];
          }
        ];
      };

      calico-cni-crb = {
        apiVersion = "rbac.authorization.k8s.io/v1";
        kind = "ClusterRoleBinding";
        metadata = { name = "calico-cni"; };
        roleRef = {
          apiGroup = "rbac.authorization.k8s.io";
          kind = "ClusterRole";
          name = "calico-cni";
        };
        subjects = [{
          kind = "User";
          name = "cal";
        }];
      };
    };
  };
}
