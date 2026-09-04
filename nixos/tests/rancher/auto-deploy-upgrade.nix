# Tests that a Helm chart whose package changes (same name and version,
# different contents) is detected and redeployed by the cluster.
# It only declares the chart change (via a NixOS specialisation) and checks
# the end result (the chart job's output); it never inspects how the chart is
# served or referenced.
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
  testImage = pkgs.dockerTools.buildImage {
    name = "test.local/test";
    tag = "local";
    compressor = "zstd";
    copyToRoot = pkgs.busybox;
  };
  # Pack a test Helm chart as a .tgz archive. The chart's job template
  # hard-codes `commandOutput` so that two charts with the same name and
  # version but different contents produce a different, observable output.
  mkTestChartPackage =
    commandOutput:
    pkgs.runCommand "${rancherDistro}-test-chart.tgz"
      {
        nativeBuildInputs = [ pkgs.kubernetes-helm ];
        chart = builtins.toJSON {
          name = "${rancherDistro}-test-chart";
          version = "0.1.0";
        };
        values = builtins.toJSON {
          restartPolicy = "Never";
          image = {
            repository = testImage.imageName;
            tag = testImage.imageTag;
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
                      "echo '${commandOutput}'"
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
  # Two charts with the same name and version, differing only in their
  # template's output.
  testChartPackage = mkTestChartPackage "chart v1 deployed";
  testChartV2Package = mkTestChartPackage "chart v2 deployed";
  chart = package: {
    inherit package;
    values = {
      image = {
        repository = testImage.imageName;
        tag = testImage.imageTag;
      };
    };
  };
in
{
  name = "${rancherPackage.name}-auto-deploy-upgrade";
  interactive.sshBackdoor.enable = true;

  nodes.machine = { pkgs, ... }: {
    imports = [ ../../modules/profiles/base.nix ];

    environment.systemPackages = with pkgs; [
      kubectl
      cri-tools
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
      autoDeployCharts = {
        chart-hello = chart testChartPackage;
      };
    };

    # A declaration that swaps chart-hello for a chart with the same name and
    # version but different contents. Switching to this specialisation is the
    # only thing the test does to trigger a redeploy.
    specialisation.chart-v2 = {
      inheritParentConfig = true;
      configuration = { lib, ... }: {
        services.${rancherDistro}.autoDeployCharts.chart-hello = lib.mkForce (chart testChartV2Package);
      };
    };
  };

  testScript =
    { nodes, ... }:
    ''
      def switch_to_v2():
          toplevel = "${nodes.machine.system.build.toplevel}";
          machine.succeed(f"{toplevel}/specialisation/chart-v2/bin/switch-to-configuration switch")

      machine.wait_for_unit("${serviceName}")

      with subtest("v1 chart is deployed"):
          machine.wait_until_succeeds("kubectl wait --for=condition=complete job/chart-hello --timeout=180s")
          v1_output = machine.succeed("kubectl logs -l batch.kubernetes.io/job-name=chart-hello").rstrip()
          t.assertEqual(v1_output, "chart v1 deployed", f"unexpected v1 output: {v1_output!r}")

      with subtest("Same-name/same-version chart with different contents is redeployed"):
          # Remove the completed v1 job so the redeploy is unambiguous.
          machine.succeed("kubectl delete job chart-hello --ignore-not-found=true")
          switch_to_v2()
          machine.wait_until_succeeds("kubectl wait --for=condition=complete job/chart-hello --timeout=240s")
          v2_output = machine.succeed("kubectl logs -l batch.kubernetes.io/job-name=chart-hello").rstrip()
          t.assertEqual(v2_output, "chart v2 deployed", f"unexpected v2 output: {v2_output!r}")
    '';

  meta.maintainers = lib.teams.k3s.members ++ pkgs.rke2.meta.maintainers;
}
