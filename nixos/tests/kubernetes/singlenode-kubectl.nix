{ system ? builtins.currentSystem }:

with import ../../lib/testing.nix { inherit system; };
with import ../../lib/qemu-flags.nix;
with pkgs.lib;

let
  certs = import ./certs.nix { servers = {}; };

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
      cluster.server = "https://192.168.1.1:4443/";
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
    $kubernetes->execute("docker load < ${kubectlImage}");
    $kubernetes->waitUntilSucceeds("kubectl create -f ${kubectlPod} || kubectl apply -f ${kubectlPod}");
    $kubernetes->waitUntilSucceeds("kubectl get pod kubectl | grep Running");

    # FIXME: this test fails, for some reason it can not reach host ip address
    $kubernetes->succeed("kubectl exec -ti kubectl -- kubectl --kubeconfig=/kubeconfig.json version");
  '';
in makeTest {
  name = "kubernetes-singlenode-kubectl";

  nodes = {
    kubernetes =
      { config, pkgs, lib, nodes, ... }:
        {
          virtualisation.memorySize = 768;
          virtualisation.diskSize = 4096;

          programs.bash.enableCompletion = true;
          environment.systemPackages = with pkgs; [ netcat bind ];

          services.kubernetes.roles = ["master" "node"];
          services.kubernetes.apiserver.securePort = 4443;
          services.kubernetes.dns.port = 4453;
          services.kubernetes.clusterCidr = "10.0.0.0/8";
          virtualisation.docker.extraOptions = "--iptables=false --ip-masq=false -b cbr0";

          networking.interfaces.eth1.ip4 = mkForce [{address = "192.168.1.1"; prefixLength = 24;}];
          networking.primaryIPAddress = mkForce "192.168.1.1";
          networking.bridges.cbr0.interfaces = [];
          networking.interfaces.cbr0 = {};

          services.dnsmasq.enable = true;
          services.dnsmasq.servers = ["/${config.services.kubernetes.dns.domain}/127.0.0.1#4453"];
        };
  };

  testScript = ''
    startAll;

    ${test}
  '';
}
