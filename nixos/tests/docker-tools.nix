# this test creates a simple GNU image with docker tools and sees if it executes

import ./make-test.nix ({ pkgs, ... }: {
  name = "docker-tools";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ lnl7 ];
  };

  nodes = {
    docker =
      { ... }: {
        virtualisation = {
          diskSize = 2048;
          docker.enable = true;
        };
      };
  };

  testScript =
    ''
      $docker->waitForUnit("sockets.target");

      # Ensure Docker images use a stable date by default
      $docker->succeed("docker load --input='${pkgs.dockerTools.examples.bash}'");
      $docker->succeed("[ '1970-01-01T00:00:01Z' = \"\$(docker inspect ${pkgs.dockerTools.examples.bash.imageName} | ${pkgs.jq}/bin/jq -r .[].Created)\" ]");

      $docker->succeed("docker run --rm ${pkgs.dockerTools.examples.bash.imageName} bash --version");
      $docker->succeed("docker rmi ${pkgs.dockerTools.examples.bash.imageName}");

      # Check if the nix store is correctly initialized by listing dependencies of the installed Nix binary
      $docker->succeed("docker load --input='${pkgs.dockerTools.examples.nix}'");
      $docker->succeed("docker run --rm ${pkgs.dockerTools.examples.nix.imageName} nix-store -qR ${pkgs.nix}");
      $docker->succeed("docker rmi ${pkgs.dockerTools.examples.nix.imageName}");

      # To test the pullImage tool
      $docker->succeed("docker load --input='${pkgs.dockerTools.examples.nixFromDockerHub}'");
      $docker->succeed("docker run --rm nixos/nix:1.11 nix-store --version");
      $docker->succeed("docker rmi nixos/nix:1.11");

      # To test runAsRoot and entry point
      $docker->succeed("docker load --input='${pkgs.dockerTools.examples.nginx}'");
      $docker->succeed("docker run --name nginx -d -p 8000:80 ${pkgs.dockerTools.examples.nginx.imageName}");
      $docker->waitUntilSucceeds('curl http://localhost:8000/');
      $docker->succeed("docker rm --force nginx");
      $docker->succeed("docker rmi '${pkgs.dockerTools.examples.nginx.imageName}'");

      # An pulled image can be used as base image
      $docker->succeed("docker load --input='${pkgs.dockerTools.examples.onTopOfPulledImage}'");
      $docker->succeed("docker run --rm ontopofpulledimage hello");
      $docker->succeed("docker rmi ontopofpulledimage");

      # Regression test for issue #34779
      $docker->succeed("docker load --input='${pkgs.dockerTools.examples.runAsRootExtraCommands}'");
      $docker->succeed("docker run --rm runasrootextracommands cat extraCommands");
      $docker->succeed("docker run --rm runasrootextracommands cat runAsRoot");
      $docker->succeed("docker rmi '${pkgs.dockerTools.examples.runAsRootExtraCommands.imageName}'");

      # Ensure Docker images can use an unstable date
      $docker->succeed("docker load --input='${pkgs.dockerTools.examples.bash}'");
      $docker->succeed("[ '1970-01-01T00:00:01Z' != \"\$(docker inspect ${pkgs.dockerTools.examples.unstableDate.imageName} | ${pkgs.jq}/bin/jq -r .[].Created)\" ]");

      # Ensure Layered Docker images work
      $docker->succeed("docker load --input='${pkgs.dockerTools.examples.layered-image}'");
      $docker->succeed("docker run --rm ${pkgs.dockerTools.examples.layered-image.imageName}");
      $docker->succeed("docker run --rm ${pkgs.dockerTools.examples.layered-image.imageName} cat extraCommands");

      # Ensure building an image on top of a layered Docker images work
      $docker->succeed("docker load --input='${pkgs.dockerTools.examples.layered-on-top}'");
      $docker->succeed("docker run --rm ${pkgs.dockerTools.examples.layered-on-top.imageName}");
    '';
})
