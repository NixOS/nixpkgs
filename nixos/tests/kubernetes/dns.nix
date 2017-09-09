{ system ? builtins.currentSystem, pkgs ? import <nixpkgs> { inherit system; } }:
with import ./base.nix { inherit system; };
let
  domain = "my.zyx";

  certs = import ./certs.nix { externalDomain = domain; };

  redisPod = pkgs.writeText "redis-pod.json" (builtins.toJSON {
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
    contents = [ pkgs.redis pkgs.bind.host ];
    config.Entrypoint = "/bin/redis-server";
  };

  probePod = pkgs.writeText "probe-pod.json" (builtins.toJSON {
    kind = "Pod";
    apiVersion = "v1";
    metadata.name = "probe";
    metadata.labels.name = "probe";
    spec.containers = [{
      name = "probe";
      image = "probe";
      args = [ "-f" ];
      tty = true;
      imagePullPolicy = "Never";
    }];
  });

  probeImage = pkgs.dockerTools.buildImage {
    name = "probe";
    tag = "latest";
    contents = [ pkgs.bind.host pkgs.busybox ];
    config.Entrypoint = "/bin/tail";
  };

  extraConfiguration = { config, pkgs, lib, nodes, ... }: {
    environment.systemPackages = [ pkgs.bind.host ];
    # virtualisation.docker.extraOptions = "--dns=${config.services.kubernetes.addons.dns.clusterIp}";
    services.dnsmasq.enable = true;
    services.dnsmasq.servers = [
      "/cluster.local/${config.services.kubernetes.addons.dns.clusterIp}#53"
    ];
  };

  base = {
    name = "dns";
    inherit domain certs extraConfiguration;
  };

  singleNodeTest = {
    test = ''
      # prepare machine1 for test
      $machine1->waitUntilSucceeds("kubectl get node machine1.${domain} | grep -w Ready");
      $machine1->execute("docker load < ${redisImage}");
      $machine1->waitUntilSucceeds("kubectl create -f ${redisPod}");
      $machine1->waitUntilSucceeds("kubectl create -f ${redisService}");
      $machine1->execute("docker load < ${probeImage}");
      $machine1->waitUntilSucceeds("kubectl create -f ${probePod}");

      # check if pods are running
      $machine1->waitUntilSucceeds("kubectl get pod redis | grep Running");
      $machine1->waitUntilSucceeds("kubectl get pod probe | grep Running");
      $machine1->waitUntilSucceeds("kubectl get pods -n kube-system | grep 'kube-dns.*3/3'");

      # check dns on host (dnsmasq)
      $machine1->succeed("host redis.default.svc.cluster.local");

      # check dns inside the container
      $machine1->succeed("kubectl exec -ti probe -- /bin/host redis.default.svc.cluster.local");
    '';
  };

  multiNodeTest = {
    test = ''
      # prepare machines for test
      $machine1->waitUntilSucceeds("kubectl get node machine1.${domain} | grep -w Ready");
      $machine1->waitUntilSucceeds("kubectl get node machine2.${domain} | grep -w Ready");
      $machine2->execute("docker load < ${redisImage}");
      $machine1->waitUntilSucceeds("kubectl create -f ${redisPod}");
      $machine1->waitUntilSucceeds("kubectl create -f ${redisService}");
      $machine2->execute("docker load < ${probeImage}");
      $machine1->waitUntilSucceeds("kubectl create -f ${probePod}");

      # check if pods are running
      $machine1->waitUntilSucceeds("kubectl get pod redis | grep Running");
      $machine1->waitUntilSucceeds("kubectl get pod probe | grep Running");
      $machine1->waitUntilSucceeds("kubectl get pods -n kube-system | grep 'kube-dns.*3/3'");

      # check dns on hosts (dnsmasq)
      $machine1->succeed("host redis.default.svc.cluster.local");
      $machine2->succeed("host redis.default.svc.cluster.local");

      # check dns inside the container
      $machine1->succeed("kubectl exec -ti probe -- /bin/host redis.default.svc.cluster.local");
    '';
  };
in {
  singlenode = mkKubernetesSingleNodeTest (base // singleNodeTest);
  multinode = mkKubernetesMultiNodeTest (base // multiNodeTest);
}
