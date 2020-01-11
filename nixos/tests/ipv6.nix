# Test of IPv6 functionality in NixOS, including whether router
# solicication/advertisement using radvd works.

import ./make-test-python.nix ({ pkgs, lib, ...} : {
  name = "ipv6";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ eelco ];
  };

  nodes =
    # Remove the interface configuration provided by makeTest so that the
    # interfaces are all configured implicitly
    { client = { ... }: { networking.interfaces = lib.mkForce {}; };

      server =
        { ... }:
        { services.httpd.enable = true;
          services.httpd.adminAddr = "foo@example.org";
          networking.firewall.allowedTCPPorts = [ 80 ];
        };

      router =
        { ... }:
        { services.radvd.enable = true;
          services.radvd.config =
            ''
              interface eth1 {
                AdvSendAdvert on;
                # ULA prefix (RFC 4193).
                prefix fd60:cc69:b537:1::/64 { };
              };
            '';
        };
    };

  testScript =
    ''
      import re

      # Start the router first so that it respond to router solicitations.
      router.wait_for_unit("radvd")

      start_all()

      client.wait_for_unit("network.target")
      server.wait_for_unit("network.target")
      server.wait_for_unit("httpd.service")

      # Wait until the given interface has a non-tentative address of
      # the desired scope (i.e. has completed Duplicate Address
      # Detection).
      def wait_for_address(machine, iface, scope, temporary=False):
          temporary_flag = "temporary" if temporary else "-temporary"
          cmd = f"ip -o -6 addr show dev {iface} scope {scope} -tentative {temporary_flag}"

          machine.wait_until_succeeds(f"[ `{cmd} | wc -l` -eq 1 ]")
          output = machine.succeed(cmd)
          ip = re.search(r"inet6 ([0-9a-f:]{2,})/", output).group(1)

          if temporary:
              scope = scope + " temporary"
          machine.log(f"{scope} address on {iface} is {ip}")
          return ip


      with subtest("Loopback address can be pinged"):
          client.succeed("ping -c 1 ::1 >&2")
          client.fail("ping -c 1 ::2 >&2")

      with subtest("Local link addresses can be obtained and pinged"):
          client_ip = wait_for_address(client, "eth1", "link")
          server_ip = wait_for_address(server, "eth1", "link")
          client.succeed(f"ping -c 1 {client_ip}%eth1 >&2")
          client.succeed(f"ping -c 1 {server_ip}%eth1 >&2")

      with subtest("Global addresses can be obtained, pinged, and reached via http"):
          client_ip = wait_for_address(client, "eth1", "global")
          server_ip = wait_for_address(server, "eth1", "global")
          client.succeed(f"ping -c 1 {client_ip} >&2")
          client.succeed(f"ping -c 1 {server_ip} >&2")
          client.succeed(f"curl --fail -g http://[{server_ip}]")
          client.fail(f"curl --fail -g http://[{client_ip}]")

      with subtest("Privacy extensions: Global temporary address can be obtained and pinged"):
          ip = wait_for_address(client, "eth1", "global", temporary=True)
          # Default route should have "src <temporary address>" in it
          client.succeed(f"ip r g ::2 | grep {ip}")

      # TODO: test reachability of a machine on another network.
    '';
})
