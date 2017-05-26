{ system ? builtins.currentSystem }:

with import ../../lib/testing.nix { inherit system; };
with import ../../lib/qemu-flags.nix;
with pkgs.lib;

let
  servers.master = "192.168.1.1";
  servers.one = "192.168.1.10";
  servers.two = "192.168.1.20";

  certs = import ./certs.nix { inherit servers; };

  kubectlPod = pkgs.writeText "kubectl-pod.json" (builtins.toJSON {
    kind = "Pod";
    apiVersion = "v1";
    metadata.name = "kubectl";
    metadata.labels.name = "kubectl";
    spec.containers = [{
      name = "kubectl";
      image = "kubectl:latest";
      command = ["${pkgs.busybox}/bin/tail" "-f"];
      imagePullPolicy = "Never";
      tty = true;
    }];
  });

  kubectlImage = pkgs.dockerTools.buildImage {
    name = "kubectl";
    tag = "latest";
    contents = [ pkgs.kubernetes pkgs.busybox certs kubeconfig ];
    config.Entrypoint = "${pkgs.busybox}/bin/sh";
  };

  kubeconfig = pkgs.writeTextDir "kubeconfig.json" (builtins.toJSON {
    apiVersion = "v1";
    kind = "Config";
    clusters = [{
      name = "local";
      cluster.certificate-authority = "/ca.pem";
      cluster.server = "https://${servers.master}";
    }];
    users = [{
      name = "kubelet";
      user = {
        client-certificate = "/admin.crt";
        client-key = "/admin-key.pem";
      };
    }];
    contexts = [{
      context = {
        cluster = "local";
        user = "kubelet";
      };
      current-context = "kubelet-context";
    }];
  });

  test = ''
    $master->waitUntilSucceeds("kubectl get node master.nixos.xyz | grep Ready");
    $master->waitUntilSucceeds("kubectl get node one.nixos.xyz | grep Ready");
    $master->waitUntilSucceeds("kubectl get node two.nixos.xyz | grep Ready");

    $one->execute("docker load < ${kubectlImage}");
    $two->execute("docker load < ${kubectlImage}");

    $master->waitUntilSucceeds("kubectl create -f ${kubectlPod} || kubectl apply -f ${kubectlPod}");

    $master->waitUntilSucceeds("kubectl get pod kubectl | grep Running");

    $master->succeed("kubectl exec -ti kubectl -- kubectl --kubeconfig=/kubeconfig.json version");
  '';

in makeTest {
  name = "kubernetes-multinode-kubectl";

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

    two =
      { config, pkgs, lib, nodes, ... }:
        mkMerge [
          {
            virtualisation.memorySize = 768;
            virtualisation.diskSize = 4096;
            networking.interfaces.eth1.ip4 = mkForce [{address = servers.two; prefixLength = 24;}];
            networking.primaryIPAddress = mkForce servers.two;
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
