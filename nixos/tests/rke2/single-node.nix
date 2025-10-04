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
    # A ConfigMap in regular yaml format
    cmFile = (pkgs.formats.yaml { }).generate "rke2-manifest-from-file.yaml" {
      apiVersion = "v1";
      kind = "ConfigMap";
      metadata.name = "from-file";
      data.username = "foo-file";
    };
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
          images = [
            coreImages
            canalImages
            helloImage
          ];
          manifests = {
            test-job.content = {
              apiVersion = "batch/v1";
              kind = "Job";
              metadata.name = "test";
              spec.template.spec = {
                containers = [
                  {
                    name = "hello";
                    image = "${helloImage.imageName}:${helloImage.imageTag}";
                  }
                ];
                restartPolicy = "Never";
              };
            };
            disabled = {
              enable = false;
              content = {
                apiVersion = "v1";
                kind = "ConfigMap";
                metadata.name = "disabled";
                data.username = "foo";
              };
            };
            from-file.source = "${cmFile}";
            custom-target = {
              enable = true;
              target = "my-manifest.json";
              content = {
                apiVersion = "v1";
                kind = "ConfigMap";
                metadata.name = "custom-target";
                data.username = "foo-custom";
              };
            };
          };
        };
      };

    testScript =
      let
        kubectl = "${pkgs.kubectl}/bin/kubectl --kubeconfig=/etc/rancher/rke2/rke2.yaml";
      in
      # python
      ''
        start_all()

        with subtest("Start cluster"):
          machine.wait_for_unit("rke2-server")
          machine.succeed("${kubectl} cluster-info")
          machine.wait_until_succeeds("${kubectl} get serviceaccount default")

        with subtest("Test job completes successfully"):
          machine.wait_until_succeeds("${kubectl} wait --for 'condition=complete' job/test")
          output = machine.succeed("${kubectl} logs -l batch.kubernetes.io/job-name=test").rstrip()
          assert output == "Hello, world!", f"unexpected output of test job: {output}"

        with subtest("ConfigMap from-file exists"):
          output = machine.succeed("${kubectl} get cm from-file -o=jsonpath='{.data.username}'").rstrip()
          assert output == "foo-file", f"Unexpected data in Configmap from-file: {output}"

        with subtest("ConfigMap custom-target exists"):
          # Check that the file exists at the custom target path
          machine.succeed("ls /var/lib/rancher/rke2/server/manifests/my-manifest.json")
          output = machine.succeed("${kubectl} get cm custom-target -o=jsonpath='{.data.username}'").rstrip()
          assert output == "foo-custom", f"Unexpected data in Configmap custom-target: {output}"

        with subtest("Disabled ConfigMap doesn't exist"):
          machine.fail("${kubectl} get cm disabled")
      '';
  }
)
