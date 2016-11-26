{ system ? builtins.currentSystem }:

with import ../lib/testing.nix { inherit system; };
with import ../lib/qemu-flags.nix;
with pkgs.lib;

let
  redisPod = pkgs.writeText "redis-master-pod.json" (builtins.toJSON {
    kind = "Pod";
    apiVersion = "v1";
    metadata.name = "redis";
    metadata.labels.name = "redis";
    spec.containers = [{
      name = "redis";
      image = "redis";
      args = ["--bind" "0.0.0.0"];
      imagePullPolicy = "Never";
      ports = [{
        name = "redis-server";
        containerPort = 6379;
      }];
    }];
  });

  redisService = pkgs.writeText "redis-service.json" (builtins.toJSON {
    kind = "Service";
    apiVersion = "v1";
    metadata.name = "redis";
    spec = {
      ports = [{port = 6379; targetPort = 6379;}];
      selector = {name = "redis";};
    };
  });

  redisImage = pkgs.dockerTools.buildImage {
    name = "redis";
    tag = "latest";
    contents = pkgs.redis;
    config.Entrypoint = "/bin/redis-server";
  };

  testSimplePod = ''
    $kubernetes->execute("docker load < ${redisImage}");
    $kubernetes->waitUntilSucceeds("kubectl create -f ${redisPod}");
    $kubernetes->succeed("kubectl create -f ${redisService}");
    $kubernetes->waitUntilSucceeds("kubectl get pod redis | grep Running");
    $kubernetes->succeed("nc -z \$\(dig \@10.10.0.1 redis.default.svc.cluster.local +short\) 6379");
  '';
in {
  # This test runs kubernetes on a single node
  trivial = makeTest {
    name = "kubernetes-trivial";

    nodes = {
      kubernetes =
        { config, pkgs, lib, nodes, ... }:
          {
            virtualisation.memorySize = 768;
            virtualisation.diskSize = 2048;

            programs.bash.enableCompletion = true;

            services.kubernetes.roles = ["master" "node"];
            virtualisation.docker.extraOptions = "--iptables=false --ip-masq=false -b cbr0";

            networking.bridges.cbr0.interfaces = [];
            networking.interfaces.cbr0 = {};
          };
    };

    testScript = ''
      startAll;

      $kubernetes->waitUntilSucceeds("kubectl get nodes | grep kubernetes | grep Ready");

      ${testSimplePod}
    '';
  };

  cluster = let
    runWithOpenSSL = file: cmd: pkgs.runCommand file {
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

    etcd_client_key = runWithOpenSSL "etcd-client-key.pem"
      "openssl genrsa -out $out 2048";

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

    apiserver_key = runWithOpenSSL "apiserver-key.pem" "openssl genrsa -out $out 2048";

    apiserver_csr = runWithOpenSSL "apiserver.csr" ''
      openssl req \
        -new -key ${apiserver_key} \
        -out $out -subj "/CN=kube-apiserver" \
        -config ${apiserver_cnf}
    '';

    apiserver_cert = runWithOpenSSL "apiserver.pem" ''
      openssl x509 \
        -req -in ${apiserver_csr} \
        -CA ${ca_pem} -CAkey ${ca_key} -CAcreateserial \
        -out $out -days 365 -extensions v3_req \
        -extfile ${apiserver_cnf}
    '';

    worker_key = runWithOpenSSL "worker-key.pem" "openssl genrsa -out $out 2048";

    worker_csr = runWithOpenSSL "worker.csr" ''
      openssl req \
        -new -key ${worker_key} \
        -out $out -subj "/CN=kube-worker" \
        -config ${worker_cnf}
    '';

    worker_cert = runWithOpenSSL "worker.pem" ''
      openssl x509 \
        -req -in ${worker_csr} \
        -CA ${ca_pem} -CAkey ${ca_key} -CAcreateserial \
        -out $out -days 365 -extensions v3_req \
        -extfile ${worker_cnf}
    '';

    openssl_cnf = pkgs.writeText "openssl.cnf" ''
      [req]
      req_extensions = v3_req
      distinguished_name = req_distinguished_name
      [req_distinguished_name]
      [ v3_req ]
      basicConstraints = CA:FALSE
      keyUsage = digitalSignature, keyEncipherment
      extendedKeyUsage = serverAuth
      subjectAltName = @alt_names
      [alt_names]
      DNS.1 = etcd1
      DNS.2 = etcd2
      DNS.3 = etcd3
      IP.1 = 127.0.0.1
    '';

    client_openssl_cnf = pkgs.writeText "client-openssl.cnf" ''
      [req]
      req_extensions = v3_req
      distinguished_name = req_distinguished_name
      [req_distinguished_name]
      [ v3_req ]
      basicConstraints = CA:FALSE
      keyUsage = digitalSignature, keyEncipherment
      extendedKeyUsage = clientAuth
    '';

    apiserver_cnf = pkgs.writeText "apiserver-openssl.cnf" ''
      [req]
      req_extensions = v3_req
      distinguished_name = req_distinguished_name
      [req_distinguished_name]
      [ v3_req ]
      basicConstraints = CA:FALSE
      keyUsage = nonRepudiation, digitalSignature, keyEncipherment
      subjectAltName = @alt_names
      [alt_names]
      DNS.1 = kubernetes
      DNS.2 = kubernetes.default
      DNS.3 = kubernetes.default.svc
      DNS.4 = kubernetes.default.svc.cluster.local
      IP.1 = 10.10.10.1
    '';

    worker_cnf = pkgs.writeText "worker-openssl.cnf" ''
      [req]
      req_extensions = v3_req
      distinguished_name = req_distinguished_name
      [req_distinguished_name]
      [ v3_req ]
      basicConstraints = CA:FALSE
      keyUsage = nonRepudiation, digitalSignature, keyEncipherment
      subjectAltName = @alt_names
      [alt_names]
      DNS.1 = kubeWorker1
      DNS.2 = kubeWorker2
    '';

    etcdNodeConfig = {
      virtualisation.memorySize = 128;

      services = {
        etcd = {
          enable = true;
          keyFile = etcd_key;
          certFile = etcd_cert;
          trustedCaFile = ca_pem;
          peerClientCertAuth = true;
          listenClientUrls = ["https://0.0.0.0:2379"];
          listenPeerUrls = ["https://0.0.0.0:2380"];
        };
      };

      environment.variables = {
        ETCDCTL_CERT_FILE = "${etcd_client_cert}";
        ETCDCTL_KEY_FILE = "${etcd_client_key}";
        ETCDCTL_CA_FILE = "${ca_pem}";
        ETCDCTL_PEERS = "https://127.0.0.1:2379";
      };

      networking.firewall.allowedTCPPorts = [ 2379 2380 ];
    };

    kubeConfig = {
      virtualisation.diskSize = 2048;
      programs.bash.enableCompletion = true;

      services.flannel = {
        enable = true;
        network = "10.10.0.0/16";
        iface = "eth1";
        etcd = {
          endpoints = ["https://etcd1:2379" "https://etcd2:2379" "https://etcd3:2379"];
          keyFile = etcd_client_key;
          certFile = etcd_client_cert;
          caFile = ca_pem;
        };
      };

      # vxlan
      networking.firewall.allowedUDPPorts = [ 8472 ];

      systemd.services.docker.after = ["flannel.service"];
      systemd.services.docker.serviceConfig.EnvironmentFile = "/run/flannel/subnet.env";
      virtualisation.docker.extraOptions = "--iptables=false --ip-masq=false --bip $FLANNEL_SUBNET";

      services.kubernetes.verbose = true;
      services.kubernetes.etcd = {
        servers = ["https://etcd1:2379" "https://etcd2:2379" "https://etcd3:2379"];
        keyFile = etcd_client_key;
        certFile = etcd_client_cert;
        caFile = ca_pem;
      };

      environment.systemPackages = [ pkgs.bind pkgs.tcpdump pkgs.utillinux ];
    };

    kubeMasterConfig = {pkgs, ...}: {
      require = [kubeConfig];

      # kube apiserver
      networking.firewall.allowedTCPPorts = [ 443 ];

      virtualisation.memorySize = 512;

      services.kubernetes = {
        roles = ["master"];
        scheduler.leaderElect = true;
        controllerManager.leaderElect = true;

        apiserver = {
          publicAddress = "0.0.0.0";
          advertiseAddress = "192.168.1.8";
          tlsKeyFile = apiserver_key;
          tlsCertFile = apiserver_cert;
          clientCaFile = ca_pem;
          kubeletClientCaFile = ca_pem;
          kubeletClientKeyFile = worker_key;
          kubeletClientCertFile = worker_cert;
        };
      };
    };

    kubeWorkerConfig = { pkgs, ... }: {
      require = [kubeConfig];

      virtualisation.memorySize = 512;

      # kubelet
      networking.firewall.allowedTCPPorts = [ 10250 ];

      services.kubernetes = {
        roles = ["node"];
        kubeconfig = {
          server = "https://kubernetes:443";
          caFile = ca_pem;
          certFile = worker_cert;
          keyFile = worker_key;
        };
        kubelet = {
          tlsKeyFile = worker_key;
          tlsCertFile = worker_cert;
        };
      };
    };
  in makeTest {
    name = "kubernetes-cluster";

    nodes = {
      etcd1 = { config, pkgs, nodes, ... }: {
        require = [etcdNodeConfig];
        services.etcd = {
          advertiseClientUrls = ["https://etcd1:2379"];
          initialCluster = ["etcd1=https://etcd1:2380" "etcd2=https://etcd2:2380" "etcd3=https://etcd3:2380"];
          initialAdvertisePeerUrls = ["https://etcd1:2380"];
        };
      };

      etcd2 = { config, pkgs, ... }: {
        require = [etcdNodeConfig];
        services.etcd = {
          advertiseClientUrls = ["https://etcd2:2379"];
          initialCluster = ["etcd1=https://etcd1:2380" "etcd2=https://etcd2:2380" "etcd3=https://etcd3:2380"];
          initialAdvertisePeerUrls = ["https://etcd2:2380"];
        };
      };

      etcd3 = { config, pkgs, ... }: {
        require = [etcdNodeConfig];
        services.etcd = {
          advertiseClientUrls = ["https://etcd3:2379"];
          initialCluster = ["etcd1=https://etcd1:2380" "etcd2=https://etcd2:2380" "etcd3=https://etcd3:2380"];
          initialAdvertisePeerUrls = ["https://etcd3:2380"];
        };
      };

      kubeMaster1 = { config, pkgs, lib, nodes, ... }: {
        require = [kubeMasterConfig];
      };

      kubeMaster2 = { config, pkgs, lib, nodes, ... }: {
        require = [kubeMasterConfig];
      };

      # Kubernetes TCP load balancer
      kubernetes = { config, pkgs, ... }: {
        # kubernetes
        networking.firewall.allowedTCPPorts = [ 443 ];

        services.haproxy.enable = true;
        services.haproxy.config = ''
          global
              log 127.0.0.1 local0 notice
              user haproxy
              group haproxy

          defaults
              log global
              retries 2
              timeout connect 3000
              timeout server 5000
              timeout client 5000

          listen kubernetes
              bind 0.0.0.0:443
              mode tcp
              option ssl-hello-chk
              balance roundrobin
              server kube-master-1 kubeMaster1:443 check
              server kube-master-2 kubeMaster2:443 check
        '';
      };

      kubeWorker1 = { config, pkgs, lib, nodes, ... }: {
        require = [kubeWorkerConfig];
      };

      kubeWorker2 = { config, pkgs, lib, nodes, ... }: {
        require = [kubeWorkerConfig];
      };
    };

    testScript = ''
      startAll;

      ${testSimplePod}
    '';
  };
}
