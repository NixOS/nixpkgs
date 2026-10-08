{ lib, ... }:
{
  name = "systemd-initrd-bridge";
  meta.maintainers = [ lib.maintainers.majiir ];

  # Tests bridge interface configuration in systemd-initrd.
  #
  # The 'a' and 'b' nodes are connected to a 'bridge' node through different
  # links. The 'bridge' node configures a bridge across them. It waits forever
  # in initrd (stage 1) with networking enabled. 'a' and 'b' ping 'bridge' to
  # test connectivity with the bridge interface. Then, 'a' pings 'b' to test
  # the bridge itself.

  nodes = {
    bridge =
      { config, lib, ... }:
      {
        boot.initrd.systemd.enable = true;
        boot.initrd.network.enable = true;
        boot.initrd.systemd.services.boot-blocker = {
          before = [ "initrd.target" ];
          wantedBy = [ "initrd.target" ];
          script = "sleep infinity";
          serviceConfig.Type = "oneshot";
        };

        networking.primaryIPAddress = lib.mkForce "192.168.1.${toString config.virtualisation.test.nodeNumber}";

        virtualisation.interfaces.eth1 = {
          vlan = 1;
          assignIP = false;
        };
        virtualisation.interfaces.eth2 = {
          vlan = 2;
          assignIP = false;
        };

        networking.bridges.br0.interfaces = [
          "eth1"
          "eth2"
        ];

        networking.interfaces = {
          br0.ipv4.addresses = [
            {
              address = config.networking.primaryIPAddress;
              prefixLength = 24;
            }
          ];
        };
      };

    a = {
      virtualisation.vlans = [ 1 ];
    };

    b =
      { config, ... }:
      {
        virtualisation.vlans = [ 2 ];
        networking.primaryIPAddress = lib.mkForce "192.168.1.${toString config.virtualisation.test.nodeNumber}";
        networking.interfaces.eth1.ipv4.addresses = lib.mkForce [
          {
            address = config.networking.primaryIPAddress;
            prefixLength = 24;
          }
        ];
      };
  };

  testScript = ''
    start_all()
    a.wait_for_unit("network.target")
    b.wait_for_unit("network.target")

    a.succeed("ping -n -w 10 -c 1 bridge >&2")
    b.succeed("ping -n -w 10 -c 1 bridge >&2")

    a.succeed("ping -n -w 10 -c 1 b >&2")
  '';
}
