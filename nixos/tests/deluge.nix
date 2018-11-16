import ./make-test.nix ({ pkgs, ...} : {
  name = "deluge";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ flokli ];
  };

  nodes = {
    server =
      { ... }:

      { services.deluge = {
          enable = true;
          web.enable = true;
        };
        networking.firewall.allowedTCPPorts = [ 8112 ];
      };

    client = { };
  };

  testScript = ''
    startAll;

    $server->waitForUnit("deluged");
    $server->waitForUnit("delugeweb");
    $client->waitForUnit("network.target");
    $client->waitUntilSucceeds("curl --fail http://server:8112");
  '';
})
