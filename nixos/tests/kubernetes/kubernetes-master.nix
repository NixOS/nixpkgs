{ config, pkgs, certs }:
let
  etcd_key = "${certs}/etcd-key.pem";
  etcd_cert = "${certs}/etcd.pem";
  ca_pem = "${certs}/ca.pem";
  etcd_client_cert = "${certs}/etcd-client.crt";
  etcd_client_key = "${certs}/etcd-client-key.pem";

  apiserver_key = "${certs}/apiserver-key.pem";
  apiserver_cert = "${certs}/apiserver.pem";
  worker_key = "${certs}/worker-key.pem";
  worker_cert = "${certs}/worker.pem";


  rootCaFile = pkgs.writeScript "rootCaFile.pem" ''
    ${pkgs.lib.readFile "${certs}/ca.pem"}

    ${pkgs.lib.readFile ("${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt")}
  '';
in
{
  networking = {
    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [
        2379 2380  # etcd
        443 # kubernetes apiserver
      ];
    };
  };

  services.etcd = {
    enable = pkgs.lib.mkForce true;
    keyFile = etcd_key;
    certFile = etcd_cert;
    trustedCaFile = rootCaFile;
    peerClientCertAuth = true;
    listenClientUrls = ["https://0.0.0.0:2379"];
    listenPeerUrls = ["https://0.0.0.0:2380"];

    advertiseClientUrls = ["https://etcd.kubernetes.nixos.xyz:2379"];
    initialCluster = ["master=https://etcd.kubernetes.nixos.xyz:2380"];
    initialAdvertisePeerUrls = ["https://etcd.kubernetes.nixos.xyz:2380"];
  };

  services.kubernetes = {
    roles = ["master"];
    scheduler.leaderElect = true;
    controllerManager.rootCaFile = rootCaFile;
    controllerManager.serviceAccountKeyFile = apiserver_key;
    apiserver = {
      publicAddress = "192.168.1.1";
      advertiseAddress = "192.168.1.1";
      tlsKeyFile = apiserver_key;
      tlsCertFile = apiserver_cert;
      clientCaFile = rootCaFile;
      kubeletClientCaFile = rootCaFile;
      kubeletClientKeyFile = worker_key;
      kubeletClientCertFile = worker_cert;
    };
  };
}
