# Tests that a container image whose contents change (same name and tag)
# is detected and re-imported by the cluster.
# It only declares the image change (via a NixOS specialisation) and checks
# the end result (the pod output); it never inspects how the image is linked.
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
  containerdSocket =
    {
      k3s = "/run/k3s/containerd/containerd.sock";
      rke2 = "/run/rke2/containerd/containerd.sock";
    }
    .${rancherDistro};

  # Build a Docker image with a fixed name but an auto-generated tag based on
  # the derivation hash. Two derivations with different contents produce
  # different tags, so the cluster treats them as distinct images.
  mkTestImage =
    commandOutput:
    pkgs.dockerTools.buildImage {
      name = "test.local/test";
      compressor = "zstd";
      copyToRoot = pkgs.busybox;
      config = {
        Entrypoint = [ "sh" ];
        Cmd = [
          "-c"
          "echo '${commandOutput}'"
        ];
      };
    };

  testImageV1 = mkTestImage "image v1 deployed";
  testImageV2 = mkTestImage "image v2 deployed";
in
{
  name = "${rancherPackage.name}-image-upgrade";
  interactive.sshBackdoor.enable = true;

  nodes.machine =
    { pkgs, ... }:
    {
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
          coreImages ++ lib.optional (rancherDistro == "k3s") rancherPackage.airgap-images ++ [ testImageV1 ];
      };

      # A declaration that swaps the image for one with the same name but a
      # different auto-generated tag and different contents. Switching to this
      # specialisation is the only thing the test does to trigger a re-import.
      specialisation.image-v2 = {
        inheritParentConfig = true;
        configuration =
          { lib, ... }:
          {
            services.${rancherDistro}.images = lib.mkForce (
              coreImages ++ lib.optional (rancherDistro == "k3s") rancherPackage.airgap-images ++ [ testImageV2 ]
            );
          };
      };
    };

  testScript =
    { nodes, ... }:
    ''
      def switch_to_v2():
          toplevel = "${nodes.machine.system.build.toplevel}"
          machine.succeed(f"{toplevel}/specialisation/image-v2/bin/switch-to-configuration switch")

      machine.wait_for_unit("${serviceName}")

      with subtest("v1 image is imported and runs"):
          machine.wait_until_succeeds("crictl -r ${containerdSocket} img | grep 'test\\.local/test'")
          machine.wait_until_succeeds("kubectl get sa default")
          machine.succeed("kubectl create job test-job --image=${testImageV1.imageName}:${testImageV1.imageTag}")
          machine.wait_until_succeeds("kubectl wait --for=condition=complete job/test-job --timeout=180s")
          v1_output = machine.succeed("kubectl logs -l batch.kubernetes.io/job-name=test-job --tail=-1").rstrip()
          t.assertEqual(v1_output, "image v1 deployed", f"unexpected v1 output: {v1_output!r}")

      with subtest("Same-name image with different auto-generated tag is re-imported"):
          machine.succeed("kubectl delete job test-job --ignore-not-found=true")
          switch_to_v2()
          machine.succeed("kubectl create job test-job --image=${testImageV2.imageName}:${testImageV2.imageTag}")
          machine.wait_until_succeeds("kubectl wait --for=condition=complete job/test-job --timeout=240s")
          v2_output = machine.succeed("kubectl logs -l batch.kubernetes.io/job-name=test-job --tail=-1").rstrip()
          t.assertEqual(v2_output, "image v2 deployed", f"unexpected v2 output: {v2_output!r}")
    '';

  meta.maintainers = lib.teams.k3s.members ++ pkgs.rke2.meta.maintainers;
}
