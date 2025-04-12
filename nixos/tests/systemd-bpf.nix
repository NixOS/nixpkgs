import ./make-test-python.nix (
  { lib, ... }:
  {
    name = "systemd-bpf";
    meta = with lib.maintainers; {
      maintainers = [ veehaitch ];
    };
    nodes = {
      node1 = {
        virtualisation.vlans = [ 1 ];
        networking = {
          useNetworkd = true;
          useDHCP = false;
          firewall.enable = false;
          interfaces.eth1.ipv4.addresses = [
            {
              address = "192.168.1.1";
              prefixLength = 24;
            }
          ];
        };
      };

      node2 = {
        virtualisation.vlans = [ 1 ];
        networking = {
          useNetworkd = true;
          useDHCP = false;
          firewall.enable = false;
          interfaces.eth1.ipv4.addresses = [
            {
              address = "192.168.1.2";
              prefixLength = 24;
            }
          ];
        };
      };
    };

    testScript = ''
      start_all()
      node1.wait_for_unit("systemd-networkd-wait-online.service")
      node2.wait_for_unit("systemd-networkd-wait-online.service")

      with subtest("test RestrictNetworkInterfaces= works"):
        node1.succeed("ping -c 5 192.168.1.2")
        node1.succeed("systemd-run -t -p RestrictNetworkInterfaces='eth1' ping -c 5 192.168.1.2")
        node1.fail("systemd-run -t -p RestrictNetworkInterfaces='lo' ping -c 5 192.168.1.2")
    '';
  }
)
