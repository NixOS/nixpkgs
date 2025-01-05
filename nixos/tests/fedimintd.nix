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
        api = {
          url = "wss://example.com";
        };
        environment = {
          "FM_REL_NOTES_ACK" = "0_4_xyz";
        };
      };
    };

  testScript =
    { nodes, ... }:
    ''
      start_all()

      machine.wait_for_unit("fedimintd-mainnet.service")
      machine.wait_for_open_port(${toString nodes.machine.services.fedimintd.mainnet.api.port})
    '';
}
