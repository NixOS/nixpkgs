import ../make-test-python.nix (
  {
    pkgs,
    lib,
    rke2,
    ...
  }:
  let
    throwSystem = throw "RKE2: Unsupported system: ${pkgs.stdenv.hostPlatform.system}";
    coreImages =
      {
        aarch64-linux = rke2.images-core-linux-arm64-tar-zst;
        x86_64-linux = rke2.images-core-linux-amd64-tar-zst;
      }
      .${pkgs.stdenv.hostPlatform.system} or throwSystem;
    canalImages =
      {
        aarch64-linux = rke2.images-canal-linux-arm64-tar-zst;
        x86_64-linux = rke2.images-canal-linux-amd64-tar-zst;
      }
      .${pkgs.stdenv.hostPlatform.system} or throwSystem;
    helloImage = pkgs.dockerTools.buildImage {
      name = "test.local/hello";
      tag = "local";
      compressor = "zstd";
      copyToRoot = pkgs.hello;
      config.Entrypoint = [ "${pkgs.hello}/bin/hello" ];
    };
    testJobYaml = pkgs.writeText "test.yaml" ''
      apiVersion: batch/v1
      kind: Job
      metadata:
        name: test
      spec:
        template:
          spec:
            containers:
            - name: test
              image: "test.local/hello:local"
            restartPolicy: Never
    '';
  in
  {
    name = "${rke2.name}-single-node";
    meta.maintainers = rke2.meta.maintainers;
    nodes.machine =
      {
        config,
        nodes,
        pkgs,
        ...
      }:
      {
        # Setup image archives to be imported by rke2
        systemd.tmpfiles.settings."10-rke2" = {
          "/var/lib/rancher/rke2/agent/images/rke2-images-core.tar.zst" = {
            "L+".argument = "${coreImages}";
          };
          "/var/lib/rancher/rke2/agent/images/rke2-images-canal.tar.zst" = {
            "L+".argument = "${canalImages}";
          };
          "/var/lib/rancher/rke2/agent/images/hello.tar.zst" = {
            "L+".argument = "${helloImage}";
          };
        };

        # RKE2 needs more resources than the default
        virtualisation.cores = 4;
        virtualisation.memorySize = 4096;
        virtualisation.diskSize = 8092;

        services.rke2 = {
          enable = true;
          role = "server";
          package = rke2;
          # Without nodeIP the apiserver starts with the wrong service IP family
          nodeIP = config.networking.primaryIPAddress;
          # Slightly reduce resource consumption
          disable = [
            "rke2-coredns"
            "rke2-metrics-server"
            "rke2-ingress-nginx"
            "rke2-snapshot-controller"
            "rke2-snapshot-controller-crd"
            "rke2-snapshot-validation-webhook"
          ];
        };
      };

    testScript =
      let
        kubectl = "${pkgs.kubectl}/bin/kubectl --kubeconfig=/etc/rancher/rke2/rke2.yaml";
      in
      # python
      ''
        start_all()

        machine.wait_for_unit("rke2-server")
        machine.succeed("${kubectl} cluster-info")

        machine.wait_until_succeeds("${kubectl} get serviceaccount default")
        machine.succeed("${kubectl} apply -f ${testJobYaml}")
        machine.wait_until_succeeds("${kubectl} wait --for 'condition=complete' job/test")
        output = machine.succeed("${kubectl} logs -l batch.kubernetes.io/job-name=test")
        assert output.rstrip() == "Hello, world!", f"unexpected output of test job: {output}"
      '';
  }
)
