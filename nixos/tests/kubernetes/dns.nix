{ system ? builtins.currentSystem }:

with import ../../lib/testing.nix { inherit system; };
with import ../../lib/qemu-flags.nix;
with pkgs.lib;

let
  servers.master = "192.168.1.1";
  servers.one = "192.168.1.10";

  certs = import ./certs.nix { inherit servers; };

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
    contents = [ pkgs.redis pkgs.bind.dnsutils pkgs.coreutils pkgs.inetutils pkgs.nmap ];
    config.Entrypoint = "/bin/redis-server";
  };

  test = ''
    $master->waitUntilSucceeds("kubectl get node master.nixos.xyz | grep Ready");
    $master->waitUntilSucceeds("kubectl get node one.nixos.xyz | grep Ready");

    $one->execute("docker load < ${redisImage}");

    $master->waitUntilSucceeds("kubectl create -f ${redisPod} || kubectl apply -f ${redisPod}");
    $master->waitUntilSucceeds("kubectl create -f ${redisService} || kubectl apply -f ${redisService}");

    $master->waitUntilSucceeds("kubectl get pod redis | grep Running");

    $master->succeed("dig \@192.168.1.1 redis.default.svc.cluster.local");
    $one->succeed("dig \@192.168.1.10 redis.default.svc.cluster.local");


    $master->succeed("kubectl exec -ti redis -- cat /etc/resolv.conf | grep 'nameserver 192.168.1.10'");

    $master->succeed("kubectl exec -ti redis -- dig \@192.168.1.10 redis.default.svc.cluster.local");
  '';

in makeTest {
  name = "kubernetes-dns";

  nodes = {
    master =
      { config, pkgs, lib, nodes, ... }:
        mkMerge [
          {
            virtualisation.memorySize = 768;
            virtualisation.diskSize = 4096;
            networking.interfaces.eth1.ip4 = mkForce [{address = servers.master; prefixLength = 24;}];
            networking.primaryIPAddress = mkForce servers.master;
          }
          (import ./kubernetes-common.nix { inherit pkgs config certs servers; })
          (import ./kubernetes-master.nix { inherit pkgs config certs; })
        ];

    one =
      { config, pkgs, lib, nodes, ... }:
        mkMerge [
          {
            virtualisation.memorySize = 768;
            virtualisation.diskSize = 4096;
            networking.interfaces.eth1.ip4 = mkForce [{address = servers.one; prefixLength = 24;}];
            networking.primaryIPAddress = mkForce servers.one;
            services.kubernetes.roles = ["node"];
          }
          (import ./kubernetes-common.nix { inherit pkgs config certs servers; })
        ];
  };

  testScript = ''
    startAll;

    ${test}
  '';
}
