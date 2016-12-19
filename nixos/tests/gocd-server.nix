# verifies:
#   1. GoCD server starts
#   2. GoCD server responds

import ./make-test.nix ({ pkgs, ...} :

{
  name = "gocd-server";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ swarren83 ];
  };

nodes = {
  gocd_server =
    { config, pkgs, ... }:
    {
      virtualisation.memorySize = 2046;
      services.gocd-server.enable = true;
    };
};

  testScript = ''
    $gocd_server->start;
    $gocd_server->waitForUnit("gocd-server");
    $gocd_server->waitForOpenPort("8153");
    $gocd_server->waitUntilSucceeds("curl -s -f localhost:8153/go");
  '';
})
