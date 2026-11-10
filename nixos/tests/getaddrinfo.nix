{ lib, ... }:
let
  ip4 = "192.0.2.1";
  ip6 = "2001:db8::1";

  precedence = {
    "::1/128" = 50;
    "::/0" = 40;
    "2002::/16" = 30;
    "::/96" = 20;
    "::ffff:0:0/96" = 100;
  };
in
{
  name = "getaddrinfo";
  meta.maintainers = with lib.maintainers; [ moraxyc ];

  nodes.server = _: {
    networking.firewall.enable = false;
    networking.useDHCP = false;

    services.dnsmasq = {
      enable = true;
      settings = {
        address = [
          "/nixos.test/${ip4}"
          "/nixos.test/${ip6}"
        ];
      };
    };
  };

  nodes.client =
    { pkgs, nodes, ... }:
    {
      networking.nameservers = [
        (lib.head nodes.server.networking.interfaces.eth1.ipv4.addresses).address
      ];
      networking.getaddrinfo = {
        reload = true;
        inherit precedence;
      };
      networking.useDHCP = false;
      environment.systemPackages = [
        (pkgs.writers.writePython3Bin "request-addr" { } ''
          import socket

          results = socket.getaddrinfo("nixos.test", None)
          print(results[0][4][0])
        '')
      ];
    };

  testScript =
    { ... }:
    ''
      server.wait_for_unit("dnsmasq.service")
      client.wait_for_unit("network.target")

      assert "${ip4}" in client.succeed("request-addr")

      client.succeed("""
        sed 's/100/10/' /etc/gai.conf > /etc/gai.conf.new && \
        mv /etc/gai.conf.new /etc/gai.conf
      """)
      assert "${ip6}" in client.succeed("request-addr")
    '';
}
