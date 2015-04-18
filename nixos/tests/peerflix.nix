# This test runs peerflix and checks if peerflix starts

import ./make-test.nix {
  name = "peerflix";

  nodes = {
    peerflix =
      { config, pkgs, ... }:
        {
          services.peerflix.enable = true;
        };
    };

  testScript = ''
    startAll;

    $peerflix->waitForUnit("peerflix.service");
    $peerflix->waitUntilSucceeds("curl localhost:9000");
  '';

}
