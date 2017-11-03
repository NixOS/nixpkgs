# verifies:
#   1. nexus service starts on server
#   2. nexus user can be extended on server
#   3. nexus service not can startup on server (creating database and all other initial stuff)

import ./make-test.nix ({ pkgs, ...} : {
  name = "nexus";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ ironpinguin ];
  };

  nodes = {

    server =
      { config, pkgs, ... }:
      { virtualisation.memorySize = 2048;

        services.nexus.enable = true;

        users.extraUsers.nexus.extraGroups = [ "users" ];
      };
  };

  testScript = ''
    startAll;

    $server->waitForUnit("nexus");

    print $server->execute("sudo -u nexus groups");
    $server->mustSucceed("sudo -u nexus groups | grep nexus | grep users");

    $server->waitForOpenPort(8081);
  '';
})
