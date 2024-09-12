# Test the firewall module.

import ./make-test-python.nix ( { pkgs, nftables, ... } : {
  name = "firewall" + pkgs.lib.optionalString nftables "-nftables";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ ];
  };

  nodes =
    { walled =
        { ... }:
        { networking.firewall.enable = true;
          networking.firewall.logRefusedPackets = true;
          networking.nftables.enable = nftables;
          services.httpd.enable = true;
          services.httpd.adminAddr = "foo@example.org";

          specialisation.different-config.configuration = {
            networking.firewall.rejectPackets = true;
          };
        };

      attacker =
        { ... }:
        { services.httpd.enable = true;
          services.httpd.adminAddr = "foo@example.org";
          networking.firewall.enable = false;
        };
    };

  testScript = { nodes, ... }: let
    unit = if nftables then "nftables" else "firewall";
  in ''
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

    # If we stop the firewall, then connections should succeed.
    walled.stop_job("${unit}")
    attacker.succeed("curl -v http://walled/ >&2")

    # Check whether activation of a new configuration reloads the firewall.
    walled.succeed(
        "/run/booted-system/specialisation/different-config/bin/switch-to-configuration test 2>&1 | grep -qF ${unit}.service"
    )
  '';
})
