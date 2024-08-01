import ../make-test-python.nix ({ lib, ... }: let
  peer1-ip = "538:f40f:1c51:9bd9:9569:d3f6:d0a1:b2df";
  peer2-ip = "5b6:6776:fee0:c1f3:db00:b6a8:d013:d38f";
in
  {
    name = "mycelium";
    meta.maintainers = with lib.maintainers; [ lassulus ];

    nodes = {

      peer1 = { config, pkgs, ... }: {
        virtualisation.vlans = [ 1 ];
        networking.interfaces.eth1.ipv4.addresses = [{
          address = "192.168.1.11";
          prefixLength = 24;
        }];

        services.mycelium = {
          enable = true;
          addHostedPublicNodes = false;
          openFirewall = true;
          keyFile = ./peer1.key;
          peers = [
            "quic://192.168.1.12:9651"
            "tcp://192.168.1.12:9651"
          ];
        };
      };

      peer2 = { config, pkgs, ... }: {
        virtualisation.vlans = [ 1 ];
        networking.interfaces.eth1.ipv4.addresses = [{
          address = "192.168.1.12";
          prefixLength = 24;
        }];

        services.mycelium = {
          enable = true;
          addHostedPublicNodes = false;
          openFirewall = true;
          keyFile = ./peer2.key;
        };
      };
    };

    testScript = ''
      start_all()

      peer1.wait_for_unit("network-online.target")
      peer2.wait_for_unit("network-online.target")
      peer1.wait_for_unit("mycelium.service")
      peer2.wait_for_unit("mycelium.service")

      peer1.succeed("mycelium peers list | grep 192.168.1.12")
      peer2.succeed("mycelium peers list | grep 192.168.1.11")

      peer1.succeed("ping -c5 ${peer2-ip}")
      peer2.succeed("ping -c5 ${peer1-ip}")
    '';
  })
