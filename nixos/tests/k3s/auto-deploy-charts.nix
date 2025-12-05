# Tests whether container images are imported and auto deploying Helm charts,
# including the bundled traefik, work
import ../make-test-python.nix (
  {
    k3s,
    lib,
    pkgs,
    ...
  }:
  let
    testImageEnv = pkgs.buildEnv {
      name = "k3s-pause-image-env";
      paths = with pkgs; [
        busybox
        hello
      ];
    };
    testImage = pkgs.dockerTools.buildImage {
      name = "test.local/test";
      tag = "local";
      # Slightly reduces the time needed to import image
      compressor = "zstd";
      copyToRoot = testImageEnv;
    };
    # pack the test helm chart as a .tgz archive
    package =
      pkgs.runCommand "k3s-test-chart.tgz"
        {
          nativeBuildInputs = [ pkgs.kubernetes-helm ];
        }
        ''
          helm package ${./k3s-test-chart}
          mv ./*.tgz $out
        '';
    # The common Helm chart that is used in this test
    testChart = {
      inherit package;
      values = {
        runCommand = "hello";
        image = {
          repository = testImage.imageName;
          tag = testImage.imageTag;
        };
      };
    };
  in
  {
    name = "${k3s.name}-auto-deploy-helm";
    meta.maintainers = lib.teams.k3s.members;
    nodes.machine =
      { pkgs, ... }:
      {
        # k3s uses enough resources the default vm fails.
        virtualisation = {
          memorySize = 1536;
          diskSize = 4096;
        };
        environment.systemPackages = [ pkgs.yq-go ];
        services.k3s = {
          enable = true;
          package = k3s;
          # Slightly reduce resource usage
          extraFlags = [
            "--disable coredns"
            "--disable local-storage"
            "--disable metrics-server"
            "--disable servicelb"
          ];
          images = [
            # Provides the k3s Helm controller
            k3s.airgap-images
            testImage
          ];
          autoDeployCharts = {
            # regular test chart that should get installed
            hello = testChart;
            # disabled chart that should not get installed
            disabled = testChart // {
              enable = false;
            };
            # chart with values set via YAML file
            values-file = testChart // {
              # Remove unsafeDiscardStringContext workaround when Nix can convert a string to a path
              # https://github.com/NixOS/nix/issues/12407
              values =
                /.
                + builtins.unsafeDiscardStringContext (
                  builtins.toFile "k3s-test-chart-values.yaml" ''
                    runCommand: "echo 'Hello, file!'"
                    image:
                      repository: test.local/test
                      tag: local
                  ''
                );
            };
            # advanced chart that should get installed in the "test" namespace with a custom
            # timeout and overridden values
            advanced = testChart // {
              # create the "test" namespace via extraDeploy for testing
              extraDeploy = [
                {
                  apiVersion = "v1";
                  kind = "Namespace";
                  metadata.name = "test";
                }
              ];
              extraFieldDefinitions = {
                spec = {
                  # overwrite chart values
                  valuesContent = ''
                    runCommand: "echo 'advanced hello'"
                    image:
                      repository: ${testImage.imageName}
                      tag: ${testImage.imageTag}
                  '';
                  # overwrite the chart namespace
                  targetNamespace = "test";
                  # set a custom timeout
                  timeout = "69s";
                };
              };
            };
          };
        };
      };

    testScript = # python
      ''
        import json

        machine.wait_for_unit("k3s")
        # check existence/absence of chart manifest files
        machine.succeed("test -e /var/lib/rancher/k3s/server/manifests/hello.yaml")
        machine.succeed("test ! -e /var/lib/rancher/k3s/server/manifests/disabled.yaml")
        machine.succeed("test -e /var/lib/rancher/k3s/server/manifests/values-file.yaml")
        machine.succeed("test -e /var/lib/rancher/k3s/server/manifests/advanced.yaml")
        # check that the timeout is set correctly, select only the first doc in advanced.yaml
        advancedManifest = json.loads(machine.succeed("yq -o json '.items[0]' /var/lib/rancher/k3s/server/manifests/advanced.yaml"))
        t.assertEqual(advancedManifest["spec"]["timeout"], "69s", "unexpected value for spec.timeout")
        # wait for test jobs to complete
        machine.wait_until_succeeds("kubectl wait --for=condition=complete job/hello", timeout=180)
        machine.wait_until_succeeds("kubectl wait --for=condition=complete job/values-file", timeout=180)
        machine.wait_until_succeeds("kubectl -n test wait --for=condition=complete job/advanced", timeout=180)
        # check output of test jobs
        hello_output = machine.succeed("kubectl logs -l batch.kubernetes.io/job-name=hello")
        values_file_output = machine.succeed("kubectl logs -l batch.kubernetes.io/job-name=values-file")
        advanced_output = machine.succeed("kubectl -n test logs -l batch.kubernetes.io/job-name=advanced")
        # strip the output to remove trailing whitespaces
        t.assertEqual(hello_output.rstrip(), "Hello, world!", "unexpected output of hello job")
        t.assertEqual(values_file_output.rstrip(), "Hello, file!", "unexpected output of values file job")
        t.assertEqual(advanced_output.rstrip(), "advanced hello", "unexpected output of advanced job")
        # wait for bundled traefik deployment
        machine.wait_until_succeeds("kubectl -n kube-system rollout status deployment traefik", timeout=180)
      '';
  }
)
