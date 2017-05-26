{ config, pkgs, certs, servers }:

let
  etcd_key = "${certs}/etcd-key.pem";
  etcd_cert = "${certs}/etcd.pem";
  ca_pem = "${certs}/ca.pem";
  etcd_client_cert = "${certs}/etcd-client.crt";
  etcd_client_key = "${certs}/etcd-client-key.pem";

  worker_key = "${certs}/worker-key.pem";
  worker_cert = "${certs}/worker.pem";

  rootCaFile = pkgs.writeScript "rootCaFile.pem" ''
    ${pkgs.lib.readFile "${certs}/ca.pem"}

    ${pkgs.lib.readFile ("${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt")}
  '';

  mkHosts =
    pkgs.lib.concatMapStringsSep "\n" (v: "${v.ip} ${v.name}.nixos.xyz") (pkgs.lib.mapAttrsToList (n: v: {name = n; ip = v;}) servers);

in
{
  programs.bash.enableCompletion = true;
  environment.systemPackages = with pkgs; [ netcat bind etcd.bin ];

  networking = {
    firewall.allowedTCPPorts = [
      10250 # kubelet
    ];
    extraHosts = ''
      # register "external" domains
      ${servers.master} etcd.kubernetes.nixos.xyz
      ${servers.master} kubernetes.nixos.xyz
      ${mkHosts}
    '';
  };
  services.flannel.iface = "eth1";
  environment.variables = {
    ETCDCTL_CERT_FILE = "${etcd_client_cert}";
    ETCDCTL_KEY_FILE = "${etcd_client_key}";
    ETCDCTL_CA_FILE = "${rootCaFile}";
    ETCDCTL_PEERS = "https://etcd.kubernetes.nixos.xyz:2379";
  };

  services.kubernetes = {
    kubelet = {
      tlsKeyFile = worker_key;
      tlsCertFile = worker_cert;
      hostname = "${config.networking.hostName}.nixos.xyz";
      nodeIp = config.networking.primaryIPAddress;
    };
    etcd = {
      servers = ["https://etcd.kubernetes.nixos.xyz:2379"];
      keyFile = etcd_client_key;
      certFile = etcd_client_cert;
      caFile = ca_pem;
    };
    kubeconfig = {
      server = "https://kubernetes.nixos.xyz";
      caFile = rootCaFile;
      certFile = worker_cert;
      keyFile = worker_key;
    };
    flannel.enable = true;

    dns.port = 4453;
  };

  services.dnsmasq.enable = true;
  services.dnsmasq.servers = ["/${config.services.kubernetes.dns.domain}/127.0.0.1#4453"];
}
