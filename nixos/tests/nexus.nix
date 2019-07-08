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
      { ... }:
      { virtualisation.memorySize = 2047; # qemu-system-i386 has a 2047M limit
        virtualisation.diskSize = 8192;

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
