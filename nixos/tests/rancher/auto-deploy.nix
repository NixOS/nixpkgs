# Tests whether container images are imported and auto deploying manifests work
import ../make-test-python.nix (
  {
    pkgs,
    lib,
    rancherDistro,
    rancherPackage,
    serviceName,
    disabledComponents,
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
  in
  {
    name = "${rancherPackage.name}-auto-deploy";

    nodes.machine =
      { pkgs, ... }:
      {
        environment.systemPackages = [ rancherPackage ];

        # k3s uses enough resources the default vm fails.
        virtualisation.memorySize = 1536;
        virtualisation.diskSize = 4096;

        services.${rancherDistro} = {
          enable = true;
          role = "server";
          package = rancherPackage;
          disable = disabledComponents;
          extraFlags = [
            "--pause-image test.local/pause:local"
          ];
          images = [
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
              target = "foo-namespace.yaml";
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
        machine.fail("ls /var/lib/rancher/${rancherDistro}/server/manifests/absent.yaml")
        machine.succeed("ls /var/lib/rancher/${rancherDistro}/server/manifests/foo-namespace.yaml")
        machine.succeed("ls /var/lib/rancher/${rancherDistro}/server/manifests/hello.yaml")

        # check if container images got imported
        machine.wait_until_succeeds("crictl img | grep 'test\.local/pause'")
        machine.wait_until_succeeds("crictl img | grep 'test\.local/hello'")

        # check if resources of manifests got created
        machine.wait_until_succeeds("kubectl get ns foo")
        machine.wait_until_succeeds("kubectl wait --for=condition=complete job/hello")
        machine.fail("kubectl get ns absent")
      '';

    meta.maintainers = lib.teams.k3s.members;
  }
)
