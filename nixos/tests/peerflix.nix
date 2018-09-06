# This test runs peerflix and checks if peerflix starts

import ./make-test.nix ({ pkgs, ...} : {
  name = "peerflix";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ offline ];
  };

  nodes = {
    peerflix =
      { ... }:
        {
          services.peerflix.enable = true;
        };
    };

  testScript = ''
    startAll;

    $peerflix->waitForUnit("peerflix.service");
    $peerflix->waitUntilSucceeds("curl localhost:9000");
  '';
})
