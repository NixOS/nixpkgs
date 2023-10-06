{ system ? builtins.currentSystem, pkgs ? import ../../.. { inherit system; } }:
with import ./base.nix { inherit system; };
let

  roServiceAccount = pkgs.writeText "ro-service-account.json" (builtins.toJSON {
    kind = "ServiceAccount";
    apiVersion = "v1";
    metadata = {
      name = "read-only";
      namespace = "default";
    };
  });

  roRoleBinding = pkgs.writeText "ro-role-binding.json" (builtins.toJSON {
    apiVersion = "rbac.authorization.k8s.io/v1";
    kind = "RoleBinding";
    metadata = {
      name = "read-pods";
      namespace = "default";
    };
    roleRef = {
      apiGroup = "rbac.authorization.k8s.io";
      kind = "Role";
      name = "pod-reader";
    };
    subjects = [{
      kind = "ServiceAccount";
      name = "read-only";
      namespace = "default";
    }];
  });

  roRole = pkgs.writeText "ro-role.json" (builtins.toJSON {
    apiVersion = "rbac.authorization.k8s.io/v1";
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
      command = ["/bin/tail" "-f"];
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
      command = ["/bin/tail" "-f"];
      imagePullPolicy = "Never";
      tty = true;
    }];
  });

  copyKubectl = pkgs.runCommand "copy-kubectl" { } ''
    mkdir -p $out/bin
    cp ${pkgs.kubernetes}/bin/kubectl $out/bin/kubectl
  '';

  kubectlImage = pkgs.dockerTools.buildImage {
    name = "kubectl";
    tag = "latest";
    copyToRoot = pkgs.buildEnv {
      name = "image-root";
      pathsToLink = [ "/bin" ];
      paths = [ copyKubectl pkgs.busybox kubectlPod2 ];
    };
    config.Entrypoint = ["/bin/sh"];
  };

  base = {
    name = "rbac";
  };

  singlenode = base // {
    test = ''
      machine1.wait_until_succeeds("kubectl get node machine1.my.zyx | grep -w Ready")

      machine1.wait_until_succeeds(
          "${pkgs.gzip}/bin/zcat ${kubectlImage} | ${pkgs.containerd}/bin/ctr -n k8s.io image import -"
      )

      machine1.wait_until_succeeds(
          "kubectl apply -f ${roServiceAccount}"
      )
      machine1.wait_until_succeeds(
          "kubectl apply -f ${roRole}"
      )
      machine1.wait_until_succeeds(
          "kubectl apply -f ${roRoleBinding}"
      )
      machine1.wait_until_succeeds(
          "kubectl create -f ${kubectlPod}"
      )

      machine1.wait_until_succeeds("kubectl get pod kubectl | grep Running")

      machine1.wait_until_succeeds("kubectl exec kubectl -- kubectl get pods")
      machine1.fail("kubectl exec kubectl -- kubectl create -f /kubectl-pod-2.json")
      machine1.fail("kubectl exec kubectl -- kubectl delete pods -l name=kubectl")
    '';
  };

  multinode = base // {
    test = ''
      # Node token exchange
      machine1.wait_until_succeeds(
          "cp -f /var/lib/cfssl/apitoken.secret /tmp/shared/apitoken.secret"
      )
      machine2.wait_until_succeeds(
          "cat /tmp/shared/apitoken.secret | nixos-kubernetes-node-join"
      )

      machine1.wait_until_succeeds("kubectl get node machine2.my.zyx | grep -w Ready")

      machine2.wait_until_succeeds(
          "${pkgs.gzip}/bin/zcat ${kubectlImage} | ${pkgs.containerd}/bin/ctr -n k8s.io image import -"
      )

      machine1.wait_until_succeeds(
          "kubectl apply -f ${roServiceAccount}"
      )
      machine1.wait_until_succeeds(
          "kubectl apply -f ${roRole}"
      )
      machine1.wait_until_succeeds(
          "kubectl apply -f ${roRoleBinding}"
      )
      machine1.wait_until_succeeds(
          "kubectl create -f ${kubectlPod}"
      )

      machine1.wait_until_succeeds("kubectl get pod kubectl | grep Running")

      machine1.wait_until_succeeds("kubectl exec kubectl -- kubectl get pods")
      machine1.fail("kubectl exec kubectl -- kubectl create -f /kubectl-pod-2.json")
      machine1.fail("kubectl exec kubectl -- kubectl delete pods -l name=kubectl")
    '';
  };

in {
  singlenode = mkKubernetesSingleNodeTest singlenode;
  multinode = mkKubernetesMultiNodeTest multinode;
}
