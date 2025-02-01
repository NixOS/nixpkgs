# This test sets up an IPsec VPN server that allows a client behind an IPv4 NAT
# router to access the IPv6 internet. We check that the client initially can't
# ping an IPv6 hosts and its connection to the server can be eavesdropped by
# the router, but once the IPsec tunnel is enstablished it can talk to an
# IPv6-only host and the connection is secure.
#
# Notes:
#   - the VPN is implemented using policy-based routing.
#   - the client is assigned an IPv6 address from the same /64 subnet
#     of the server, without DHCPv6 or SLAAC.
#   - the server acts as NDP proxy for the client, so that the latter
#     becomes reachable at its assigned IPv6 via the server.
#   - the client falls back to TCP if UDP is blocked

{ lib, pkgs, ... }:

let

  # Common network setup
  baseNetwork = {
    # shared hosts file
    networking.extraHosts = lib.mkVMOverride ''
      203.0.113.1 router
      203.0.113.2 server
      2001:db8::2 inner
      192.168.1.1 client
    '';
    # open a port for testing
    networking.firewall.allowedUDPPorts = [ 1234 ];
  };

  # Common IPsec configuration
  baseTunnel = {
    services.libreswan.enable = true;
    environment.etc."ipsec.d/tunnel.secrets" =
      { text = ''@server %any : PSK "j1JbIi9WY07rxwcNQ6nbyThKCf9DGxWOyokXIQcAQUnafsNTUJxfsxwk9WYK8fHj"'';
        mode = "600";
      };
  };

  # Helpers to add a static IP address on an interface
  setAddress4 = iface: addr: {
    networking.interfaces.${iface}.ipv4.addresses =
      lib.mkVMOverride [ { address = addr; prefixLength = 24; } ];
  };
  setAddress6 = iface: addr: {
    networking.interfaces.${iface}.ipv6.addresses =
      lib.mkVMOverride [ { address = addr; prefixLength = 64; } ];
  };

in

{
  name = "libreswan-nat";
  meta = with lib.maintainers; {
    maintainers = [ rnhmjoj ];
  };

  nodes.router = { pkgs, ... }: lib.mkMerge [
    baseNetwork
    (setAddress4 "eth1" "203.0.113.1")
    (setAddress4 "eth2" "192.168.1.1")
    {
      virtualisation.vlans = [ 1 2 ];
      environment.systemPackages = [ pkgs.tcpdump ];
      networking.nat = {
        enable = true;
        externalInterface = "eth1";
        internalInterfaces = [ "eth2" ];
      };
      networking.firewall.trustedInterfaces = [ "eth2" ];
    }
  ];

  nodes.inner = lib.mkMerge [
    baseNetwork
    (setAddress6 "eth1" "2001:db8::2")
    { virtualisation.vlans = [ 3 ]; }
  ];

  nodes.server = lib.mkMerge [
    baseNetwork
    baseTunnel
    (setAddress4 "eth1" "203.0.113.2")
    (setAddress6 "eth2" "2001:db8::1")
    {
      virtualisation.vlans = [ 1 3 ];
      networking.firewall.allowedUDPPorts = [ 500 4500 ];
      networking.firewall.allowedTCPPorts = [ 993 ];

      # see https://github.com/NixOS/nixpkgs/pull/310857
      networking.firewall.checkReversePath = false;

      boot.kernel.sysctl = {
        # enable forwarding packets
        "net.ipv6.conf.all.forwarding" = 1;
        "net.ipv4.conf.all.forwarding" = 1;
        # enable NDP proxy for VPN clients
        "net.ipv6.conf.all.proxy_ndp" = 1;
      };

      services.libreswan.configSetup = "listen-tcp=yes";
      services.libreswan.connections.tunnel = ''
        # server
        left=203.0.113.2
        leftid=@server
        leftsubnet=::/0
        leftupdown=${pkgs.writeScript "updown" ''
          # act as NDP proxy for VPN clients
          if test "$PLUTO_VERB" = up-client-v6; then
            ip neigh add proxy "$PLUTO_PEER_CLIENT_NET" dev eth2
          fi
          if test "$PLUTO_VERB" = down-client-v6; then
            ip neigh del proxy "$PLUTO_PEER_CLIENT_NET" dev eth2
          fi
        ''}

        # clients
        right=%any
        rightaddresspool=2001:db8:0:0:c::/97
        modecfgdns=2001:db8::1

        # clean up vanished clients
        dpddelay=30

        auto=add
        keyexchange=ikev2
        rekey=no
        narrowing=yes
        fragmentation=yes
        authby=secret

        leftikeport=993
        retransmit-timeout=10s
      '';
    }
  ];

  nodes.client = lib.mkMerge [
    baseNetwork
    baseTunnel
    (setAddress4 "eth1" "192.168.1.2")
    {
      virtualisation.vlans = [ 2 ];
      networking.defaultGateway = {
        address = "192.168.1.1";
        interface = "eth1";
      };
      services.libreswan.connections.tunnel = ''
        # client
        left=%defaultroute
        leftid=@client
        leftmodecfgclient=yes
        leftsubnet=::/0

        # server
        right=203.0.113.2
        rightid=@server
        rightsubnet=::/0

        auto=add
        narrowing=yes
        rekey=yes
        fragmentation=yes
        authby=secret

        # fallback when UDP is blocked
        enable-tcp=fallback
        tcp-remoteport=993
        retransmit-timeout=5s
      '';
    }
  ];

  testScript =
    ''
      def client_to_host(machine, msg: str):
          """
          Sends a message from client to server
          """
          machine.execute("nc -lu :: 1234 >/tmp/msg &")
          client.sleep(1)
          client.succeed(f"echo '{msg}' | nc -uw 0 {machine.name} 1234")
          client.sleep(1)
          machine.succeed(f"grep '{msg}' /tmp/msg")


      def eavesdrop():
          """
          Starts eavesdropping on the router
          """
          match = "udp port 1234"
          router.execute(f"tcpdump -i eth1 -c 1 -Avv {match} >/tmp/log &")


      start_all()

      with subtest("Network is up"):
          client.wait_until_succeeds("ping -c1 server")
          client.succeed("systemctl restart ipsec")
          server.succeed("systemctl restart ipsec")

      with subtest("Router can eavesdrop cleartext traffic"):
          eavesdrop()
          client_to_host(server, "I secretly love turnip")
          router.sleep(1)
          router.succeed("grep turnip /tmp/log")

      with subtest("Libreswan is ready"):
          client.wait_for_unit("ipsec")
          server.wait_for_unit("ipsec")
          client.succeed("ipsec checkconfig")
          server.succeed("ipsec checkconfig")

      with subtest("Client can't ping VPN host"):
          client.fail("ping -c1 inner")

      with subtest("Client can start the tunnel"):
          client.succeed("ipsec start tunnel")
          client.succeed("ip -6 addr show lo | grep -q 2001:db8:0:0:c")

      with subtest("Client can ping VPN host"):
          client.wait_until_succeeds("ping -c1 2001:db8::1")
          client.succeed("ping -c1 inner")

      with subtest("Eve no longer can eavesdrop"):
          eavesdrop()
          client_to_host(inner, "Just kidding, I actually like rhubarb")
          router.sleep(1)
          router.fail("grep rhubarb /tmp/log")

      with subtest("TCP fallback is available"):
          server.succeed("iptables -I nixos-fw -p udp -j DROP")
          client.succeed("ipsec restart")
          client.execute("ipsec start tunnel")
          client.wait_until_succeeds("ping -c1 inner")
    '';
}
