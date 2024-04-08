import ../make-test-python.nix ({ lib, ... }: let
  peer1-ip = "531:c350:28c1:dfde:ea6d:77d1:a60b:7209";
  peer2-ip = "49f:3942:3a55:d100:4c78:c558:c4f:695b";
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

      peer1.succeed("ping -c5 ${peer2-ip}")
      peer2.succeed("ping -c5 ${peer1-ip}")
    '';
  })
