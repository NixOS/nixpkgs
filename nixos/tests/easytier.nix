{ lib, ... }:
{
  name = "easytier";
  meta.maintainers = with lib.maintainers; [ ltrump ];

  nodes =
    let
      genPeer =
        hostConfig: settings:
        lib.mkMerge [
          {
            services.easytier = {
              enable = true;
              instances.default = {
                settings = {
                  network_name = "easytier_test";
                  network_secret = "easytier_test_secret";
                }
                // settings;
              };
            };

            networking.useDHCP = false;
            networking.firewall.allowedTCPPorts = [
              11010
              11011
            ];
            networking.firewall.allowedUDPPorts = [
              11010
              11011
            ];
          }
          hostConfig
        ];
    in
    {
      relay =
        genPeer
          {
            virtualisation.vlans = [
              1
              2
            ];

            networking.interfaces.eth1.ipv4.addresses = [
              {
                address = "192.168.1.11";
                prefixLength = 24;
              }
            ];

            networking.interfaces.eth2.ipv4.addresses = [
              {
                address = "192.168.2.11";
                prefixLength = 24;
              }
            ];
          }
          {
            ipv4 = "10.144.144.1";
            listeners = [
              "tcp://0.0.0.0:11010"
              "wss://0.0.0.0:11011"
            ];
          };

      peer1 =
        genPeer
          {
            virtualisation.vlans = [ 1 ];
          }
          {
            ipv4 = "10.144.144.2";
            peers = [ "tcp://192.168.1.11:11010" ];
          };

      peer2 =
        genPeer
          {
            virtualisation.vlans = [ 2 ];
          }
          {
            ipv4 = "10.144.144.3";
            peers = [ "wss://192.168.2.11:11011" ];
          };
    };

  testScript = ''
    start_all()

    relay.wait_for_unit("easytier-default.service")
    peer1.wait_for_unit("easytier-default.service")
    peer2.wait_for_unit("easytier-default.service")

    # relay is accessible by the other hosts
    peer1.succeed("ping -c5 192.168.1.11")
    peer2.succeed("ping -c5 192.168.2.11")

    # The other hosts are in separate vlans
    peer1.fail("ping -c5 192.168.2.11")
    peer2.fail("ping -c5 192.168.1.11")

    # Each host can ping themselves through EasyTier
    relay.succeed("ping -c5 10.144.144.1")
    peer1.succeed("ping -c5 10.144.144.2")
    peer2.succeed("ping -c5 10.144.144.3")

    # Relay is accessible by the other hosts through EasyTier
    peer1.succeed("ping -c5 10.144.144.1")
    peer2.succeed("ping -c5 10.144.144.1")

    # Relay can access the other hosts through EasyTier
    relay.succeed("ping -c5 10.144.144.2")
    relay.succeed("ping -c5 10.144.144.3")

    # The other hosts in separate vlans can access each other through EasyTier
    peer1.succeed("ping -c5 10.144.144.3")
    peer2.succeed("ping -c5 10.144.144.2")
  '';
}
