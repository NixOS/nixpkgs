# this test creates a simple GNU image with docker tools and sees if it executes

import ./make-test.nix ({ pkgs, ... }: {
  name = "docker-tools";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ ];
  };

  nodes = {
    docker =
      { config, pkgs, ... }: {
        virtualisation = {
          diskSize = 1024;
          docker.enable = true;
        };
      };
  };

  testScript =
    ''
      $docker->waitForUnit("sockets.target");

      $docker->succeed("docker load --input='${pkgs.dockerTools.examples.bash}'");
      $docker->succeed("docker run ${pkgs.dockerTools.examples.bash.imageName} /bin/bash --version");

      $docker->succeed("docker load --input='${pkgs.dockerTools.examples.nix}'");
      $docker->succeed("docker run ${pkgs.dockerTools.examples.nix.imageName} /bin/nix-store -qR ${pkgs.nix}");

      # To test the pullImage tool
      $docker->succeed("docker load --input='${pkgs.dockerTools.examples.nixFromDockerHub}'");
      $docker->succeed("docker run nixos/nix:1.11 nix-store --version");

      # To test runAsRoot and entry point
      $docker->succeed("docker load --input='${pkgs.dockerTools.examples.nginx}'");
      $docker->succeed("docker run --name nginx -d -p 8000:80 ${pkgs.dockerTools.examples.nginx.imageName}");
      $docker->waitUntilSucceeds('curl http://localhost:8000/');
      $docker->succeed("docker rm --force nginx");
    '';
})
