# this test creates a simple GNU image with docker tools and sees if it executes

import ./make-test.nix ({ pkgs, ... }: {
  name = "docker-tools";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ ];
  };

  nodes = {
    docker =
      { config, pkgs, ... }: {
        virtualisation.docker.enable = true;
      };
  };

  testScript =
    let
      dockerImage = pkgs.dockerTools.buildImage {
        name = "hello-docker";
        contents = [ pkgs.hello ];
        tag = "sometag";

        # TODO: create another test checking whether runAsRoot works as intended.

        config = {
          Cmd = [ "hello" ];
        };
      };

    in ''
      $docker->waitForUnit("sockets.target");
      $docker->succeed("docker load --input='${dockerImage}'");
      $docker->succeed("docker run hello-docker:sometag");
    '';

})
