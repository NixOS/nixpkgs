# This test runs docker and checks if simple container starts

import ./make-test.nix ({ pkgs, ...} : {
  name = "docker";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ offline ];
  };

  nodes = {
    docker =
      { config, pkgs, ... }:
        {
          virtualisation.docker.enable = true;
        };
    };

  testScript = ''
    startAll;

    $docker->waitForUnit("sockets.target");
    $docker->succeed("tar cv --files-from /dev/null | docker import - scratchimg");
    $docker->succeed("docker run -d --name=sleeping -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin scratchimg /bin/sleep 10");
    $docker->succeed("docker ps | grep sleeping");
    $docker->succeed("docker stop sleeping");
  '';
})
