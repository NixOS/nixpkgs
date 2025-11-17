{ pkgs, lib, ... }:
{
  name = "systemd-resolved";
  meta.maintainers = [ lib.maintainers.elvishjerricco ];

  nodes.server =
    { lib, config, ... }:
    let
      exampleZone = pkgs.writeTextDir "example.com.zone" ''
        @ SOA ns.example.com. noc.example.com. 2019031301 86400 7200 3600000 172800
        @       A       ${(lib.head config.networking.interfaces.eth1.ipv4.addresses).address}
        @       AAAA    ${(lib.head config.networking.interfaces.eth1.ipv6.addresses).address}
      '';
    in
    {
      networking.firewall.enable = false;
      networking.useDHCP = false;

      networking.interfaces.eth1.ipv6.addresses = lib.mkForce [
        {
          address = "fd00::1";
          prefixLength = 64;
        }
      ];

      services.knot = {
        enable = true;
        settings = {
          server.listen = [
            "0.0.0.0@53"
            "::@53"
          ];
          template.default.storage = exampleZone;
          zone."example.com".file = "example.com.zone";
        };
      };
    };

  nodes.client =
    { nodes, ... }:
    let
      inherit (lib.head nodes.server.networking.interfaces.eth1.ipv4.addresses) address;
    in
    {
      networking.nameservers = [ address ];
      networking.interfaces.eth1.ipv6.addresses = lib.mkForce [
        {
          address = "fd00::2";
          prefixLength = 64;
        }
      ];
      services.resolved.enable = true;
      services.resolved.settings.Resolve.FallbackDNS = [ ];
      networking.useNetworkd = true;
      networking.useDHCP = false;
      systemd.network.networks."40-eth0".enable = false;

      testing.initrdBackdoor = true;
      boot.initrd = {
        systemd.enable = true;
        systemd.initrdBin = [ pkgs.iputils ];
        network.enable = true;
        services.resolved.enable = true;
      };
    };

  testScript =
    { nodes, ... }:
    let
      address4 = (lib.head nodes.server.networking.interfaces.eth1.ipv4.addresses).address;
      address6 = (lib.head nodes.server.networking.interfaces.eth1.ipv6.addresses).address;
    in
    ''
      start_all()
      server.wait_for_unit("multi-user.target")

      def test_client():
          query = client.succeed("resolvectl query example.com")
          assert "${address4}" in query
          assert "${address6}" in query
          client.succeed("ping -4 -c 1 example.com")
          client.succeed("ping -6 -c 1 example.com")

      client.wait_for_unit("initrd.target")
      test_client()
      client.switch_root()

      client.wait_for_unit("multi-user.target")
      test_client()
    '';
}
