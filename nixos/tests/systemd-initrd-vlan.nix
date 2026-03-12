{ lib, ... }:
{
  name = "systemd-initrd-vlan";
  meta.maintainers = [ lib.maintainers.majiir ];

  # Tests VLAN interface configuration in systemd-initrd.
  #
  # Two nodes are configured for a tagged VLAN. (Note that they also still have
  # their ordinary eth0 and eth1 interfaces, which are not VLAN-tagged.)
  #
  # The 'server' node waits forever in initrd (stage 1) with networking
  # enabled. The 'client' node pings it to test network connectivity.

  nodes =
    let
      network = id: {
        networking = {
          vlans."eth1.10" = {
            id = 10;
            interface = "eth1";
          };
          interfaces."eth1.10" = {
            ipv4.addresses = [
              {
                address = "192.168.10.${id}";
                prefixLength = 24;
              }
            ];
          };
        };
      };
    in
    {
      # Node that will use initrd networking.
      server = network "1" // {
        boot.initrd.systemd.enable = true;
        boot.initrd.network.enable = true;
        boot.initrd.systemd.services.boot-blocker = {
          before = [ "initrd.target" ];
          wantedBy = [ "initrd.target" ];
          script = "sleep infinity";
          serviceConfig.Type = "oneshot";
        };
      };

      # Node that will ping the server.
      client = network "2";
    };

  testScript = ''
    start_all()
    client.wait_for_unit("network.target")

    # Wait for the regular (untagged) interface to be up.
    def server_is_up(_) -> bool:
        status, _ = client.execute("ping -n -c 1 server >&2")
        return status == 0
    with client.nested("waiting for server to come up"):
        retry(server_is_up)

    # Try to ping the (tagged) VLAN interface.
    client.succeed("ping -n -w 10 -c 1 192.168.10.1 >&2")
  '';
}
