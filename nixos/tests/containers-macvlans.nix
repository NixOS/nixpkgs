let
  # containers IP on VLAN 1
  containerIp1 = "192.168.1.253";
  containerIp2 = "192.168.1.254";
in

import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "containers-macvlans";
  meta = {
    maintainers = with lib.maintainers; [ montag451 ];
  };

  nodes = {

    machine1 =
      { lib, ... }:
      {
        virtualisation.vlans = [ 1 ];

        # To be able to ping containers from the host, it is necessary
        # to create a macvlan on the host on the VLAN 1 network.
        networking.macvlans.mv-eth1-host = {
          interface = "eth1";
          mode = "bridge";
        };
        networking.interfaces.eth1.ipv4.addresses = lib.mkForce [];
        networking.interfaces.mv-eth1-host = {
          ipv4.addresses = [ { address = "192.168.1.1"; prefixLength = 24; } ];
        };

        containers.test1 = {
          autoStart = true;
          macvlans = [ "eth1" ];

          config = {
            networking.interfaces.mv-eth1 = {
              ipv4.addresses = [ { address = containerIp1; prefixLength = 24; } ];
            };
          };
        };

        containers.test2 = {
          autoStart = true;
          macvlans = [ "eth1" ];

          config = {
            networking.interfaces.mv-eth1 = {
              ipv4.addresses = [ { address = containerIp2; prefixLength = 24; } ];
            };
          };
        };
      };

    machine2 =
      { ... }:
      {
        virtualisation.vlans = [ 1 ];
      };

  };

  testScript = ''
    start_all()
    machine1.wait_for_unit("default.target")
    machine2.wait_for_unit("default.target")

    with subtest(
        "Ping between containers to check that macvlans are created in bridge mode"
    ):
        machine1.succeed("nixos-container run test1 -- ping -n -c 1 ${containerIp2}")

    with subtest("Ping containers from the host (machine1)"):
        machine1.succeed("ping -n -c 1 ${containerIp1}")
        machine1.succeed("ping -n -c 1 ${containerIp2}")

    with subtest(
        "Ping containers from the second machine to check that containers are reachable from the outside"
    ):
        machine2.succeed("ping -n -c 1 ${containerIp1}")
        machine2.succeed("ping -n -c 1 ${containerIp2}")
  '';
})
