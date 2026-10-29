{
  system ? builtins.currentSystem,
  pkgs ? import ../.. { inherit system; },
  lib ? pkgs.lib,
}:

let
  inherit (import ../lib/testing-python.nix { inherit system pkgs; }) makeTest;
  nodeIP = n: n.networking.primaryIPAddress;
  dnsZone =
    nodes:
    pkgs.writeText "agnos.test.zone" ''
      $TTL    604800
      @       IN      SOA     ns1.agnos.test. root.agnos.test. (
                        3     ; Serial
                   604800     ; Refresh
                    86400     ; Retry
                  2419200     ; Expire
                   604800 )   ; Negative Cache TTL
      ;
      ; name servers - NS records
           IN      NS      ns1.agnos.test.

      ; name servers - A records
      ns1.agnos.test.          IN      A      ${nodeIP nodes.dnsserver}

      agnos-ns.agnos.test.        IN      A      ${nodeIP nodes.server}
      _acme-challenge.a.agnos.test.   IN     NS      agnos-ns.agnos.test.
      _acme-challenge.b.agnos.test.   IN     NS      agnos-ns.agnos.test.
      _acme-challenge.c.agnos.test.   IN     NS      agnos-ns.agnos.test.
      _acme-challenge.d.agnos.test.   IN     NS      agnos-ns.agnos.test.
    '';

  mkTest =
    {
      name,
      extraServerConfig ? { },
      checkFirewallClosed ? true,
    }:
    makeTest {
      inherit name;
      meta = {
        maintainers = with lib.maintainers; [ justinas ];
      };

      nodes = {
        # The fake ACME server which will respond to client requests
        acme =
          { nodes, pkgs, ... }:
          {
            imports = [ ./common/acme/server ];
            environment.systemPackages = [ pkgs.netcat ];
            networking.nameservers = lib.mkForce [ (nodeIP nodes.dnsserver) ];
          };

        # A fake DNS server which points _acme-challenge subdomains to "server"
        dnsserver =
          { nodes, ... }:
          {
            networking.firewall.allowedTCPPorts = [ 53 ];
            networking.firewall.allowedUDPPorts = [ 53 ];
            services.bind = {
              cacheNetworks = [ "192.168.1.0/24" ];
              enable = true;
              extraOptions = ''
                dnssec-validation no;
              '';
              zones."agnos.test" = {
                file = dnsZone nodes;
                master = true;
              };
            };
          };

        # The server using agnos to request certificates
        server =
          { nodes, ... }:
          {
            imports = [ extraServerConfig ];

            networking.extraHosts = ''
              ${nodeIP nodes.acme} acme.test
            '';
            security.agnos = {
              enable = true;
              generateKeys.enable = true;
              persistent = false;
              server = "https://acme.test/dir";
              serverCa = ./common/acme/server/ca.cert.pem;
              temporarilyOpenFirewall = true;

              settings.accounts = [
                {
                  email = "webmaster@agnos.test";
                  # account with an existing private key
                  private_key_path = "${./common/acme/server/acme.test.key.pem}";

                  certificates = [
                    {
                      domains = [ "a.agnos.test" ];
                      # Absolute paths
                      fullchain_output_file = "/tmp/a.agnos.test.crt";
                      key_output_file = "/tmp/a.agnos.test.key";
                    }

                    {
                      domains = [
                        "b.agnos.test"
                        "*.b.agnos.test"
                      ];
                      # Relative paths
                      fullchain_output_file = "b.agnos.test.crt";
                      key_output_file = "b.agnos.test.key";
                    }
                  ];
                }

                {
                  email = "webmaster2@agnos.test";
                  # account with a missing private key, should get generated
                  private_key_path = "webmaster2.key";

                  certificates = [
                    {
                      domains = [ "c.agnos.test" ];
                      # Absolute paths
                      fullchain_output_file = "/tmp/c.agnos.test.crt";
                      key_output_file = "/tmp/c.agnos.test.key";
                    }

                    {
                      domains = [
                        "d.agnos.test"
                        "*.d.agnos.test"
                      ];
                      # Relative paths
                      fullchain_output_file = "d.agnos.test.crt";
                      key_output_file = "d.agnos.test.key";
                    }
                  ];
                }
              ];
            };
          };
      };

      testScript = ''
        def check_firewall_closed(caller):
            """
            Check that TCP port 53 is closed again.

            Since we do not set `networking.firewall.rejectPackets`,
            "timed out" indicates a closed port,
            while "connection refused" (after agnos has shut down) indicates an open port.
            """

            out = caller.fail("nc -v -z -w 1 server 53 2>&1")
            assert "Connection timed out" in out

        start_all()
        acme.wait_for_unit('pebble.service')
        server.wait_for_unit('default.target')

        # Test that agnos.timer is scheduled
        server.succeed("systemctl status agnos.timer")
        server.succeed('systemctl start agnos.service')

        expected_perms = "640 agnos agnos"
        outputs = [
            "/tmp/a.agnos.test.crt",
            "/tmp/a.agnos.test.key",
            "/var/lib/agnos/b.agnos.test.crt",
            "/var/lib/agnos/b.agnos.test.key",
            "/var/lib/agnos/webmaster2.key",
            "/tmp/c.agnos.test.crt",
            "/tmp/c.agnos.test.key",
            "/var/lib/agnos/d.agnos.test.crt",
            "/var/lib/agnos/d.agnos.test.key",
        ]
        for o in outputs:
            out = server.succeed(f"stat -c '%a %U %G' {o}").strip()
            assert out == expected_perms, \
              f"Expected mode/owner/group to be '{expected_perms}', but it was '{out}'"

        ${lib.optionalString checkFirewallClosed "check_firewall_closed(acme)"}
      '';
    };
in
{
  iptables = mkTest {
    name = "iptables";
  };

  nftables = mkTest {
    name = "nftables";
    extraServerConfig = {
      networking.nftables.enable = true;
    };
  };

  no-firewall = mkTest {
    name = "no-firewall";
    extraServerConfig = {
      networking.firewall.enable = lib.mkForce false;
      security.agnos.temporarilyOpenFirewall = lib.mkForce false;
    };
    checkFirewallClosed = false;
  };
}
