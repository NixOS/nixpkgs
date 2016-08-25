# This test runs simple etcd cluster

import ./make-test.nix ({ pkgs, ... } : let
  certs = pkgs.runCommand "certs" {
    buildInputs = [pkgs.openssl];
  } ''
    mkdir -p $out
    openssl genrsa -out $out/ca-key.pem 2048
    openssl req -x509 -new -nodes -key $out/ca-key.pem -days 10000 -out $out/ca.pem -subj "/CN=etcd-ca"

    cat << EOF > openssl.cnf
    ions = v3_req
    distinguished_name = req_distinguished_name
    [req_distinguished_name]
    [ v3_req ]
    basicConstraints = CA:FALSE
    keyUsage = digitalSignature, keyEncipherment
    extendedKeyUsage = serverAuth
    subjectAltName = @alt_names
    [alt_names]
    DNS.1 = node1
    DNS.2 = node2
    DNS.3 = node3
    IP.1 = 127.0.0.1
    EOF

    openssl genrsa -out $out/etcd-key.pem 2048
    openssl req -new -key $out/etcd-key.pem -out etcd.csr -subj "/CN=etcd" -config openssl.cnf
    openssl x509 -req -in etcd.csr -CA $out/ca.pem -CAkey $out/ca-key.pem -CAcreateserial -out $out/etcd.pem -days 365 -extensions v3_req -extfile openssl.cnf

    cat << EOF > client-openssl.cnf
    ions = v3_req
    distinguished_name = req_distinguished_name
    [req_distinguished_name]
    [ v3_req ]
    basicConstraints = CA:FALSE
    keyUsage = digitalSignature, keyEncipherment
    extendedKeyUsage = clientAuth
    EOF

    openssl genrsa -out $out/etcd-client-key.pem 2048
    openssl req -new -key $out/etcd-client-key.pem -out etcd-client.csr -subj "/CN=etcd-client" -config client-openssl.cnf
    openssl x509 -req -in etcd-client.csr -CA $out/ca.pem -CAkey $out/ca-key.pem -CAcreateserial -out $out/etcd-client.pem -days 365 -extensions v3_req -extfile client-openssl.cnf
  '';

  nodeConfig = {
    services = {
      etcd = {
        enable = true;
        keyFile = "${certs}/etcd-key.pem";
        certFile = "${certs}/etcd.pem";
        trustedCaFile = "${certs}/ca.pem";
        peerClientCertAuth = true;
        listenClientUrls = ["https://127.0.0.1:2379"];
        listenPeerUrls = ["https://0.0.0.0:2380"];
      };
    };

    environment.variables = {
      ETCDCTL_CERT_FILE = "${certs}/etcd-client.pem";
      ETCDCTL_KEY_FILE = "${certs}/etcd-client-key.pem";
      ETCDCTL_CA_FILE = "${certs}/ca.pem";
      ETCDCTL_PEERS = "https://127.0.0.1:2379";
    };

    networking.firewall.allowedTCPPorts = [ 2380 ];
  };
in {
  name = "etcd";

  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ offline ];
  };

  nodes = {
    node1 = { config, pkgs, nodes, ... }: {
      require = [nodeConfig];
      services.etcd = {
        initialCluster = ["node1=https://node1:2380" "node2=https://node2:2380"];
        initialAdvertisePeerUrls = ["https://node1:2380"];
      };
    };

    node2 = { config, pkgs, ... }: {
      require = [nodeConfig];
      services.etcd = {
        initialCluster = ["node1=https://node1:2380" "node2=https://node2:2380"];
        initialAdvertisePeerUrls = ["https://node2:2380"];
      };
    };

    node3 = { config, pkgs, ... }: {
      require = [nodeConfig];
      services.etcd = {
        initialCluster = ["node1=https://node1:2380" "node2=https://node2:2380" "node3=https://node3:2380"];
        initialAdvertisePeerUrls = ["https://node3:2380"];
        initialClusterState = "existing";
      };
    };
  };

  testScript = ''
    subtest "should start etcd cluster", sub {
      $node1->start();
      $node2->start();
      $node1->waitForUnit("etcd.service");
      $node2->waitForUnit("etcd.service");
      $node2->waitUntilSucceeds("etcdctl cluster-health");
      $node1->succeed("etcdctl set /foo/bar 'Hello world'");
      $node2->succeed("etcdctl get /foo/bar | grep 'Hello world'");
    };

    subtest "should add another member", sub {
      $node1->succeed("etcdctl member add node3 https://node3:2380");
      $node3->start();
      $node3->waitForUnit("etcd.service");
      $node3->waitUntilSucceeds("etcdctl member list | grep 'node3'");
      $node3->succeed("etcdctl cluster-health");
    };

    subtest "should survive member crash", sub {
      $node3->crash;
      $node1->succeed("etcdctl cluster-health");
      $node1->succeed("etcdctl set /foo/bar 'Hello degraded world'");
      $node1->succeed("etcdctl get /foo/bar | grep 'Hello degraded world'");
    };
  '';
})
