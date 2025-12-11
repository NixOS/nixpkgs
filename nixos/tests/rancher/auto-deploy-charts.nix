# Tests whether container images are imported and auto deploying Helm charts,
# including the bundled traefik or ingress-nginx, work
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
    name = "${rancherDistro}-pause-image-env";
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
  name = "${rancherPackage.name}-auto-deploy-helm";

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        kubectl
        yq-go
      ];
      environment.sessionVariables.KUBECONFIG = "/etc/rancher/${rancherDistro}/${rancherDistro}.yaml";

      virtualisation = vmResources;

      services.${rancherDistro} = {
        enable = true;
        package = rancherPackage;
        disable =
          {
            k3s = lib.remove "traefik" disabledComponents;
            rke2 = lib.remove "rke2-ingress-nginx" disabledComponents;
          }
          .${rancherDistro};
        images =
          coreImages
          # Provides the k3s Helm controller
          ++ lib.optional (rancherDistro == "k3s") rancherPackage.airgap-images
          ++ [
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
    let
      manifestFormat =
        {
          k3s = "yaml";
          rke2 = "json";
        }
        .${rancherDistro};
    in
    ''
      import json

      machine.wait_for_unit("${serviceName}")
      # check existence/absence of chart manifest files
      machine.succeed("test -e /var/lib/rancher/${rancherDistro}/server/manifests/hello.${manifestFormat}")
      machine.succeed("test ! -e /var/lib/rancher/${rancherDistro}/server/manifests/disabled.${manifestFormat}")
      machine.succeed("test -e /var/lib/rancher/${rancherDistro}/server/manifests/values-file.${manifestFormat}")
      machine.succeed("test -e /var/lib/rancher/${rancherDistro}/server/manifests/advanced.${manifestFormat}")
      # check that the timeout is set correctly, select only the first item in advanced.yaml
      advancedManifest = json.loads(machine.succeed("yq -o json '.items[0]' /var/lib/rancher/${rancherDistro}/server/manifests/advanced.${manifestFormat}"))
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
      # wait for bundled ingress deployment
      ${
        {
          k3s = ''
            machine.wait_until_succeeds("kubectl -n kube-system rollout status deployment traefik", timeout=180)
          '';
          rke2 = ''
            machine.wait_until_succeeds("kubectl -n kube-system rollout status daemonset rke2-ingress-nginx-controller", timeout=180)
          '';
        }
        .${rancherDistro}
      }
    '';

  meta.maintainers = lib.teams.k3s.members ++ pkgs.rke2.meta.maintainers;
}
