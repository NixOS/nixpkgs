{ lib, ... }:
{
  _class = "nixosTest";

  name = "easytier-modular";

  nodes =
    let
      genPeer =
        hostConfig:
        { pkgs, ... }:
        lib.mkMerge [
          {
            networking.useDHCP = false;
            networking.firewall.allowedTCPPorts = [
              11010
              11011
            ];
            networking.firewall.allowedUDPPorts = [
              11010
              11011
            ];

            system.services."easytier-default" = {
              imports = [ pkgs.easytier.services.default ];
              easytier.settings = {
                instance_name = "default";
                dev_name = "et_def";
                rpc_portal = "0.0.0.0:11000";
                network_identity = {
                  network_name = "easytier_test";
                  network_secret = "easytier_test_secret";
                };
              };
            };
          }
          hostConfig
        ];
    in
    {
      relay =
        { pkgs, ... }@args:
        lib.mkMerge [
          (genPeer {
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

            system.services."easytier-default".easytier.settings = {
              ipv4 = "10.144.144.1";
              listeners = [
                "tcp://0.0.0.0:11010"
                "wss://0.0.0.0:11011"
              ];
            };
          } args)

          {
            networking.firewall.allowedTCPPorts = [ 11020 ];
            networking.firewall.allowedUDPPorts = [ 11020 ];

            system.services."easytier-second" = {
              imports = [ pkgs.easytier.services.default ];
              easytier = {
                peers = [
                  "tcp://192.168.1.11:11010"
                  "tcp://192.168.2.11:11010"
                ];
                settings = {
                  instance_name = "second";
                  ipv4 = "10.144.144.4";

                  rpc_portal = "0.0.0.0:11001";

                  network_identity = {
                    network_name = "easytier_test";
                    network_secret = "easytier_test_secret";
                  };

                  listeners = [ "tcp://0.0.0.0:11020" ];
                  flags = {
                    bind_device = false;
                    no_tun = true;
                  };
                };
              };
            };
          }
        ];

      peer1 = genPeer {
        virtualisation.vlans = [ 1 ];
        system.services."easytier-default".easytier = {
          settings.ipv4 = "10.144.144.2";
          peers = [ "tcp://192.168.1.11:11010" ];
        };
      };

      peer2 = genPeer {
        virtualisation.vlans = [ 2 ];
        system.services."easytier-default".easytier = {
          settings.ipv4 = "10.144.144.3";
          peers = [ "wss://192.168.2.11:11011" ];
        };
      };
    };

  testScript = ''
    start_all()

    with subtest("Waiting for all services..."):
        relay.wait_for_unit("easytier-default.service")
        relay.wait_for_unit("easytier-second.service")
        peer1.wait_for_unit("easytier-default.service")
        peer2.wait_for_unit("easytier-default.service")

    with subtest("relay is accessible by the other hosts"):
        peer1.succeed("ping -c5 192.168.1.11")
        peer2.succeed("ping -c5 192.168.2.11")

    with subtest("The other hosts are in separate vlans"):
        peer1.fail("ping -c5 192.168.2.11")
        peer2.fail("ping -c5 192.168.1.11")

    with subtest("Each host can ping themselves through EasyTier"):
        relay.succeed("ping -c5 10.144.144.1")
        peer1.succeed("ping -c5 10.144.144.2")
        peer2.succeed("ping -c5 10.144.144.3")

    with subtest("Relay is accessible by the other hosts through EasyTier"):
        peer1.succeed("ping -c5 10.144.144.1")
        peer2.succeed("ping -c5 10.144.144.1")

    with subtest("Relay can access the other hosts through EasyTier"):
        relay.succeed("ping -c5 10.144.144.2")
        relay.succeed("ping -c5 10.144.144.3")

    with subtest("The other hosts in separate vlans can access each other through EasyTier"):
        peer1.succeed("ping -c5 10.144.144.3")
        peer2.succeed("ping -c5 10.144.144.2")

    with subtest("Relay Second is accessible through EasyTier"):
        peer1.succeed("ping -c5 10.144.144.4")
        peer2.succeed("ping -c5 10.144.144.4")
  '';

  meta.maintainers = with lib.maintainers; [ moraxyc ];
}
