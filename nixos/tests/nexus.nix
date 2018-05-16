# verifies:
#   1. nexus service starts on server
#   2. nexus service can startup on server (creating database and all other initial stuff)
#   3. the web application is reachable via HTTP

import ./make-test.nix ({ pkgs, ...} : {
  name = "nexus";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ ironpinguin ma27 ];
  };

  nodes = {

    server =
      { config, pkgs, ... }:
      { virtualisation.memorySize = 2048;
        virtualisation.diskSize = 2048;

        services.nexus.enable = true;
      };

  };

  testScript = ''
    startAll;

    $server->waitForUnit("nexus");
    $server->waitForOpenPort(8081);

    $server->succeed("curl -f 127.0.0.1:8081");
  '';
})
