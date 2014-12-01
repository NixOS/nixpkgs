# This test runs docker and checks if simple container starts

import ./make-test.nix {
  name = "docker";

  nodes = {
    docker =
      { config, pkgs, ... }:
        {
          virtualisation.docker.enable = true;
        };
    };

  testScript = ''
    startAll;

    $docker->waitForUnit("docker.service");
    $docker->succeed("tar cv --files-from /dev/null | docker import - scratch");
    $docker->succeed("docker run -d --name=sleeping -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin scratch /bin/sleep 10");
    $docker->succeed("docker ps | grep sleeping");
    $docker->succeed("docker stop sleeping");
  '';

}
