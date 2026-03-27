{ pkgs, ... }:
{
  name = "containers";
  meta.maintainers = with pkgs.lib.maintainers; [ jfly ];
  # https://github.com/NixOS/infra/issues/987
  meta.hydraPlatforms = [ ];

  nodes = {
    n1 = {
      virtualisation.vlans = [ 1 ];
    };
    n2 = {
      virtualisation.vlans = [
        2
      ];
    };
  };

  containers = {
    c1 = {
      virtualisation.vlans = [ 1 ];
    };
    c2 = {
      virtualisation.vlans = [ 2 ];
    };
    c12 = {
      virtualisation.vlans = [
        1
        2
      ];
    };
  };

  testScript = /* python */ ''
    c1.start()
    c2.start()
    c12.start()

    c1.succeed("echo hello > /hello.txt")
    c1.copy_from_machine("/hello.txt")

    c1.systemctl("start network-online.target")
    c2.systemctl("start network-online.target")
    c12.systemctl("start network-online.target")
    c1.wait_for_unit("network-online.target")
    c2.wait_for_unit("network-online.target")
    c12.wait_for_unit("network-online.target")

    # Confirm containers in vlan 1 can talk to each other.
    c1.succeed("ping -c 1 c12")
    c12.succeed("ping -c 1 c1")

    # Confirm containers in vlan 2 can talk to each other.
    c2.succeed("ping -c 1 c12")
    c12.succeed("ping -c 1 c2")

    # Confirm containers in separate vlans cannot talk to each other.
    c1.fail("ping -c 1 -W 1 c2")

    n1.start()
    n2.start()
    n1.systemctl("start network-online.target")
    n2.systemctl("start network-online.target")
    n1.wait_for_unit("network-online.target")
    n2.wait_for_unit("network-online.target")

    # Confirm containers and nodes in the same vlan can talk to each other.
    c1.succeed("ping -c 1 n1")
    n1.succeed("ping -c 1 c1")
    c2.succeed("ping -c 1 n2")
    n2.succeed("ping -c 1 c2")

    # Confirm containers and nodes in different vlans cannot talk to each other.
    c1.fail("ping -c 1 -W 1 n2")
    n1.fail("ping -c 1 -W 1 c2")
    c2.fail("ping -c 1 -W 1 n1")
    n2.fail("ping -c 1 -W 1 c1")
  '';
}
