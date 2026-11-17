{ lib, ... }:
{
  name = "i2pd";
  meta.maintainers = with lib.maintainers; [ h7x4 ];

  nodes = {
    server =
      { config, pkgs, ... }:
      {
        virtualisation.vlans = [ 1 ];
        networking = {
          useDHCP = false;
          interfaces.eth1.useDHCP = false;
          firewall.allowedTCPPorts = [ 12345 ];
          firewall.allowedUDPPorts = [ 12345 ];
        };

        systemd.services."test-web-server" = {
          wantedBy = [ "multi-user.target" ];
          before = [ "i2pd.service" ];
          serviceConfig = {
            ExecStart = ''
              ${lib.getExe' pkgs.python3 "python3"} \
                -m http.server 8080 \
                --bind 127.0.0.1 \
                --directory ${pkgs.writeTextDir "index.html" "hello world"}
            '';
            DynamicUser = true;
          };
        };

        services.i2pd = {
          enable = true;
          settings = {
            # Needed to retrieve b32 address
            loglevel = "info";
            # Avoid real I2P network ID (2), just in case
            # there are any hidden assumptions tied to it.
            netid = 77;
            host = config.networking.primaryIPAddress;
            port = 12345;
            # Allow use of local addresses
            reservedrange = false;
            # No reseed infra available, and we seed netDb manually anyway
            reseed.urls = "";
            reseed.yggurls = "";

            # "router" is the only other node reachable, so every tunnel
            # is a single hop through it.
            shareddest.inbound.length = 1;
            shareddest.outbound.length = 1;
            exploratory.inbound.length = 1;
            exploratory.outbound.length = 1;
          };

          serverTunnels.testserver = {
            host = "127.0.0.1";
            port = 8080;
            keys = "testserver-keys.dat";
            inbound.length = 1;
            outbound.length = 1;
          };
        };
      };

    router =
      { config, ... }:
      {
        virtualisation.vlans = [ 1 ];
        networking = {
          useDHCP = false;
          interfaces.eth1.useDHCP = false;
          firewall.allowedTCPPorts = [ 12345 ];
          firewall.allowedUDPPorts = [ 12345 ];
        };

        services.i2pd = {
          enable = true;
          settings = {
            loglevel = "info";
            netid = 77;
            host = config.networking.primaryIPAddress;
            port = 12345;
            reservedrange = false;
            reseed.urls = "";
            reseed.yggurls = "";
            floodfill = true;

            # "router" has no peer to hop through for its own pools.
            shareddest.inbound.length = 0;
            shareddest.outbound.length = 0;
            exploratory.inbound.length = 0;
            exploratory.outbound.length = 0;
          };
        };
      };

    client =
      { config, ... }:
      {
        virtualisation.vlans = [ 1 ];
        networking = {
          useDHCP = false;
          interfaces.eth1.useDHCP = false;
        };

        # i2pd asserts this exists before it starts, the test script
        # overwrites it with the server's actual address once known.
        systemd.tmpfiles.rules = [
          "f /run/i2pd-secrets/server-destination 0400 root root - unknown.b32.i2p"
        ];

        services.i2pd = {
          enable = true;
          settings = {
            loglevel = "info";
            netid = 77;
            host = config.networking.primaryIPAddress;
            reservedrange = false;
            reseed.urls = "";
            reseed.yggurls = "";

            httpproxy.inbound.length = 1;
            httpproxy.outbound.length = 1;
            shareddest.inbound.length = 1;
            shareddest.outbound.length = 1;
            exploratory.inbound.length = 1;
            exploratory.outbound.length = 1;
          };

          clientTunnels.toServer = {
            port = 10800;
            destination._secret = "/run/i2pd-secrets/server-destination";
            inbound.length = 1;
            outbound.length = 1;
          };
        };
      };

    yggdrasilCheck = {
      services = {
        yggdrasil = {
          enable = true;
          settings.MulticastInterfaces = [ ];
        };

        i2pd = {
          enable = true;
          settings = {
            loglevel = "info";
            netid = 77;
            reseed.urls = "";
            reseed.yggurls = "";
            httpproxy.enabled = false;
            socksproxy.enabled = false;

            ipv4 = false;
            ipv6 = false;
            ntcp2.enabled = false;
            ssu2.enabled = false;
            meshnets.yggdrasil = true;

            shareddest.inbound.length = 0;
            shareddest.outbound.length = 0;
            exploratory.inbound.length = 0;
            exploratory.outbound.length = 0;
          };
        };
      };
    };
  };

  testScript =
    # python
    ''
      import re

      start_all()
      server.wait_for_unit("i2pd.service")
      client.wait_for_unit("i2pd.service")
      router.wait_for_unit("i2pd.service")
      yggdrasilCheck.wait_for_unit("yggdrasil.service")
      yggdrasilCheck.wait_for_unit("i2pd.service")
      server.wait_for_file("/var/lib/i2pd/router.info")
      client.wait_for_file("/var/lib/i2pd/router.info")
      router.wait_for_file("/var/lib/i2pd/router.info")
      yggdrasilCheck.wait_for_file("/var/lib/i2pd/router.info")

      with subtest("Exchange router info"):
          server.wait_until_succeeds(
              "journalctl -u i2pd -o cat --grep 'Local address \\S+ created'"
          )
          server_log_line = server.succeed(
              "journalctl -u i2pd -o cat --grep 'Local address \\S+ created' --reverse -n 1"
          )
          server_b32_match = re.search(r"Local address (\S+) created", server_log_line)
          assert server_b32_match is not None
          server_b32 = server_b32_match.group(1)
          client.succeed(
              "mkdir -p /run/i2pd-secrets",
              f"printf '%s' '{server_b32}.b32.i2p' > /run/i2pd-secrets/server-destination",
          )

          # We don't have any reseed infra available, so we manually seed each
          # of server/client with "router"'s identity, and vice versa.
          router.copy_from_machine("/var/lib/i2pd/router.info", "router-identity")
          server.copy_from_machine("/var/lib/i2pd/router.info", "server-identity")
          client.copy_from_machine("/var/lib/i2pd/router.info", "client-identity")

          router_identity = str(router.out_dir / "router-identity" / "router.info")
          server.copy_from_host(router_identity, "/var/lib/i2pd/netDb/r0/router.dat")
          client.copy_from_host(router_identity, "/var/lib/i2pd/netDb/r0/router.dat")

          router.copy_from_host(
              str(server.out_dir / "server-identity" / "router.info"),
              "/var/lib/i2pd/netDb/r0/server.dat",
          )
          router.copy_from_host(
              str(client.out_dir / "client-identity" / "router.info"),
              "/var/lib/i2pd/netDb/r0/client.dat",
          )

          client.systemctl("restart i2pd.service")
          server.systemctl("restart i2pd.service")
          router.systemctl("restart i2pd.service")
          client.wait_for_unit("i2pd.service")
          server.wait_for_unit("i2pd.service")
          router.wait_for_unit("i2pd.service")
          client.wait_for_open_port(4444)

      server.wait_for_unit("test-web-server.service")

      with subtest("Request content using the HTTP proxy"):
          # This is intended to keep on failing until the client eventually receives
          # a LeaseSet from the server.
          client.wait_until_succeeds(
              f"curl --fail -x 127.0.0.1:4444 http://{server_b32}.b32.i2p/ | grep -q 'hello world'",
          )

      with subtest("Request content using a port-forwarding tunnel"):
          client.wait_until_succeeds(
              "curl --fail http://127.0.0.1:10800/ | grep -q 'hello world'",
          )
    '';
}
