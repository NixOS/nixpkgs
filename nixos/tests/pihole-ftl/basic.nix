# A basic test with no webserver, no API, just checking DNS functionality
{
  lib,
  pkgs,
  ...
}:

rec {
  name = "pihole-ftl-basic";
  meta.maintainers = with lib.maintainers; [ averyvigolo ];

  nodes.machine =
    { pkgs, lib, ... }:
    {
      services.pihole-ftl = {
        enable = true;
        openFirewallDNS = true;
      };
      environment.systemPackages = with pkgs; [ dig ];
    };

  nodes.client =
    { pkgs, lib, ... }:
    {
      environment.systemPackages = with pkgs; [ dig ];
    };

  testScript =
    { nodes, ... }:
    ''
      machine.wait_for_unit("pihole-ftl.service")
      machine.wait_for_open_port(53)
      client.wait_for_unit("network.target")

      with subtest("the pi-hole machine resolves properly"):
        ret, out = machine.execute("dig @localhost +short pi.hole")
        assert ret == 0, "pi.hole should resolve on the local machine"
        assert out.rstrip() == "127.0.0.1", "pi.hole should resolve to localhost on the local machine"

      machine_address = "${(builtins.head nodes.machine.networking.interfaces.eth1.ipv4.addresses).address}"

      with subtest("a client machine resolves properly"):
        ret, out = client.execute(f"dig @{machine_address} +short pi.hole")
        assert ret == 0, "pi.hole should resolve on a client machine"
        assert out.rstrip() == machine_address, "pi.hole should resolve to the machine's address"
    '';
}
