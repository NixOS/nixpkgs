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
          # FIXME: The default "devicemapper" storageDriver fails in NixOS VM
          # tests.
          virtualisation.docker.storageDriver = "overlay";
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
