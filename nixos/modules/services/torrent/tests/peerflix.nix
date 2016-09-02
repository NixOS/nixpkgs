# This test runs peerflix and checks if peerflix starts

{ pkgs, ...} : {
  name = "peerflix";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ offline ];
  };

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
