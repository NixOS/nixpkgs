# This test runs the fedimintd and verifies that it starts

{ pkgs, ... }:

{
  name = "fedimintd";

  meta = with pkgs.lib.maintainers; {
    maintainers = [ dpc ];
  };

  nodes.machine =
    { ... }:
    {
      services.fedimintd."mainnet" = {
        enable = true;
        p2p = {
          url = "fedimint://example.com";
        };
        api_ws = {
          url = "wss://example.com";
        };
        environment = { };
      };
    };

  testScript =
    { nodes, ... }:
    ''
      start_all()

      machine.wait_for_unit("fedimintd-mainnet.service")
      machine.wait_for_open_port(${toString nodes.machine.services.fedimintd.mainnet.api_ws.port})
    '';
}
