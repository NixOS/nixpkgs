# verifies:
#   1. GoCD server starts
#   2. GoCD server responds

import ./make-test-python.nix ({ pkgs, ...} :

{
  name = "gocd-server";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ swarren83 ];
  };

  nodes = {
    server =
      { ... }:
      {
        virtualisation.memorySize = 2046;
        services.gocd-server.enable = true;
      };
  };

  testScript = ''
    server.start()
    server.wait_for_unit("gocd-server")
    server.wait_for_open_port(8153)
    server.wait_until_succeeds("curl -s -f localhost:8153/go")
  '';
})
