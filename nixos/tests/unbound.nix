/*
 Test that our unbound module indeed works as most users would expect.
 There are a few settings that we must consider when modifying the test. The
 usual use-cases for unbound are
   * running a recursive DNS resolver on the local machine
   * running a recursive DNS resolver on the local machine, forwarding to a local DNS server via UDP/53 & TCP/53
   * running a recursive DNS resolver on the local machine, forwarding to a local DNS server via TCP/853 (DoT)
   * running a recursive DNS resolver on a machine in the network awaiting input from clients over TCP/53 & UDP/53
   * running a recursive DNS resolver on a machine in the network awaiting input from clients over TCP/853 (DoT)

 In the below test setup we are trying to implement all of those use cases.

 Another aspect that we cover is access to the local control UNIX socket. It
 can optionally be enabled and users can optionally be in a group to gain
 access. Users that are not in the group (except for root) should not have
 access to that socket. Also, when there is no socket configured, users
 shouldn't be able to access the control socket at all. Not even root.
*/
import ./make-test-python.nix ({ pkgs, lib, ... }:
  let
    # common client configuration that we can just use for the multitude of
    # clients we are constructing
    common = { lib, pkgs, ... }: {
      config = {
        environment.systemPackages = [ pkgs.knot-dns ];

        # disable the root anchor update as we do not have internet access during
        # the test execution
        services.unbound.enableRootTrustAnchor = false;

        # we want to test the full-variant of the package to also get DoH support
        services.unbound.package = pkgs.unbound-full;
      };
    };

    cert = pkgs.runCommand "selfSignedCerts" { buildInputs = [ pkgs.openssl ]; } ''
      openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -nodes -subj '/CN=dns.example.local'
      mkdir -p $out
      cp key.pem cert.pem $out
    '';
  in
  {
    name = "unbound";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ andir ];
    };

    nodes = {

      # The server that actually serves our zones, this tests unbounds authoriative mode
      authoritative = { lib, pkgs, config, ... }: {
        imports = [ common ];
        networking.interfaces.eth1.ipv4.addresses = lib.mkForce [
          { address = "192.168.0.1"; prefixLength = 24; }
        ];
        networking.interfaces.eth1.ipv6.addresses = lib.mkForce [
          { address = "fd21::1"; prefixLength = 64; }
        ];
        networking.firewall.allowedTCPPorts = [ 53 ];
        networking.firewall.allowedUDPPorts = [ 53 ];

        services.unbound = {
          enable = true;
          settings = {
            server = {
              interface = [ "192.168.0.1" "fd21::1" "::1" "127.0.0.1" ];
              access-control = [ "192.168.0.0/24 allow" "fd21::/64 allow" "::1 allow" "127.0.0.0/8 allow" ];
              local-data = [
                ''"example.local. IN A 1.2.3.4"''
                ''"example.local. IN AAAA abcd::eeff"''
              ];
            };
          };
        };
      };

      # The resolver that knows that forwards (only) to the authoritative server
      # and listens on UDP/53, TCP/53 & TCP/853.
      resolver = { lib, nodes, ... }: {
        imports = [ common ];
        networking.interfaces.eth1.ipv4.addresses = lib.mkForce [
          { address = "192.168.0.2"; prefixLength = 24; }
        ];
        networking.interfaces.eth1.ipv6.addresses = lib.mkForce [
          { address = "fd21::2"; prefixLength = 64; }
        ];
        networking.firewall.allowedTCPPorts = [
          53 # regular DNS
          853 # DNS over TLS
          443 # DNS over HTTPS
        ];
        networking.firewall.allowedUDPPorts = [ 53 ];

        services.unbound = {
          enable = true;
          settings = {
            server = {
              interface = [ "::1" "127.0.0.1" "192.168.0.2" "fd21::2"
                            "192.168.0.2@853" "fd21::2@853" "::1@853" "127.0.0.1@853"
                            "192.168.0.2@443" "fd21::2@443" "::1@443" "127.0.0.1@443" ];
              access-control = [ "192.168.0.0/24 allow" "fd21::/64 allow" "::1 allow" "127.0.0.0/8 allow" ];
              tls-service-pem = "${cert}/cert.pem";
              tls-service-key = "${cert}/key.pem";
            };
            forward-zone = [
              {
                name = ".";
                forward-addr = [
                  (lib.head nodes.authoritative.networking.interfaces.eth1.ipv6.addresses).address
                  (lib.head nodes.authoritative.networking.interfaces.eth1.ipv4.addresses).address
                ];
              }
            ];
          };
        };
      };

      # machine that runs a local unbound that will be reconfigured during test execution
      local_resolver = { lib, nodes, config, ... }: {
        imports = [ common ];
        networking.interfaces.eth1.ipv4.addresses = lib.mkForce [
          { address = "192.168.0.3"; prefixLength = 24; }
        ];
        networking.interfaces.eth1.ipv6.addresses = lib.mkForce [
          { address = "fd21::3"; prefixLength = 64; }
        ];
        networking.firewall.allowedTCPPorts = [
          53 # regular DNS
        ];
        networking.firewall.allowedUDPPorts = [ 53 ];

        services.unbound = {
          enable = true;
          settings = {
            server = {
              interface = [ "::1" "127.0.0.1" ];
              access-control = [ "::1 allow" "127.0.0.0/8 allow" ];
            };
            include = "/etc/unbound/extra*.conf";
          };
          localControlSocketPath = "/run/unbound/unbound.ctl";
        };

        users.users = {
          # user that is permitted to access the unix socket
          someuser = {
            isSystemUser = true;
            group = "someuser";
            extraGroups = [
              config.users.users.unbound.group
            ];
          };

          # user that is not permitted to access the unix socket
          unauthorizeduser = {
            isSystemUser = true;
            group = "unauthorizeduser";
          };

        };
        users.groups = {
          someuser = {};
          unauthorizeduser = {};
        };

        # Used for testing configuration reloading
        environment.etc = {
          "unbound-extra1.conf".text = ''
            forward-zone:
            name: "example.local."
            forward-addr: ${(lib.head nodes.resolver.networking.interfaces.eth1.ipv6.addresses).address}
            forward-addr: ${(lib.head nodes.resolver.networking.interfaces.eth1.ipv4.addresses).address}
          '';
          "unbound-extra2.conf".text = ''
            auth-zone:
              name: something.local.
              zonefile: ${pkgs.writeText "zone" ''
                something.local. IN A 3.4.5.6
              ''}
          '';
        };
      };


      # plain node that only has network access and doesn't run any part of the
      # resolver software locally
      client = { lib, nodes, ... }: {
        imports = [ common ];
        networking.nameservers = [
          (lib.head nodes.resolver.networking.interfaces.eth1.ipv6.addresses).address
          (lib.head nodes.resolver.networking.interfaces.eth1.ipv4.addresses).address
        ];
        networking.interfaces.eth1.ipv4.addresses = [
          { address = "192.168.0.10"; prefixLength = 24; }
        ];
        networking.interfaces.eth1.ipv6.addresses = [
          { address = "fd21::10"; prefixLength = 64; }
        ];
      };
    };

    testScript = { nodes, ... }: ''
      import typing

      zone = "example.local."
      records = [("AAAA", "abcd::eeff"), ("A", "1.2.3.4")]


      def query(
          machine,
          host: str,
          query_type: str,
          query: str,
          expected: typing.Optional[str] = None,
          args: typing.Optional[typing.List[str]] = None,
      ):
          """
          Execute a single query and compare the result with expectation
          """
          text_args = ""
          if args:
              text_args = " ".join(args)

          out = machine.succeed(
              f"kdig {text_args} {query} {query_type} @{host} +short"
          ).strip()
          machine.log(f"{host} replied with {out}")
          if expected:
              assert expected == out, f"Expected `{expected}` but got `{out}`"


      def test(machine, remotes, /, doh=False, zone=zone, records=records, args=[]):
          """
          Run queries for the given remotes on the given machine.
          """
          for query_type, expected in records:
              for remote in remotes:
                  query(machine, remote, query_type, zone, expected, args)
                  query(machine, remote, query_type, zone, expected, ["+tcp"] + args)
                  if doh:
                      query(
                          machine,
                          remote,
                          query_type,
                          zone,
                          expected,
                          ["+tcp", "+tls"] + args,
                      )
                      query(
                          machine,
                          remote,
                          query_type,
                          zone,
                          expected,
                          ["+https"] + args,
                      )


      client.start()
      authoritative.wait_for_unit("unbound.service")

      # verify that we can resolve locally
      with subtest("test the authoritative servers local responses"):
          test(authoritative, ["::1", "127.0.0.1"])

      resolver.wait_for_unit("unbound.service")

      with subtest("root is unable to use unbounc-control when the socket is not configured"):
          resolver.succeed("which unbound-control")  # the binary must exist
          resolver.fail("unbound-control list_forwards")  # the invocation must fail

      # verify that the resolver is able to resolve on all the local protocols
      with subtest("test that the resolver resolves on all protocols and transports"):
          test(resolver, ["::1", "127.0.0.1"], doh=True)

      resolver.wait_for_unit("multi-user.target")

      with subtest("client should be able to query the resolver"):
          test(client, ["${(lib.head nodes.resolver.networking.interfaces.eth1.ipv6.addresses).address}", "${(lib.head nodes.resolver.networking.interfaces.eth1.ipv4.addresses).address}"], doh=True)

      # discard the client we do not need anymore
      client.shutdown()

      local_resolver.wait_for_unit("multi-user.target")

      # link a new config file to /etc/unbound/extra.conf
      local_resolver.succeed("ln -s /etc/unbound-extra1.conf /etc/unbound/extra1.conf")

      # reload the server & ensure the forwarding works
      with subtest("test that the local resolver resolves on all protocols and transports"):
          local_resolver.succeed("systemctl reload unbound")
          print(local_resolver.succeed("journalctl -u unbound -n 1000"))
          test(local_resolver, ["::1", "127.0.0.1"], args=["+timeout=60"])

      with subtest("test that we can use the unbound control socket"):
          out = local_resolver.succeed(
              "sudo -u someuser -- unbound-control list_forwards"
          ).strip()

          # Thank you black! Can't really break this line into a readable version.
          expected = "example.local. IN forward ${(lib.head nodes.resolver.networking.interfaces.eth1.ipv6.addresses).address} ${(lib.head nodes.resolver.networking.interfaces.eth1.ipv4.addresses).address}"
          assert out == expected, f"Expected `{expected}` but got `{out}` instead."
          local_resolver.fail("sudo -u unauthorizeduser -- unbound-control list_forwards")


      # link a new config file to /etc/unbound/extra.conf
      local_resolver.succeed("ln -sf /etc/unbound-extra2.conf /etc/unbound/extra2.conf")

      # reload the server & ensure the new local zone works
      with subtest("test that we can query the new local zone"):
          local_resolver.succeed("unbound-control reload")
          r = [("A", "3.4.5.6")]
          test(local_resolver, ["::1", "127.0.0.1"], zone="something.local.", records=r)
    '';
  })
