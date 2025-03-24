import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "systemd-resolved";
    meta.maintainers = [ lib.maintainers.elvishjerricco ];

    nodes.server =
      {
        lib,
        config,
        nodes,
        ...
      }:
      let
        exampleZone = pkgs.writeTextDir "example.com.zone" ''
          @ SOA ns.example.com. noc.example.com. 2019031301 86400 7200 3600000 172800
          @       A       ${(lib.head config.networking.interfaces.eth1.ipv4.addresses).address}
          @       AAAA    ${(lib.head config.networking.interfaces.eth1.ipv6.addresses).address}
          client  A       ${(lib.head nodes.client.networking.interfaces.eth1.ipv4.addresses).address}
          client  AAAA    ${(lib.head nodes.client.networking.interfaces.eth1.ipv6.addresses).address}
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
      { lib, nodes, ... }:
      let
        inherit (lib.head nodes.server.networking.interfaces.eth1.ipv4.addresses) address;
      in
      {
        networking.hostName = "client";
        networking.domain = "example.com";

        # The NixOS testing framework automatically generates host entries for
        # the `hostName` and FQDN settings pointing to the nodes' primary
        # IP. Instead, we want to test how a real, unmodified NixOS system will
        # behave. Override the `extraHosts` setting accordingly:
        networking.extraHosts = lib.mkForce "";

        networking.nameservers = [ address ];
        networking.interfaces.eth1.ipv6.addresses = lib.mkForce [
          {
            address = "fd00::2";
            prefixLength = 64;
          }
        ];
        services.resolved.enable = true;
        services.resolved.fallbackDns = [ ];
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
        serverAddress4 = (lib.head nodes.server.networking.interfaces.eth1.ipv4.addresses).address;
        serverAddress6 = (lib.head nodes.server.networking.interfaces.eth1.ipv6.addresses).address;
        clientAddress4 = (lib.head nodes.client.networking.interfaces.eth1.ipv4.addresses).address;
        clientAddress6 = (lib.head nodes.client.networking.interfaces.eth1.ipv6.addresses).address;
      in
      ''
        start_all()
        server.wait_for_unit("multi-user.target")

        def test_client():
            query = client.succeed("resolvectl query example.com")
            assert "${serverAddress4}" in query
            assert "${serverAddress6}" in query
            client.succeed("ping -4 -c 1 example.com")
            client.succeed("ping -6 -c 1 example.com")

            # Ensure that the client can resolve its own FQDN and retreive both
            # A and AAAA records:
            query = client.succeed("resolvectl query client.example.com")
            assert "${clientAddress4}" in query
            assert "${clientAddress6}" in query
            client.succeed("ping -4 -c 1 client.example.com")
            client.succeed("ping -6 -c 1 client.example.com")

        client.wait_for_unit("initrd.target")
        test_client()
        client.switch_root()

        client.wait_for_unit("multi-user.target")
        test_client()
      '';
  }
)
