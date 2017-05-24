{ system ? builtins.currentSystem }:

with import ../../lib/testing.nix { inherit system; };
with import ../../lib/qemu-flags.nix;
with pkgs.lib;

let
  servers.master = "192.168.1.1";
  servers.one = "192.168.1.10";

  certs = import ./certs.nix { inherit servers; };

  roServiceAccount = pkgs.writeText "ro-service-account.json" (builtins.toJSON {
    kind = "ServiceAccount";
    apiVersion = "v1";
    metadata = {
      name = "read-only";
      namespace = "default";
    };
  });

  roRoleBinding = pkgs.writeText "ro-role-binding.json" (builtins.toJSON {
    "apiVersion" = "rbac.authorization.k8s.io/v1beta1";
    "kind" = "RoleBinding";
    "metadata" = {
      "name" = "read-pods";
      "namespace" = "default";
    };
    "roleRef" = {
      "apiGroup" = "rbac.authorization.k8s.io";
      "kind" = "Role";
      "name" = "pod-reader";
    };
    "subjects" = [{
      "kind" = "ServiceAccount";
      "name" = "read-only";
      "namespace" = "default";
    }];
  });

  roRole = pkgs.writeText "ro-role.json" (builtins.toJSON {
    apiVersion = "rbac.authorization.k8s.io/v1beta1";
    kind = "Role";
    metadata = {
      name = "pod-reader";
      namespace = "default";
    };
    rules = [{
      apiGroups = [""];
      resources = ["pods"];
      verbs = ["get" "list" "watch"];
    }];
  });

  kubectlPod = pkgs.writeText "kubectl-pod.json" (builtins.toJSON {
    kind = "Pod";
    apiVersion = "v1";
    metadata.name = "kubectl";
    metadata.namespace = "default";
    metadata.labels.name = "kubectl";
    spec.serviceAccountName = "read-only";
    spec.containers = [{
      name = "kubectl";
      image = "kubectl:latest";
      command = ["${pkgs.busybox}/bin/tail" "-f"];
      imagePullPolicy = "Never";
      tty = true;
    }];
  });

  kubectlPod2 = pkgs.writeTextDir "kubectl-pod-2.json" (builtins.toJSON {
    kind = "Pod";
    apiVersion = "v1";
    metadata.name = "kubectl-2";
    metadata.namespace = "default";
    metadata.labels.name = "kubectl-2";
    spec.serviceAccountName = "read-only";
    spec.containers = [{
      name = "kubectl-2";
      image = "kubectl:latest";
      command = ["${pkgs.busybox}/bin/tail" "-f"];
      imagePullPolicy = "Never";
      tty = true;
    }];
  });

  kubectlImage = pkgs.dockerTools.buildImage {
    name = "kubectl";
    tag = "latest";
    contents = [ pkgs.kubernetes pkgs.busybox kubectlPod2 ];  # certs kubeconfig
    config.Entrypoint = "${pkgs.busybox}/bin/sh";
  };

  test = ''
    $master->waitUntilSucceeds("kubectl get node master.nixos.xyz | grep Ready");
    $master->waitUntilSucceeds("kubectl get node one.nixos.xyz | grep Ready");

    $one->execute("docker load < ${kubectlImage}");

    $master->waitUntilSucceeds("kubectl apply -f ${roServiceAccount}");
    $master->waitUntilSucceeds("kubectl apply -f ${roRole}");
    $master->waitUntilSucceeds("kubectl apply -f ${roRoleBinding}");
    $master->waitUntilSucceeds("kubectl create -f ${kubectlPod} || kubectl apply -f ${kubectlPod}");

    $master->waitUntilSucceeds("kubectl get pod kubectl | grep Running");

    $master->succeed("kubectl exec -ti kubectl -- kubectl get pods");
    $master->fail("kubectl exec -ti kubectl -- kubectl create -f /kubectl-pod-2.json");
    $master->fail("kubectl exec -ti kubectl -- kubectl delete pods -l name=kubectl");
  '';

in makeTest {
  name = "kubernetes-rbac";

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
