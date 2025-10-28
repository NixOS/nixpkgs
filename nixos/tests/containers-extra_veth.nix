{ pkgs, lib, ... }:
{
  name = "containers-extra_veth";
  meta = {
    maintainers = with lib.maintainers; [ kampfschlaefer ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      imports = [ ../modules/installer/cd-dvd/channel.nix ];
      virtualisation.writableStore = true;
      virtualisation.vlans = [ ];

      networking.useDHCP = false;
      networking.bridges = {
        br0 = {
          interfaces = [ ];
        };
        br1 = {
          interfaces = [ ];
        };
      };
      networking.interfaces = {
        br0 = {
          ipv4.addresses = [
            {
              address = "192.168.0.1";
              prefixLength = 24;
            }
          ];
          ipv6.addresses = [
            {
              address = "fc00::1";
              prefixLength = 7;
            }
          ];
        };
        br1 = {
          ipv4.addresses = [
            {
              address = "192.168.1.1";
              prefixLength = 24;
            }
          ];
        };
      };

      containers.webserver = {
        autoStart = true;
        privateNetwork = true;
        hostBridge = "br0";
        localAddress = "192.168.0.100/24";
        localAddress6 = "fc00::2/7";
        extraVeths = {
          veth1 = {
            hostBridge = "br1";
            localAddress = "192.168.1.100/24";
          };
          veth2 = {
            hostAddress = "192.168.2.1";
            localAddress = "192.168.2.100";
          };
        };
        config = {
          networking.firewall.allowedTCPPorts = [ 80 ];
        };
      };

      virtualisation.additionalPaths = [ pkgs.stdenv ];
    };

  testScript = ''
    machine.wait_for_unit("default.target")
    assert "webserver" in machine.succeed("nixos-container list")

    with subtest("Status of the webserver container is up"):
        assert "up" in machine.succeed("nixos-container status webserver")

    with subtest("Ensure that the veths are inside the container"):
        assert "state UP" in machine.succeed(
            "nixos-container run webserver -- ip link show veth1"
        )
        assert "state UP" in machine.succeed(
            "nixos-container run webserver -- ip link show veth2"
        )

    with subtest("Ensure the presence of the extra veths"):
        assert "state UP" in machine.succeed("ip link show veth1")
        assert "state UP" in machine.succeed("ip link show veth2")

    with subtest("Ensure the veth1 is part of br1 on the host"):
        assert "master br1" in machine.succeed("ip link show veth1")

    with subtest("Ping on main veth"):
        machine.succeed("ping -n -c 1 192.168.0.100")
        machine.succeed("ping -n -c 1 fc00::2")

    with subtest("Ping on the first extra veth"):
        machine.succeed("ping -n -c 1 192.168.1.100 >&2")

    with subtest("Ping on the second extra veth"):
        machine.succeed("ping -n -c 1 192.168.2.100 >&2")

    with subtest("Container can be stopped"):
        machine.succeed("nixos-container stop webserver")
        machine.fail("ping -n -c 1 192.168.1.100 >&2")
        machine.fail("ping -n -c 1 192.168.2.100 >&2")

    with subtest("Destroying a declarative container should fail"):
        machine.fail("nixos-container destroy webserver")
  '';
}
