{ system ? builtins.currentSystem }:

with import ../../lib/testing.nix { inherit system; };
with import ../../lib/qemu-flags.nix;
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
    $kubernetes->succeed("nc -z \$\(dig redis.default.svc.cluster.local +short\) 6379");
  '';
in makeTest {
  name = "kubernetes-singlenode";

  nodes = {
    kubernetes =
      { config, pkgs, lib, nodes, ... }:
        {
          virtualisation.memorySize = 768;
          virtualisation.diskSize = 2048;

          programs.bash.enableCompletion = true;
          environment.systemPackages = with pkgs; [ netcat bind ];

          services.kubernetes.roles = ["master" "node"];
          services.kubernetes.dns.port = 4453;

          services.dnsmasq.enable = true;
          services.dnsmasq.servers = ["/${config.services.kubernetes.dns.domain}/127.0.0.1#4453"];
        };
  };

  testScript = ''
    startAll;

    ${testSimplePod}
  '';
}
