let
  hostIp4 = "192.168.0.1";
  containerIp4 = "192.168.0.100/24";
  hostIp6 = "fc00::1";
  containerIp6 = "fc00::2/7";
in

{ lib, ... }:
{
  name = "containers-gateway";
  meta = {
    maintainers = with lib.maintainers; [
      rnhmjoj
    ];
  };

  nodes.machine = {
    networking.bridges = {
      br0.interfaces = [ ];
    };
    networking.interfaces = {
      br0.ipv4.addresses = [
        {
          address = hostIp4;
          prefixLength = 24;
        }
      ];
      br0.ipv6.addresses = [
        {
          address = hostIp6;
          prefixLength = 7;
        }
      ];
    };

    containers.test = {
      autoStart = true;
      privateNetwork = true;
      hostBridge = "br0";
      localAddress = containerIp4;
      localAddress6 = containerIp6;
      config.networking = {
        defaultGateway.address = hostIp4;
        defaultGateway6.address = hostIp6;
      };
    };
  };

  testScript = ''
    def container_succeed(command: str):
        machine.succeed(f"nixos-container run test -- {command}")

    machine.wait_for_unit("default.target")
    assert "test" in machine.succeed("nixos-container list")

    with subtest("Container has started"):
        assert "up" in machine.succeed("nixos-container status test")

    with subtest("Container can ping the host"):
        container_succeed("ping -n -c 1 ${hostIp4}")
        container_succeed("ping -n -c 1 ${hostIp6}")

    with subtest("Container default gateways are set"):
        container_succeed("ip -4 route show default | grep 'via ${hostIp4}'")
        container_succeed("ip -6 route show default | grep 'via ${hostIp6}'")
  '';
}
