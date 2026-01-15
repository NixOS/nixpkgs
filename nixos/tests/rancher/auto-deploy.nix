# Tests whether container images are imported and auto deploy (manifests and charts) work.
# Additionally, imports airgap images and verifies deployment of the bundled reverse
# proxy (traefik or ingress-nginx)
{
  pkgs,
  lib,
  rancherDistro,
  rancherPackage,
  serviceName,
  disabledComponents,
  coreImages,
  vmResources,
  ...
}:
let
  testImageEnv = pkgs.buildEnv {
    name = "${rancherDistro}-test-image-env";
    paths = with pkgs; [
      busybox
      hello
    ];
  };
  testImage = pkgs.dockerTools.buildImage {
    name = "test.local/test";
    tag = "local";
    compressor = "zstd";
    copyToRoot = testImageEnv;
  };
  manifestFormat =
    {
      k3s = "yaml";
      rke2 = "json";
    }
    .${rancherDistro};
  # pack the test helm chart as a .tgz archive
  testChartPackage =
    pkgs.runCommand "${rancherDistro}-test-chart.tgz"
      {
        nativeBuildInputs = [ pkgs.kubernetes-helm ];
        chart = builtins.toJSON {
          name = "${rancherDistro}-test-chart";
          version = "0.1.0";
        };
        values = builtins.toJSON {
          restartPolicy = "Never";
          runCommand = "";
          image = {
            repository = "foo";
            tag = "1.0.0";
          };
        };
        job = builtins.toJSON {
          apiVersion = "batch/v1";
          kind = "Job";
          metadata = {
            name = "{{ .Release.Name }}";
            namespace = "{{ .Release.Namespace }}";
          };
          spec = {
            template = {
              spec = {
                containers = [
                  {
                    name = "test";
                    image = "{{ .Values.image.repository }}:{{ .Values.image.tag }}";
                    command = [ "sh" ];
                    args = [
                      "-c"
                      "{{ .Values.runCommand }}"
                    ];
                  }
                ];
                restartPolicy = "{{ .Values.restartPolicy }}";
              };
            };
          };
        };
        passAsFile = [
          "values"
          "chart"
          "job"
        ];
      }
      ''
        mkdir -p chart/templates
        cp "$chartPath" chart/Chart.yaml
        cp "$valuesPath" chart/values.yaml
        cp "$jobPath" chart/templates/job.json

        helm package chart
        mv ./*.tgz $out
      '';
  # The Helm chart that is used in this test
  testChart = {
    package = testChartPackage;
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
  name = "${rancherPackage.name}-auto-deploy";

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        kubectl
        cri-tools
        yq-go
      ];
      environment.sessionVariables.KUBECONFIG = "/etc/rancher/${rancherDistro}/${rancherDistro}.yaml";

      virtualisation = vmResources;

      services.${rancherDistro} = {
        enable = true;
        role = "server";
        package = rancherPackage;
        disable =
          {
            k3s = lib.remove "traefik" disabledComponents;
            rke2 = lib.remove "rke2-ingress-nginx" disabledComponents;
          }
          .${rancherDistro};
        images =
          coreImages ++ lib.optional (rancherDistro == "k3s") rancherPackage.airgap-images ++ [ testImage ];
        manifests = {
          manifest-absent = {
            enable = false;
            content = {
              apiVersion = "v1";
              kind = "Namespace";
              metadata.name = "absent";
            };
          };

          manifest-present = {
            target = "foo-namespace.${manifestFormat}";
            content = {
              apiVersion = "v1";
              kind = "Namespace";
              metadata.name = "foo";
            };
          };

          manifest-hello.content = {
            apiVersion = "batch/v1";
            kind = "Job";
            metadata.name = "manifest-hello";
            spec = {
              template.spec = {
                containers = [
                  {
                    name = "hello";
                    image = "${testImage.imageName}:${testImage.imageTag}";
                    command = [ "hello" ];
                  }
                ];
                restartPolicy = "OnFailure";
              };
            };
          };
        };
        autoDeployCharts = {
          # regular test chart that should get installed
          chart-hello = testChart;
          # disabled chart that should not get installed
          chart-disabled = testChart // {
            enable = false;
          };
          # chart with values set via YAML file
          chart-values-file = testChart // {
            # Remove unsafeDiscardStringContext workaround when Nix can convert a string to a path
            # https://github.com/NixOS/nix/issues/12407
            values =
              /.
              + builtins.unsafeDiscardStringContext (
                builtins.toFile "${rancherDistro}-test-chart-values.yaml" ''
                  runCommand: "echo 'Hello, file!'"
                  image:
                    repository: test.local/test
                    tag: local
                ''
              );
          };
          # advanced chart that should get installed in the "test" namespace with a custom
          # timeout and overridden values
          chart-advanced = testChart // {
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

      machine.wait_for_unit("${serviceName}")

      with subtest("Generation of manifest files"):
        machine.succeed("test ! -e /var/lib/rancher/${rancherDistro}/server/manifests/manifest-absent.${manifestFormat}")
        machine.succeed("test -e /var/lib/rancher/${rancherDistro}/server/manifests/foo-namespace.${manifestFormat}")
        machine.succeed("test -e /var/lib/rancher/${rancherDistro}/server/manifests/manifest-hello.${manifestFormat}")

      with subtest("Generation of chart manifest files"):
        machine.succeed("test ! -e /var/lib/rancher/${rancherDistro}/server/manifests/chart-disabled.${manifestFormat}")
        machine.succeed("test -e /var/lib/rancher/${rancherDistro}/server/manifests/chart-hello.${manifestFormat}")
        machine.succeed("test -e /var/lib/rancher/${rancherDistro}/server/manifests/chart-values-file.${manifestFormat}")
        machine.succeed("test -e /var/lib/rancher/${rancherDistro}/server/manifests/chart-advanced.${manifestFormat}")

      with subtest("Timeout of advanced chart"):
        # select only the first item in advanced.yaml
        advancedManifest = json.loads(machine.succeed("yq -o json '.items[0]' /var/lib/rancher/${rancherDistro}/server/manifests/chart-advanced.${manifestFormat}"))
        t.assertEqual(advancedManifest["spec"]["timeout"], "69s", "unexpected value for spec.timeout")

      with subtest("Container image import"):
        # for some reason, RKE2 also uses /run/k3s
        machine.wait_until_succeeds("crictl -r /run/k3s/containerd/containerd.sock img | grep 'test\.local/test'")
        machine.wait_until_succeeds("crictl -r /run/k3s/containerd/containerd.sock img | grep '^docker.io/rancher/mirrored-'")

      with subtest("Creation of manifest resource"):
        machine.wait_until_succeeds("kubectl get ns foo")
        machine.wait_until_succeeds("kubectl wait --for=condition=complete job/manifest-hello")
        machine.fail("kubectl get ns absent")

      with subtest("Completion of chart test jobs"):
        machine.wait_until_succeeds("kubectl wait --for=condition=complete job/chart-hello")
        machine.wait_until_succeeds("kubectl wait --for=condition=complete job/chart-values-file")
        machine.wait_until_succeeds("kubectl -n test wait --for=condition=complete job/chart-advanced")

      with subtest("Output of manifest test job"):
        hello_output = machine.succeed("kubectl logs -l batch.kubernetes.io/job-name=manifest-hello")
        t.assertEqual(hello_output.rstrip(), "Hello, world!", "unexpected output of manifest-hello job")

      with subtest("Output of chart test jobs"):
        hello_output = machine.succeed("kubectl logs -l batch.kubernetes.io/job-name=chart-hello")
        values_file_output = machine.succeed("kubectl logs -l batch.kubernetes.io/job-name=chart-values-file")
        advanced_output = machine.succeed("kubectl -n test logs -l batch.kubernetes.io/job-name=chart-advanced")
        # strip to remove trailing whitespaces
        t.assertEqual(hello_output.rstrip(), "Hello, world!", "unexpected output of chart hello job")
        t.assertEqual(values_file_output.rstrip(), "Hello, file!", "unexpected output of chart values file job")
        t.assertEqual(advanced_output.rstrip(), "advanced hello", "unexpected output of advanced chart job")

      with subtest("Deployment of bundled reverse proxy"):
        ${
          {
            k3s = ''
              machine.wait_until_succeeds("kubectl -n kube-system rollout status deployment traefik")
            '';
            rke2 = ''
              machine.wait_until_succeeds("kubectl -n kube-system rollout status daemonset rke2-ingress-nginx-controller")
            '';
          }
          .${rancherDistro}
        }
    '';

  meta.maintainers = lib.teams.k3s.members ++ pkgs.rke2.meta.maintainers;
}
