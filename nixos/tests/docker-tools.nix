# this test creates a simple GNU image with docker tools and sees if it executes

import ./make-test.nix ({ pkgs, ... }: {
  name = "docker-tools";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ lnl7 ];
  };

  nodes = {
    docker =
      { config, pkgs, ... }: {
        virtualisation = {
          diskSize = 2048;
          docker.enable = true;
        };
      };
  };

  testScript =
    ''
      $docker->waitForUnit("sockets.target");

      $docker->succeed("docker load --input='${pkgs.dockerTools.examples.bash}'");
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
    '';
})
