# Test for NixOS' container support.

let
  client_base = rec {
    networking.firewall.enable = false;

    containers.webserver = {
      autoStart = true;
      privateNetwork = true;
      hostBridge = "br0";
      config = {
        networking.firewall.enable = false;
        networking.firewall.allowPing = true;
        networking.interfaces.eth0.ip4 = [
          { address = "192.168.1.122"; prefixLength = 24; }
        ];
      };
    };
  };
in import ./make-test.nix ({ pkgs, lib, ...} :
{
  name = "containers-restart_networking";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ kampfschlaefer ];
  };

  nodes = {
    client = { lib, pkgs, ... }: client_base // {
      virtualisation.vlans = [ 1 ];

      networking.bridges.br0 = {
        interfaces = [];
        rstp = false;
      };
      networking.interfaces = {
        eth1.ip4 = lib.mkOverride 0 [ ];
        br0.ip4 = [{ address = "192.168.1.1"; prefixLength = 24; }];
      };

    };
    client_eth1 = { lib, pkgs, ... }: client_base // {
      networking.bridges.br0 = {
        interfaces = [ "eth1" ];
        rstp = false;
      };
      networking.interfaces = {
        eth1.ip4 = lib.mkOverride 0 [ ];
        br0.ip4 = [{ address = "192.168.1.2"; prefixLength = 24; }];
      };
    };
    client_eth1_rstp = { lib, pkgs, ... }: client_base // {
      networking.bridges.br0 = {
        interfaces = [ "eth1" ];
        rstp = true;
      };
      networking.interfaces = {
        eth1.ip4 = lib.mkOverride 0 [ ];
        br0.ip4 = [{ address = "192.168.1.2"; prefixLength = 24; }];
      };
    };
  };

  testScript = {nodes, ...}: let
    originalSystem = nodes.client.config.system.build.toplevel;
    eth1_bridged = nodes.client_eth1.config.system.build.toplevel;
    eth1_rstp = nodes.client_eth1_rstp.config.system.build.toplevel;
  in ''
    $client->start();

    $client->waitForUnit("default.target");

    subtest "initial state", sub {
      $client->succeed("ping 192.168.1.122 -c 1 -n >&2");
      $client->succeed("nixos-container run webserver -- ping -c 1 -n 192.168.1.1 >&2");

      $client->fail("ip l show eth1 |grep \"master br0\" >&2");
      $client->fail("grep eth1 /run/br0.interfaces >&2");
    };

    subtest "interfaces without stp", sub {
      $client->succeed("${eth1_bridged}/bin/switch-to-configuration test >&2");

      $client->succeed("ping 192.168.1.122 -c 1 -n >&2");
      $client->succeed("nixos-container run webserver -- ping -c 1 -n 192.168.1.2 >&2");

      $client->succeed("ip l show eth1 |grep \"master br0\" >&2");
      $client->succeed("grep eth1 /run/br0.interfaces >&2");
    };

    # activating rstp needs another service, therefor the bridge will restart and the container will loose its connectivity
    #subtest "interfaces with rstp", sub {
    #  $client->succeed("${eth1_rstp}/bin/switch-to-configuration test >&2");
    #  $client->execute("ip -4 a >&2");
    #  $client->execute("ip l >&2");
    #
    #  $client->succeed("ping 192.168.1.122 -c 1 -n >&2");
    #  $client->succeed("nixos-container run webserver -- ping -c 1 -n 192.168.1.2 >&2");
    #
    #  $client->succeed("ip l show eth1 |grep \"master br0\" >&2");
    #  $client->succeed("grep eth1 /run/br0.interfaces >&2");
    #};

    subtest "back to no interfaces and no stp", sub {
      $client->succeed("${originalSystem}/bin/switch-to-configuration test >&2");

      $client->succeed("ping 192.168.1.122 -c 1 -n >&2");
      $client->succeed("nixos-container run webserver -- ping -c 1 -n 192.168.1.1 >&2");

      $client->fail("ip l show eth1 |grep \"master br0\" >&2");
      $client->fail("grep eth1 /run/br0.interfaces >&2");
    };
  '';

})
