# Tests K3s with Etcd backend
{
  pkgs,
  lib,
  rancherDistro,
  rancherPackage,
  serviceName,
  disabledComponents,
  coreImages,
  vmResources,
  ...
}:

{
  name = "${rancherPackage.name}-etcd";

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

    server =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          kubectl
          jq
        ];
        environment.sessionVariables.KUBECONFIG = "/etc/rancher/${rancherDistro}/${rancherDistro}.yaml";

        virtualisation = vmResources;

        services.${rancherDistro} = {
          enable = true;
          role = "server";
          package = rancherPackage;
          disable = disabledComponents;
          images = coreImages;
          nodeIP = "192.168.1.2";
          extraFlags = [
            "--datastore-endpoint=\"http://192.168.1.1:2379\""
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

  testScript = # python
    ''
      with subtest("should start etcd"):
          etcd.start()
          etcd.wait_for_unit("etcd.service")

      with subtest("should wait for etcdctl endpoint status to succeed"):
          etcd.wait_until_succeeds("etcdctl endpoint status")

      with subtest("should wait for etcdctl endpoint health to succeed"):
          etcd.wait_until_succeeds("etcdctl endpoint health")

      with subtest("should start ${rancherDistro}"):
          server.start()
          server.wait_for_unit("${serviceName}")

      with subtest("should test if kubectl works"):
          server.wait_until_succeeds("kubectl get node")

      with subtest("should wait for service account to show up; takes a sec"):
          server.wait_until_succeeds("kubectl get serviceaccount default")

      with subtest("should create a sample secret object"):
          server.succeed("kubectl create secret generic nixossecret --from-literal thesecret=abacadabra")

      with subtest("should check if secret is correct"):
          server.wait_until_succeeds("[[ $(kubectl get secrets nixossecret -o json | jq -r .data.thesecret | base64 -d) == abacadabra ]]")

      with subtest("should have a secret in database"):
          etcd.wait_until_succeeds("[[ $(etcdctl get /registry/secrets/default/nixossecret | head -c1 | wc -c) -ne 0 ]]")

      with subtest("should delete the secret"):
          server.succeed("kubectl delete secret nixossecret")

      with subtest("should not have a secret in database"):
          etcd.wait_until_fails("[[ $(etcdctl get /registry/secrets/default/nixossecret | head -c1 | wc -c) -ne 0 ]]")
    '';

  meta.maintainers =
    pkgs.etcd.meta.maintainers ++ lib.teams.k3s.members ++ pkgs.rke2.meta.maintainers;
}
