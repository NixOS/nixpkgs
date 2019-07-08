# Test the firewall module.

import ./make-test.nix ( { pkgs, ... } : {
  name = "firewall";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ eelco ];
  };

  nodes =
    { walled =
        { ... }:
        { networking.firewall.enable = true;
          networking.firewall.logRefusedPackets = true;
          services.httpd.enable = true;
          services.httpd.adminAddr = "foo@example.org";
        };

      # Dummy configuration to check whether firewall.service will be honored
      # during system activation. This only needs to be different to the
      # original walled configuration so that there is a change in the service
      # file.
      walled2 =
        { ... }:
        { networking.firewall.enable = true;
          networking.firewall.rejectPackets = true;
        };

      attacker =
        { ... }:
        { services.httpd.enable = true;
          services.httpd.adminAddr = "foo@example.org";
          networking.firewall.enable = false;
        };
    };

  testScript = { nodes, ... }: let
    newSystem = nodes.walled2.config.system.build.toplevel;
  in ''
    $walled->start;
    $attacker->start;

    $walled->waitForUnit("firewall");
    $walled->waitForUnit("httpd");
    $attacker->waitForUnit("network.target");

    # Local connections should still work.
    $walled->succeed("curl -v http://localhost/ >&2");

    # Connections to the firewalled machine should fail, but ping should succeed.
    $attacker->fail("curl --fail --connect-timeout 2 http://walled/ >&2");
    $attacker->succeed("ping -c 1 walled >&2");

    # Outgoing connections/pings should still work.
    $walled->succeed("curl -v http://attacker/ >&2");
    $walled->succeed("ping -c 1 attacker >&2");

    # If we stop the firewall, then connections should succeed.
    $walled->stopJob("firewall");
    $attacker->succeed("curl -v http://walled/ >&2");

    # Check whether activation of a new configuration reloads the firewall.
    $walled->succeed("${newSystem}/bin/switch-to-configuration test 2>&1" .
                     " | grep -qF firewall.service");
  '';
})
