import ./make-test-python.nix ({ pkgs,  ... }:

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
      start_all()
      server.wait_for_open_port(6666)
      client.wait_for_unit("network.target")
      assert "leaps" in client.succeed(
          "${pkgs.curl}/bin/curl http://server:6666/leaps/"
      )
    '';
})
