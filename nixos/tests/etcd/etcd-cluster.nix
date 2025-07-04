# This test runs simple etcd cluster

{ lib, pkgs, ... }:
let
  runWithOpenSSL =
    file: cmd:
    pkgs.runCommand file {
      buildInputs = [ pkgs.openssl ];
    } cmd;

  ca_key = runWithOpenSSL "ca-key.pem" "openssl genrsa -out $out 2048";
  ca_pem = runWithOpenSSL "ca.pem" ''
    openssl req \
      -x509 -new -nodes -key ${ca_key} \
      -days 10000 -out $out -subj "/CN=etcd-ca"
  '';
  etcd_key = runWithOpenSSL "etcd-key.pem" "openssl genrsa -out $out 2048";
  etcd_csr = runWithOpenSSL "etcd.csr" ''
    openssl req \
       -new -key ${etcd_key} \
       -out $out -subj "/CN=etcd" \
       -config ${openssl_cnf}
  '';
  etcd_cert = runWithOpenSSL "etcd.pem" ''
    openssl x509 \
      -req -in ${etcd_csr} \
      -CA ${ca_pem} -CAkey ${ca_key} \
      -CAcreateserial -out $out \
      -days 365 -extensions v3_req \
      -extfile ${openssl_cnf}
  '';

  etcd_client_key = runWithOpenSSL "etcd-client-key.pem" "openssl genrsa -out $out 2048";

  etcd_client_csr = runWithOpenSSL "etcd-client-key.pem" ''
    openssl req \
      -new -key ${etcd_client_key} \
      -out $out -subj "/CN=etcd-client" \
      -config ${client_openssl_cnf}
  '';

  etcd_client_cert = runWithOpenSSL "etcd-client.crt" ''
    openssl x509 \
      -req -in ${etcd_client_csr} \
      -CA ${ca_pem} -CAkey ${ca_key} -CAcreateserial \
      -out $out -days 365 -extensions v3_req \
      -extfile ${client_openssl_cnf}
  '';

  openssl_cnf = pkgs.writeText "openssl.cnf" ''
    ions = v3_req
    distinguished_name = req_distinguished_name
    [req_distinguished_name]
    [ v3_req ]
    basicConstraints = CA:FALSE
    keyUsage = digitalSignature, keyEncipherment
    extendedKeyUsage = serverAuth, clientAuth
    subjectAltName = @alt_names
    [alt_names]
    DNS.1 = node1
    DNS.2 = node2
    DNS.3 = node3
    IP.1 = 127.0.0.1
  '';

  client_openssl_cnf = pkgs.writeText "client-openssl.cnf" ''
    ions = v3_req
    distinguished_name = req_distinguished_name
    [req_distinguished_name]
    [ v3_req ]
    basicConstraints = CA:FALSE
    keyUsage = digitalSignature, keyEncipherment
    extendedKeyUsage = clientAuth
  '';

  nodeConfig = {
    services = {
      etcd = {
        enable = true;
        keyFile = etcd_key;
        certFile = etcd_cert;
        trustedCaFile = ca_pem;
        clientCertAuth = true;
        listenClientUrls = [ "https://127.0.0.1:2379" ];
        listenPeerUrls = [ "https://0.0.0.0:2380" ];
      };
    };

    environment.variables = {
      ETCD_CERT_FILE = "${etcd_client_cert}";
      ETCD_KEY_FILE = "${etcd_client_key}";
      ETCD_CA_FILE = "${ca_pem}";
      ETCDCTL_ENDPOINTS = "https://127.0.0.1:2379";
      ETCDCTL_CACERT = "${ca_pem}";
      ETCDCTL_CERT = "${etcd_cert}";
      ETCDCTL_KEY = "${etcd_key}";
    };

    networking.firewall.allowedTCPPorts = [ 2380 ];
  };
in
{
  name = "etcd-cluster";

  meta.maintainers = with lib.maintainers; [ offline ];

  nodes = {
    node1 =
      { ... }:
      {
        require = [ nodeConfig ];
        services.etcd = {
          initialCluster = [
            "node1=https://node1:2380"
            "node2=https://node2:2380"
          ];
          initialAdvertisePeerUrls = [ "https://node1:2380" ];
        };
      };

    node2 =
      { ... }:
      {
        require = [ nodeConfig ];
        services.etcd = {
          initialCluster = [
            "node1=https://node1:2380"
            "node2=https://node2:2380"
          ];
          initialAdvertisePeerUrls = [ "https://node2:2380" ];
        };
      };

    node3 =
      { ... }:
      {
        require = [ nodeConfig ];
        services.etcd = {
          initialCluster = [
            "node1=https://node1:2380"
            "node2=https://node2:2380"
            "node3=https://node3:2380"
          ];
          initialAdvertisePeerUrls = [ "https://node3:2380" ];
          initialClusterState = "existing";
        };
      };
  };

  testScript = ''
    with subtest("should start etcd cluster"):
        node1.start()
        node2.start()
        node1.wait_for_unit("etcd.service")
        node2.wait_for_unit("etcd.service")
        node2.wait_until_succeeds("etcdctl endpoint status")
        node1.succeed("etcdctl put /foo/bar 'Hello world'")
        node2.succeed("etcdctl get /foo/bar | grep 'Hello world'")

    with subtest("should add another member"):
        node1.wait_until_succeeds("etcdctl member add node3 --peer-urls=https://node3:2380")
        node3.start()
        node3.wait_for_unit("etcd.service")
        node3.wait_until_succeeds("etcdctl member list | grep 'node3'")
        node3.succeed("etcdctl endpoint status")

    with subtest("should survive member crash"):
        node3.crash()
        node1.succeed("etcdctl endpoint status")
        node1.succeed("etcdctl put /foo/bar 'Hello degraded world'")
        node1.succeed("etcdctl get /foo/bar | grep 'Hello degraded world'")
  '';
}
