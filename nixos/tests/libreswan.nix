# This test sets up a host-to-host IPsec VPN between Alice and Bob, each on its
# own network and with Eve as the only route between each other. We check that
# Eve can eavesdrop the plaintext traffic between Alice and Bob, but once they
# enable the secure tunnel Eve's spying becomes ineffective.

{ lib, pkgs, ... }:

let

  # IPsec tunnel between Alice and Bob
  tunnelConfig = {
    services.libreswan.enable = true;
    services.libreswan.connections.tunnel =
      ''
        leftid=@alice
        left=fd::a
        rightid=@bob
        right=fd::b
        authby=secret
        auto=add
      '';
    environment.etc."ipsec.d/tunnel.secrets" =
      { text = ''@alice @bob : PSK "j1JbIi9WY07rxwcNQ6nbyThKCf9DGxWOyokXIQcAQUnafsNTUJxfsxwk9WYK8fHj"'';
        mode = "600";
      };
  };

  # Common network setup
  baseNetwork = {
    # shared hosts file
    extraHosts = lib.mkVMOverride ''
      fd::a alice
      fd::b bob
      fd::e eve
    '';
    # remove all automatic addresses
    useDHCP = false;
    interfaces.eth1.ipv4.addresses = lib.mkVMOverride [];
    interfaces.eth2.ipv4.addresses = lib.mkVMOverride [];
    interfaces.eth1.ipv6.addresses = lib.mkVMOverride [];
    interfaces.eth2.ipv6.addresses = lib.mkVMOverride [];
    # open a port for testing
    firewall.allowedUDPPorts = [ 1234 ];
  };

  # Adds an address and route from a to b via Eve
  addRoute = a: b: {
    interfaces.eth1.ipv6.addresses =
      [ { address = a; prefixLength = 64; } ];
    interfaces.eth1.ipv6.routes =
      [ { address = b; prefixLength = 128; via = "fd::e"; } ];
  };

in

{
  name = "libreswan";
  meta = with lib.maintainers; {
    maintainers = [ rnhmjoj ];
  };

  # Our protagonist
  nodes.alice = { ... }: {
    virtualisation.vlans = [ 1 ];
    networking = baseNetwork // addRoute "fd::a" "fd::b";
  } // tunnelConfig;

  # Her best friend
  nodes.bob = { ... }: {
    virtualisation.vlans = [ 2 ];
    networking = baseNetwork // addRoute "fd::b" "fd::a";
  } // tunnelConfig;

  # The malicious network operator
  nodes.eve = { ... }: {
    virtualisation.vlans = [ 1 2 ];
    networking = lib.mkMerge
      [ baseNetwork
        { interfaces.br0.ipv6.addresses =
            [ { address = "fd::e"; prefixLength = 64; } ];
          bridges.br0.interfaces = [ "eth1" "eth2" ];
        }
      ];
    environment.systemPackages = [ pkgs.tcpdump ];
    boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = true;
  };

  testScript =
    ''
      def alice_to_bob(msg: str):
          """
          Sends a message as Alice to Bob
          """
          bob.execute("nc -lu ::0 1234 >/tmp/msg &")
          alice.sleep(1)
          alice.succeed(f"echo '{msg}' | nc -uw 0 bob 1234")
          bob.succeed(f"grep '{msg}' /tmp/msg")


      def eavesdrop():
          """
          Starts eavesdropping on Alice and Bob
          """
          match = "src host alice and dst host bob"
          eve.execute(f"tcpdump -i br0 -c 1 -Avv {match} >/tmp/log &")


      start_all()

      with subtest("Network is up"):
          alice.wait_until_succeeds("ping -c1 bob")
          alice.succeed("systemctl restart ipsec")
          bob.succeed("systemctl restart ipsec")

      with subtest("Eve can eavesdrop cleartext traffic"):
          eavesdrop()
          alice_to_bob("I secretly love turnip")
          eve.sleep(1)
          eve.succeed("grep turnip /tmp/log")

      with subtest("Libreswan is ready"):
          alice.wait_for_unit("ipsec")
          bob.wait_for_unit("ipsec")
          alice.succeed("ipsec checkconfig")

      with subtest("Alice and Bob can start the tunnel"):
          alice.execute("ipsec start tunnel >&2 &")
          bob.succeed("ipsec start tunnel")
          # apparently this is needed to "wake" the tunnel
          bob.execute("ping -c1 alice")

      with subtest("Eve no longer can eavesdrop"):
          eavesdrop()
          alice_to_bob("Just kidding, I actually like rhubarb")
          eve.sleep(1)
          eve.fail("grep rhubarb /tmp/log")
    '';
}
