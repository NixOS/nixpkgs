{ system ? builtins.currentSystem, pkgs ? import ../../.. { inherit system; } }:
with import ./base.nix { inherit system; };
let
  domain = "my.zyx";

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
    copyToRoot = pkgs.buildEnv {
      name = "image-root";
      pathsToLink = [ "/bin" ];
      paths = [ pkgs.redis pkgs.bind.host ];
    };
    config.Entrypoint = ["/bin/redis-server"];
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
    copyToRoot = pkgs.buildEnv {
      name = "image-root";
      pathsToLink = [ "/bin" ];
      paths = [ pkgs.bind.host pkgs.busybox ];
    };
    config.Entrypoint = ["/bin/tail"];
  };

  extraConfiguration = { config, pkgs, lib, ... }: {
    environment.systemPackages = [ pkgs.bind.host ];
    services.dnsmasq.enable = true;
    services.dnsmasq.settings.server = [
      "/cluster.local/${config.services.kubernetes.addons.dns.clusterIp}#53"
    ];
  };

  base = {
    name = "dns";
    inherit domain extraConfiguration;
  };

  singleNodeTest = {
    test = ''
      # prepare machine1 for test
      machine1.wait_until_succeeds("kubectl get node machine1.${domain} | grep -w Ready")
      machine1.wait_until_succeeds(
          "${pkgs.gzip}/bin/zcat ${redisImage} | ${pkgs.containerd}/bin/ctr -n k8s.io image import -"
      )
      machine1.wait_until_succeeds(
          "kubectl create -f ${redisPod}"
      )
      machine1.wait_until_succeeds(
          "kubectl create -f ${redisService}"
      )
      machine1.wait_until_succeeds(
          "${pkgs.gzip}/bin/zcat ${probeImage} | ${pkgs.containerd}/bin/ctr -n k8s.io image import -"
      )
      machine1.wait_until_succeeds(
          "kubectl create -f ${probePod}"
      )

      # check if pods are running
      machine1.wait_until_succeeds("kubectl get pod redis | grep Running")
      machine1.wait_until_succeeds("kubectl get pod probe | grep Running")
      machine1.wait_until_succeeds("kubectl get pods -n kube-system | grep 'coredns.*1/1'")

      # check dns on host (dnsmasq)
      machine1.succeed("host redis.default.svc.cluster.local")

      # check dns inside the container
      machine1.succeed("kubectl exec probe -- /bin/host redis.default.svc.cluster.local")
    '';
  };

  multiNodeTest = {
    test = ''
      # Node token exchange
      machine1.wait_until_succeeds(
          "cp -f /var/lib/cfssl/apitoken.secret /tmp/shared/apitoken.secret"
      )
      machine2.wait_until_succeeds(
          "cat /tmp/shared/apitoken.secret | nixos-kubernetes-node-join"
      )

      # prepare machines for test
      machine1.wait_until_succeeds("kubectl get node machine2.${domain} | grep -w Ready")
      machine2.wait_until_succeeds(
          "${pkgs.gzip}/bin/zcat ${redisImage} | ${pkgs.containerd}/bin/ctr -n k8s.io image import -"
      )
      machine1.wait_until_succeeds(
          "kubectl create -f ${redisPod}"
      )
      machine1.wait_until_succeeds(
          "kubectl create -f ${redisService}"
      )
      machine2.wait_until_succeeds(
          "${pkgs.gzip}/bin/zcat ${probeImage} | ${pkgs.containerd}/bin/ctr -n k8s.io image import -"
      )
      machine1.wait_until_succeeds(
          "kubectl create -f ${probePod}"
      )

      # check if pods are running
      machine1.wait_until_succeeds("kubectl get pod redis | grep Running")
      machine1.wait_until_succeeds("kubectl get pod probe | grep Running")
      machine1.wait_until_succeeds("kubectl get pods -n kube-system | grep 'coredns.*1/1'")

      # check dns on hosts (dnsmasq)
      machine1.succeed("host redis.default.svc.cluster.local")
      machine2.succeed("host redis.default.svc.cluster.local")

      # check dns inside the container
      machine1.succeed("kubectl exec probe -- /bin/host redis.default.svc.cluster.local")
    '';
  };
in {
  singlenode = mkKubernetesSingleNodeTest (base // singleNodeTest);
  multinode = mkKubernetesMultiNodeTest (base // multiNodeTest);
}
