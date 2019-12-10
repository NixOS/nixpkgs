# Test for NixOS' container support.

let
  client_base = {
    networking.firewall.enable = false;

    containers.webserver = {
      autoStart = true;
      privateNetwork = true;
      hostBridge = "br0";
      config = {
        networking.firewall.enable = false;
        networking.interfaces.eth0.ipv4.addresses = [
          { address = "192.168.1.122"; prefixLength = 24; }
        ];
      };
    };
  };
in import ./make-test-python.nix ({ pkgs, ...} :
{
  name = "containers-restart_networking";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ kampfschlaefer ];
  };

  nodes = {
    client = { lib, ... }: client_base // {
      virtualisation.vlans = [ 1 ];

      networking.bridges.br0 = {
        interfaces = [];
        rstp = false;
      };
      networking.interfaces = {
        eth1.ipv4.addresses = lib.mkOverride 0 [ ];
        br0.ipv4.addresses = [ { address = "192.168.1.1"; prefixLength = 24; } ];
      };

    };
    client_eth1 = { lib, ... }: client_base // {
      networking.bridges.br0 = {
        interfaces = [ "eth1" ];
        rstp = false;
      };
      networking.interfaces = {
        eth1.ipv4.addresses = lib.mkOverride 0 [ ];
        br0.ipv4.addresses = [ { address = "192.168.1.2"; prefixLength = 24; } ];
      };
    };
    client_eth1_rstp = { lib, ... }: client_base // {
      networking.bridges.br0 = {
        interfaces = [ "eth1" ];
        rstp = true;
      };
      networking.interfaces = {
        eth1.ipv4.addresses = lib.mkOverride 0 [ ];
        br0.ipv4.addresses =  [ { address = "192.168.1.2"; prefixLength = 24; } ];
      };
    };
  };

  testScript = {nodes, ...}: let
    originalSystem = nodes.client.config.system.build.toplevel;
    eth1_bridged = nodes.client_eth1.config.system.build.toplevel;
    eth1_rstp = nodes.client_eth1_rstp.config.system.build.toplevel;
  in ''
    client.start()

    client.wait_for_unit("default.target")

    with subtest("Initial configuration connectivity check"):
        client.succeed("ping 192.168.1.122 -c 1 -n >&2")
        client.succeed("nixos-container run webserver -- ping -c 1 -n 192.168.1.1 >&2")

        client.fail("ip l show eth1 |grep 'master br0' >&2")
        client.fail("grep eth1 /run/br0.interfaces >&2")

    with subtest("Bridged configuration without STP preserves connectivity"):
        client.succeed(
            "${eth1_bridged}/bin/switch-to-configuration test >&2"
        )

        client.succeed(
            "ping 192.168.1.122 -c 1 -n >&2",
            "nixos-container run webserver -- ping -c 1 -n 192.168.1.2 >&2",
            "ip l show eth1 |grep 'master br0' >&2",
            "grep eth1 /run/br0.interfaces >&2",
        )

    #  activating rstp needs another service, therefore the bridge will restart and the container will lose its connectivity
    # with subtest("Bridged configuration with STP"):
    #     client.succeed("${eth1_rstp}/bin/switch-to-configuration test >&2")
    #     client.execute("ip -4 a >&2")
    #     client.execute("ip l >&2")
    #
    #     client.succeed(
    #         "ping 192.168.1.122 -c 1 -n >&2",
    #         "nixos-container run webserver -- ping -c 1 -n 192.168.1.2 >&2",
    #         "ip l show eth1 |grep 'master br0' >&2",
    #         "grep eth1 /run/br0.interfaces >&2",
    #     )

    with subtest("Reverting to initial configuration preserves connectivity"):
        client.succeed(
            "${originalSystem}/bin/switch-to-configuration test >&2"
        )

        client.succeed("ping 192.168.1.122 -c 1 -n >&2")
        client.succeed("nixos-container run webserver -- ping -c 1 -n 192.168.1.1 >&2")

        client.fail("ip l show eth1 |grep 'master br0' >&2")
        client.fail("grep eth1 /run/br0.interfaces >&2")
  '';

})
