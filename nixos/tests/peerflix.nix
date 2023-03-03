# This test runs peerflix and checks if peerflix starts

import ./make-test-python.nix ({ pkgs, ...} : {
  name = "peerflix";
  meta = with pkgs.lib.maintainers; {
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
    start_all()

    peerflix.wait_for_unit("peerflix.service")
    peerflix.wait_until_succeeds("curl -f localhost:9000")
  '';
})
