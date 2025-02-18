import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "sonic-server";

    meta = {
      maintainers = with lib.maintainers; [ anthonyroussel ];
    };

    nodes.machine =
      { pkgs, ... }:
      {
        services.sonic-server.enable = true;
      };

    testScript = ''
      machine.start()

      machine.wait_for_unit("sonic-server.service")
      machine.wait_for_open_port(1491)

      with subtest("Check control mode"):
        result = machine.succeed('(echo START control; sleep 1; echo PING; echo QUIT) | nc localhost 1491').splitlines()
        assert result[2] == "PONG", f"expected 'PONG', got '{result[2]}'"
    '';
  }
)
