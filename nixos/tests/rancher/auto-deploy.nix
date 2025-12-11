# Tests whether container images are imported and auto deploying manifests work
import ../make-test-python.nix (
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
    pauseImageEnv = pkgs.buildEnv {
      name = "${rancherDistro}-pause-image-env";
      paths = with pkgs; [
        tini
        (lib.hiPrio coreutils)
        busybox
      ];
    };
    pauseImage = pkgs.dockerTools.buildImage {
      name = "test.local/pause";
      tag = "local";
      copyToRoot = pauseImageEnv;
      config.Entrypoint = [
        "/bin/tini"
        "--"
        "/bin/sleep"
        "inf"
      ];
    };
    helloImage = pkgs.dockerTools.buildImage {
      name = "test.local/hello";
      tag = "local";
      copyToRoot = pkgs.hello;
      config.Entrypoint = [ "${pkgs.hello}/bin/hello" ];
    };

    manifestFormat =
      {
        k3s = "yaml";
        rke2 = "json";
      }
      .${rancherDistro};
  in
  {
    name = "${rancherPackage.name}-auto-deploy";

    nodes.machine =
      { pkgs, ... }:
      {
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
          disable = disabledComponents;
          extraFlags = [
            "--pause-image test.local/pause:local"
          ];
          images = coreImages ++ [
            pauseImage
            helloImage
          ];
          manifests = {
            absent = {
              enable = false;
              content = {
                apiVersion = "v1";
                kind = "Namespace";
                metadata.name = "absent";
              };
            };

            present = {
              target = "foo-namespace.${manifestFormat}";
              content = {
                apiVersion = "v1";
                kind = "Namespace";
                metadata.name = "foo";
              };
            };

            hello.content = {
              apiVersion = "batch/v1";
              kind = "Job";
              metadata.name = "hello";
              spec = {
                template.spec = {
                  containers = [
                    {
                      name = "hello";
                      image = "test.local/hello:local";
                    }
                  ];
                  restartPolicy = "OnFailure";
                };
              };
            };
          };
        };
      };

    testScript = # python
      ''
        start_all()

        machine.wait_for_unit("${serviceName}")
        # check existence of the manifest files
        machine.fail("ls /var/lib/rancher/${rancherDistro}/server/manifests/absent.${manifestFormat}")
        machine.succeed("ls /var/lib/rancher/${rancherDistro}/server/manifests/foo-namespace.${manifestFormat}")
        machine.succeed("ls /var/lib/rancher/${rancherDistro}/server/manifests/hello.${manifestFormat}")

        # check if container images got imported
        # for some reason, RKE2 also uses /run/k3s
        machine.wait_until_succeeds("crictl -r /run/k3s/containerd/containerd.sock img | grep 'test\.local/pause'")
        machine.wait_until_succeeds("crictl -r /run/k3s/containerd/containerd.sock img | grep 'test\.local/hello'")

        # check if resources of manifests got created
        machine.wait_until_succeeds("kubectl get ns foo")
        machine.wait_until_succeeds("kubectl wait --for=condition=complete job/hello")
        machine.fail("kubectl get ns absent")
      '';

    meta.maintainers = lib.teams.k3s.members ++ pkgs.rke2.meta.maintainers;
  }
)
