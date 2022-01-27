import ./make-test-python.nix ({ lib, ...} : {
  name = "opentracker";
  meta = with lib.maintainers; {
    maintainers = [ ];
  };

  nodes = {
    server = { ... }: {
      services.opentracker = {
        enable = true;
        whitelist = [ "e368633c136582fc3eab4a77b1c75c36151a8eef" ];
        restrictStats.enable = true;
        restrictStats.allow.ipv4 = [ "127.0.0.1" ];
        extraConfig."tracker.redirect_url" = "https://nixos.org/";
      };

      networking.firewall = {
        allowedTCPPorts = [ 6969 ];
        allowedUDPPorts = [ 6969 ];
      };
    };

    client = { ... }: { };
  };

  testScript = { ... }: ''
    start_all()

    server.wait_for_unit("opentracker.target")
    server.wait_for_unit("network.target")
    server.wait_for_open_port(6969)

    assert "https://nixos.org/" in server.succeed(
        "curl -f -s -v http://127.0.0.1:6969/ 2>&1"
    ), "extraConfig was ignored"
    server.succeed("curl -f -s 'http://127.0.0.1:6969/stats?mode=everything'")

    client.wait_for_unit("network.target")

    client.succeed("curl -f -s http://server:6969/")
    client.fail("curl -f -s http://server:6969/stats")
  '';
})
