import ../make-test-python.nix (
  {
    pkgs,
    lib,
    k3s,
    etcd,
    ...
  }:

  {
    name = "${k3s.name}-etcd";

    nodes = {

      etcd =
        { ... }:
        {
          services.etcd = {
            enable = true;
            openFirewall = true;
            listenClientUrls = [
              "http://192.168.1.1:2379"
              "http://127.0.0.1:2379"
            ];
            listenPeerUrls = [ "http://192.168.1.1:2380" ];
            initialAdvertisePeerUrls = [ "http://192.168.1.1:2380" ];
            initialCluster = [ "etcd=http://192.168.1.1:2380" ];
          };
          networking = {
            useDHCP = false;
            defaultGateway = "192.168.1.1";
            interfaces.eth1.ipv4.addresses = pkgs.lib.mkForce [
              {
                address = "192.168.1.1";
                prefixLength = 24;
              }
            ];
          };
        };

      k3s =
        { pkgs, ... }:
        {
          environment.systemPackages = with pkgs; [ jq ];
          # k3s uses enough resources the default vm fails.
          virtualisation.memorySize = 1536;
          virtualisation.diskSize = 4096;

          services.k3s = {
            enable = true;
            role = "server";
            extraFlags = builtins.toString [
              "--datastore-endpoint=\"http://192.168.1.1:2379\""
              "--disable"
              "coredns"
              "--disable"
              "local-storage"
              "--disable"
              "metrics-server"
              "--disable"
              "servicelb"
              "--disable"
              "traefik"
              "--node-ip"
              "192.168.1.2"
            ];
          };

          networking = {
            firewall = {
              allowedTCPPorts = [
                2379
                2380
                6443
              ];
              allowedUDPPorts = [ 8472 ];
            };
            useDHCP = false;
            defaultGateway = "192.168.1.2";
            interfaces.eth1.ipv4.addresses = pkgs.lib.mkForce [
              {
                address = "192.168.1.2";
                prefixLength = 24;
              }
            ];
          };
        };
    };

    testScript = ''
      with subtest("should start etcd"):
          etcd.start()
          etcd.wait_for_unit("etcd.service")

      with subtest("should wait for etcdctl endpoint status to succeed"):
          etcd.wait_until_succeeds("etcdctl endpoint status")

      with subtest("should start k3s"):
          k3s.start()
          k3s.wait_for_unit("k3s")

      with subtest("should test if kubectl works"):
          k3s.wait_until_succeeds("k3s kubectl get node")

      with subtest("should wait for service account to show up; takes a sec"):
          k3s.wait_until_succeeds("k3s kubectl get serviceaccount default")

      with subtest("should create a sample secret object"):
          k3s.succeed("k3s kubectl create secret generic nixossecret --from-literal thesecret=abacadabra")

      with subtest("should check if secret is correct"):
          k3s.wait_until_succeeds("[[ $(kubectl get secrets nixossecret -o json | jq -r .data.thesecret | base64 -d) == abacadabra ]]")

      with subtest("should have a secret in database"):
          etcd.wait_until_succeeds("[[ $(etcdctl get /registry/secrets/default/nixossecret | head -c1 | wc -c) -ne 0 ]]")

      with subtest("should delete the secret"):
          k3s.succeed("k3s kubectl delete secret nixossecret")

      with subtest("should not have a secret in database"):
          etcd.wait_until_fails("[[ $(etcdctl get /registry/secrets/default/nixossecret | head -c1 | wc -c) -ne 0 ]]")

      with subtest("should shutdown k3s and etcd"):
          k3s.shutdown()
          etcd.shutdown()
    '';

    meta.maintainers = etcd.meta.maintainers ++ k3s.meta.maintainers;
  }
)
