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

  nodes.delegate_server =
    { lib, config, ... }:
    let
      delegateZone = pkgs.writeTextDir "delegated.example.org.zone" ''
        @ SOA ns.delegated.example.org. noc.delegated.example.org. 2019031301 86400 7200 3600000 172800
        test A ${(lib.head config.networking.interfaces.eth1.ipv4.addresses).address}
        test AAAA ${(lib.head config.networking.interfaces.eth1.ipv6.addresses).address}
      '';
    in
    {
      networking.firewall.enable = false;
      networking.useDHCP = false;

      networking.interfaces.eth1.ipv6.addresses = lib.mkForce [
        {
          address = "fd00::3";
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
          template.default.storage = delegateZone;
          zone."delegated.example.org".file = "delegated.example.org.zone";
        };
      };
    };

  nodes.client =
    { nodes, ... }:
    let
      serverAddress = (lib.head nodes.server.networking.interfaces.eth1.ipv4.addresses).address;
      delegateAddress =
        (lib.head nodes.delegate_server.networking.interfaces.eth1.ipv4.addresses).address;
    in
    {
      networking.nameservers = [ serverAddress ];
      networking.interfaces.eth1.ipv6.addresses = lib.mkForce [
        {
          address = "fd00::2";
          prefixLength = 64;
        }
      ];
      services.resolved.enable = true;
      services.resolved.settings.Resolve.FallbackDNS = [ ];
      services.resolved.dnsDelegates.example-org = {
        Delegate = {
          DNS = delegateAddress;
          Domains = [ "delegated.example.org" ];
        };
      };
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
      delegateAddress4 =
        (lib.head nodes.delegate_server.networking.interfaces.eth1.ipv4.addresses).address;
      delegateAddress6 =
        (lib.head nodes.delegate_server.networking.interfaces.eth1.ipv6.addresses).address;
    in
    #python
    ''
      start_all()
      server.wait_for_unit("multi-user.target")
      delegate_server.wait_for_unit("multi-user.target")

      def test_resolve(domain, expected_addrs):
          query = client.succeed(f"resolvectl query {domain}")
          for addr in expected_addrs:
              assert addr in query, f"Expected {addr} in: {query}"
          client.succeed(f"ping -4 -c 1 {domain}")
          client.succeed(f"ping -6 -c 1 {domain}")

      with subtest("resolve in initrd"):
          client.wait_for_unit("initrd.target")
          test_resolve("example.com", ["${address4}", "${address6}"])

      client.switch_root()

      with subtest("resolve after switch-root"):
          client.wait_for_unit("multi-user.target")
          test_resolve("example.com", ["${address4}", "${address6}"])

      with subtest("dns-delegate resolves delegated subdomain"):
          test_resolve("test.delegated.example.org", ["${delegateAddress4}", "${delegateAddress6}"])
    '';
}
