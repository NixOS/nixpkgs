# Tests whether container images are imported and auto deploying manifests work
import ../make-test-python.nix (
  {
    pkgs,
    lib,
    k3s,
    ...
  }:
  let
    pauseImageEnv = pkgs.buildEnv {
      name = "k3s-pause-image-env";
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
    name = "${k3s.name}-auto-deploy";

    nodes.machine =
      { pkgs, ... }:
      {
        environment.systemPackages = [ k3s ];

        # k3s uses enough resources the default vm fails.
        virtualisation.memorySize = 1536;
        virtualisation.diskSize = 4096;

        services.k3s.enable = true;
        services.k3s.role = "server";
        services.k3s.package = k3s;
        # Slightly reduce resource usage
        services.k3s.extraFlags = [
          "--disable coredns"
          "--disable local-storage"
          "--disable metrics-server"
          "--disable servicelb"
          "--disable traefik"
          "--pause-image test.local/pause:local"
        ];
        services.k3s.images = [
          pauseImage
          helloImage
        ];
        services.k3s.manifests = {
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

    testScript = # python
      ''
        start_all()

        machine.wait_for_unit("k3s")
        # check existence of the manifest files
        machine.fail("ls /var/lib/rancher/k3s/server/manifests/absent.yaml")
        machine.succeed("ls /var/lib/rancher/k3s/server/manifests/foo-namespace.yaml")
        machine.succeed("ls /var/lib/rancher/k3s/server/manifests/hello.yaml")

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
