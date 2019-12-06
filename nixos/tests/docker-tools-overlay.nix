# this test creates a simple GNU image with docker tools and sees if it executes

import ./make-test-python.nix ({ pkgs, ... }:
{
  name = "docker-tools-overlay";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ lnl7 ];
  };

  nodes = {
    docker =
      { ... }:
      {
        virtualisation.docker.enable = true;
        virtualisation.docker.storageDriver = "overlay";  # defaults to overlay2
      };
  };

  testScript = ''
      docker.wait_for_unit("sockets.target")

      docker.succeed(
          "docker load --input='${pkgs.dockerTools.examples.bash}'",
          "docker run --rm ${pkgs.dockerTools.examples.bash.imageName} bash --version",
      )

      # Check if the nix store has correct user permissions depending on what
      # storage driver is used, incorrectly built images can show up as readonly.
      # drw-------  3 0 0   3 Apr 14 11:36 /nix
      # drw------- 99 0 0 100 Apr 14 11:36 /nix/store
      docker.succeed("docker run --rm -u 1000:1000 ${pkgs.dockerTools.examples.bash.imageName} bash --version")
    '';
})
