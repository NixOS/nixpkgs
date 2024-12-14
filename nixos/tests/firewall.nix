# Test the firewall module.

import ./make-test-python.nix (
  { pkgs, nftables, ... }:
  {
    name = "firewall" + pkgs.lib.optionalString nftables "-nftables";
    meta = with pkgs.lib.maintainers; {
      maintainers = [
        rvfg
        garyguo
      ];
    };

    nodes = {
      walled =
        { ... }:
        {
          networking.firewall = {
            enable = true;
            logRefusedPackets = true;
            # Syntax smoke test, not actually verified otherwise
            allowedTCPPorts = [
              25
              993
              8005
            ];
            allowedTCPPortRanges = [
              {
                from = 980;
                to = 1000;
              }
              {
                from = 990;
                to = 1010;
              }
              {
                from = 8000;
                to = 8010;
              }
            ];
            interfaces.eth0 = {
              allowedTCPPorts = [ 10003 ];
              allowedTCPPortRanges = [
                {
                  from = 10000;
                  to = 10005;
                }
              ];
            };
            interfaces.eth3 = {
              allowedUDPPorts = [ 10003 ];
              allowedUDPPortRanges = [
                {
                  from = 10000;
                  to = 10005;
                }
              ];
            };
          };
          networking.nftables.enable = nftables;
          services.httpd.enable = true;
          services.httpd.adminAddr = "foo@example.org";

          specialisation.different-config.configuration = {
            networking.firewall.rejectPackets = true;
          };
        };

      attacker =
        { ... }:
        {
          services.httpd.enable = true;
          services.httpd.adminAddr = "foo@example.org";
          networking.firewall.enable = false;
        };
    };

    testScript =
      { nodes, ... }:
      let
        unit = if nftables then "nftables" else "firewall";
      in
      ''
        start_all()

        walled.wait_for_unit("${unit}")
        walled.wait_for_unit("httpd")
        attacker.wait_for_unit("network.target")

        # Local connections should still work.
        walled.succeed("curl -v http://localhost/ >&2")

        # Connections to the firewalled machine should fail, but ping should succeed.
        attacker.fail("curl --fail --connect-timeout 2 http://walled/ >&2")
        attacker.succeed("ping -c 1 walled >&2")

        # Outgoing connections/pings should still work.
        walled.succeed("curl -v http://attacker/ >&2")
        walled.succeed("ping -c 1 attacker >&2")

        # Open tcp port 80 at runtime
        walled.succeed("nixos-firewall-tool open tcp 80")
        attacker.succeed("curl -v http://walled/ >&2")

        # Reset the firewall
        walled.succeed("nixos-firewall-tool reset")
        attacker.fail("curl --fail --connect-timeout 2 http://walled/ >&2")

        # If we stop the firewall, then connections should succeed.
        walled.stop_job("${unit}")
        attacker.succeed("curl -v http://walled/ >&2")

        # Check whether activation of a new configuration reloads the firewall.
        walled.succeed(
            "/run/booted-system/specialisation/different-config/bin/switch-to-configuration test 2>&1 | grep -qF ${unit}.service"
        )
      '';
  }
)
