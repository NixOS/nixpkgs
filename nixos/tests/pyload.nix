{ lib, ... }:
{
  name = "pyload";
  meta.maintainers = with lib.maintainers; [ ambroisie ];

  nodes = {
    machine =
      { ... }:
      {
        services.pyload = {
          enable = true;

          listenAddress = "0.0.0.0";
          port = 9876;
        };

        networking.firewall.allowedTCPPorts = [ 9876 ];
      };

    client = { };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("pyload.service")

    with subtest("Web interface accessible locally"):
        machine.wait_until_succeeds("curl -fs localhost:9876")

    client.wait_for_unit("network.target")

    with subtest("Web interface accessible from a different machine"):
        client.wait_until_succeeds("curl -fs machine:9876")
  '';
}
