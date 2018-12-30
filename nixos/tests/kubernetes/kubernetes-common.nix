{ roles, config, pkgs, certs }:
with pkgs.lib;
let
  base = {
    inherit roles;
    flannel.enable = true;
    addons.dashboard.enable = true;

    caFile = "${certs.master}/ca.pem";
    apiserver = {
      tlsCertFile = "${certs.master}/kube-apiserver.pem";
      tlsKeyFile = "${certs.master}/kube-apiserver-key.pem";
      kubeletClientCertFile = "${certs.master}/kubelet-client.pem";
      kubeletClientKeyFile = "${certs.master}/kubelet-client-key.pem";
      serviceAccountKeyFile = "${certs.master}/kube-service-accounts.pem";
    };
    etcd = {
      servers = ["https://etcd.${config.networking.domain}:2379"];
      certFile = "${certs.worker}/etcd-client.pem";
      keyFile = "${certs.worker}/etcd-client-key.pem";
    };
    kubeconfig = {
      server = "https://api.${config.networking.domain}";
    };
    kubelet = {
      tlsCertFile = "${certs.worker}/kubelet.pem";
      tlsKeyFile = "${certs.worker}/kubelet-key.pem";
      hostname = "${config.networking.hostName}.${config.networking.domain}";
      kubeconfig = {
        certFile = "${certs.worker}/apiserver-client-kubelet-${config.networking.hostName}.pem";
        keyFile = "${certs.worker}/apiserver-client-kubelet-${config.networking.hostName}-key.pem";
      };
    };
    controllerManager = {
      serviceAccountKeyFile = "${certs.master}/kube-service-accounts-key.pem";
      kubeconfig = {
        certFile = "${certs.master}/apiserver-client-kube-controller-manager.pem";
        keyFile = "${certs.master}/apiserver-client-kube-controller-manager-key.pem";
      };
    };
    scheduler = {
      kubeconfig = {
        certFile = "${certs.master}/apiserver-client-kube-scheduler.pem";
        keyFile = "${certs.master}/apiserver-client-kube-scheduler-key.pem";
      };
    };
    proxy = {
      kubeconfig = {
        certFile = "${certs.worker}/apiserver-client-kube-proxy.pem";
        keyFile = "${certs.worker}//apiserver-client-kube-proxy-key.pem";
      };
    };
  };

in {
  services.kubernetes = base;
}
