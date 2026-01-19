{ pkgs, lib, ... }:
{
  name = "containers-physical_interfaces";
  meta = {
  };

  nodes = {
    server =
      { ... }:
      {
        virtualisation.vlans = [ 1 ];

        containers.server = {
          privateNetwork = true;
          interfaces = [ "eth1" ];

          config = {
            networking.interfaces.eth1.ipv4.addresses = [
              {
                address = "10.10.0.1";
                prefixLength = 24;
              }
            ];
            networking.firewall.enable = false;
          };
        };
      };
    bridged =
      { ... }:
      {
        virtualisation.vlans = [ 1 ];

        containers.bridged = {
          privateNetwork = true;
          interfaces = [ "eth1" ];

          config = {
            networking.bridges.br0.interfaces = [ "eth1" ];
            networking.interfaces.br0.ipv4.addresses = [
              {
                address = "10.10.0.2";
                prefixLength = 24;
              }
            ];
            networking.firewall.enable = false;
          };
        };
      };

    bonded =
      { ... }:
      {
        virtualisation.vlans = [ 1 ];

        containers.bonded = {
          privateNetwork = true;
          interfaces = [ "eth1" ];

          config = {
            networking.bonds.bond0 = {
              interfaces = [ "eth1" ];
              driverOptions.mode = "active-backup";
            };
            networking.interfaces.bond0.ipv4.addresses = [
              {
                address = "10.10.0.3";
                prefixLength = 24;
              }
            ];
            networking.firewall.enable = false;
          };
        };
      };

    bridgedbond =
      { ... }:
      {
        virtualisation.vlans = [ 1 ];

        containers.bridgedbond = {
          privateNetwork = true;
          interfaces = [ "eth1" ];

          config = {
            networking.bonds.bond0 = {
              interfaces = [ "eth1" ];
              driverOptions.mode = "active-backup";
            };
            networking.bridges.br0.interfaces = [ "bond0" ];
            networking.interfaces.br0.ipv4.addresses = [
              {
                address = "10.10.0.4";
                prefixLength = 24;
              }
            ];
            networking.firewall.enable = false;
          };
        };
      };
  };

  testScript = ''
    start_all()

    with subtest("Prepare server"):
        server.wait_for_unit("default.target")
        server.succeed("ip link show dev eth1 >&2")

    with subtest("Simple physical interface is up"):
        server.succeed("nixos-container start server")
        server.wait_for_unit("container@server")
        server.succeed(
            "systemctl -M server list-dependencies network-addresses-eth1.service >&2"
        )

        # The other tests will ping this container on its ip. Here we just check
        # that the device is present in the container.
        server.succeed("nixos-container run server -- ip a show dev eth1 >&2")

    with subtest("Physical device in bridge in container can ping server"):
        bridged.wait_for_unit("default.target")
        bridged.succeed("nixos-container start bridged")
        bridged.wait_for_unit("container@bridged")
        bridged.succeed(
            "systemctl -M bridged list-dependencies network-addresses-br0.service >&2",
            "systemctl -M bridged status -n 30 -l network-addresses-br0.service",
            "nixos-container run bridged -- ping -w 10 -c 1 -n 10.10.0.1",
        )

    with subtest("Physical device in bond in container can ping server"):
        bonded.wait_for_unit("default.target")
        bonded.succeed("nixos-container start bonded")
        bonded.wait_for_unit("container@bonded")
        bonded.succeed(
            "systemctl -M bonded list-dependencies network-addresses-bond0 >&2",
            "systemctl -M bonded status -n 30 -l network-addresses-bond0 >&2",
            "nixos-container run bonded -- ping -w 10 -c 1 -n 10.10.0.1",
        )

    with subtest("Physical device in bond in bridge in container can ping server"):
        bridgedbond.wait_for_unit("default.target")
        bridgedbond.succeed("nixos-container start bridgedbond")
        bridgedbond.wait_for_unit("container@bridgedbond")
        bridgedbond.succeed(
            "systemctl -M bridgedbond list-dependencies network-addresses-br0.service >&2",
            "systemctl -M bridgedbond status -n 30 -l network-addresses-br0.service",
            "nixos-container run bridgedbond -- ping -w 10 -c 1 -n 10.10.0.1",
        )
  '';
}
