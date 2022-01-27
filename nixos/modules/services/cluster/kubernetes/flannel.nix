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
    enable = mkEnableOption "enable flannel networking";
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
      networkPlugin = mkDefault "cni";
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
  };

  meta.buildDocsInSandbox = false;
}
