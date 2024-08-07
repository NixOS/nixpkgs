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
          fqdn = "example.com";
        };
        api = {
          fqdn = "example.com";
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
