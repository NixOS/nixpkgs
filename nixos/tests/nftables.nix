# Test the nftables module.

import ./make-test-python.nix ( { pkgs, ... } : {
  name = "nftables";

  nodes =
    {
      walled = { ... }:
        {
          networking.firewall.enable = false;
          networking.nftables = {
            enable = true;
            ruleset = ''
              table inet nixos_fw {
                chain input {
                  type filter hook input priority filter; policy drop;
                  ct state vmap { invalid : drop, established : accept, related : accept }
                  tcp dport 80 accept
                }
              }
            '';
            stopRuleset = ''
              table inet nixos_fw
              delete table inet nixos_fw
            '';
          };
          services.httpd.enable = true;
          services.httpd.adminAddr = "foo@example.org";
        };

      attacker = { ... }:
        {
          networking.firewall.enable = false;
          networking.nftables.enable = false;
        };
    };

  testScript = { nodes, ... }:
  let
    customRuleset = pkgs.writeText "custom-ruleset" ''
      table inet custom {
        chain custom_input {
          type filter hook input priority filter; policy accept;
          tcp dport 80 drop
        }
      }
    '';
  in ''
    start_all()

    walled.wait_for_unit("nftables")
    walled.wait_for_unit("httpd")
    attacker.wait_for_unit("network.target")

    # Connections should succeed.
    attacker.succeed("curl -v http://walled/ >&2")

    # Insert a rule. Connections should fail.
    walled.succeed("nft insert rule inet nixos_fw input tcp dport 80 drop")
    attacker.fail("curl --fail --connect-timeout 2 http://walled/ >&2")

    # Reload nftables. Connections should succeed.
    walled.succeed("systemctl reload nftables.service")
    attacker.succeed("curl -v http://walled/ >&2")

    # Load a custom ruleset. Connections should fail.
    walled.succeed("nft -f ${customRuleset}")
    attacker.fail("curl --fail --connect-timeout 2 http://walled/ >&2")

    # Reload nftables. Custom ruleset should exist.
    walled.succeed("systemctl reload nftables.service")
    attacker.fail("curl --fail --connect-timeout 2 http://walled/ >&2")

    # Stop nftables. Custom ruleset should still exist.
    walled.stop_job("nftables")
    attacker.fail("curl --fail --connect-timeout 2 http://walled/ >&2")
  '';
})
