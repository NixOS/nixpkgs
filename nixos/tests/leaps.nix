import ./make-test.nix ({ pkgs,  ... }:

{
  name = "leaps";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ qknight ];
  };

  nodes =
    { 
      client = { };

      server =
        { services.leaps = {
            enable = true;
            port = 6666;
            path = "/leaps/";
          };
          networking.firewall.enable = false;
        };
    };

  testScript =
    ''
      startAll;
      $server->waitForOpenPort(6666);
      $client->waitForUnit("network.target");
      $client->succeed("${pkgs.curl}/bin/curl http://server:6666/leaps/ | grep -i 'leaps'");
    '';
})
