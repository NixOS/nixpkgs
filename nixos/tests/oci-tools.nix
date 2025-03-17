# This test creates a simple image with `ociTools` and sees if it executes.

import ./make-test-python.nix (
  { pkgs, lib, ... }:
  let
    basicImage = pkgs.ociTools.buildImage {
      name = "bash";
      tag = "latest";
      copyToRoot = [ pkgs.bash ];
      extraOCIArgs.outputFormat = "tarball";
    };

    layeredImage = pkgs.ociTools.buildLayeredImage rec {
      name = "layered-animals";
      tag = "latest";
      contents = [
        pkgs.cowsay
        pkgs.ponysay
      ];
      extraOCIArgs.name = name;
    };

    convertedImage = pkgs.ociTools.toOCIImage {
      # runs `hello`.
      docker-tarball = pkgs.dockerTools.examples.layered-image;
    };
  in
  {
    name = "oci-tools";
    meta.maintainers = [ pkgs.lib.maintainers.msanft ];

    nodes.machine =
      { pkgs, ... }:
      {
        virtualisation = {
          diskSize = 3072;
          docker.enable = true;
        };
        environment.systemPackages = [ pkgs.skopeo ];
      };

    testScript = ''
      machine.wait_for_unit("sockets.target")

      with subtest("Image conversion works"):
          with subtest("assumption"):
              machine.succeed("skopeo copy oci:${convertedImage} docker-daemon:hello:latest --insecure-policy")
              machine.succeed("docker run --rm hello | grep -i hello")
              machine.succeed("docker image rm hello:latest")

      with subtest("Basic image building works"):
          with subtest("assumption"):
              machine.succeed("skopeo copy oci-archive:${basicImage} docker-daemon:bash:latest --insecure-policy")
              machine.succeed("docker run --rm bash ${lib.getExe pkgs.bash} -c 'echo hello' | grep -i hello")
              machine.succeed("docker image rm bash:latest")

      with subtest("Layered image building works"):
          with subtest("assumption"):
              machine.succeed("skopeo copy oci:${layeredImage} docker-daemon:layered-animals:latest --insecure-policy")
              machine.succeed("docker run --rm layered-animals ${lib.getExe pkgs.cowsay} 'hello' | grep -i hello")
              machine.succeed("docker image rm layered-animals:latest")
    '';
  }
)
