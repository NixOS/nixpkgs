# This test makes sure that lxd stops implicitly depending on iptables when
# user enabled nftables.
#
# It has been extracted from `lxd.nix` for clarity, and because switching from
# iptables to nftables requires a full reboot, which is a bit hard inside NixOS
# tests.

import ../make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "lxd-nftables";

    nodes.machine =
      { lib, ... }:
      {
        virtualisation = {
          lxd.enable = true;
        };

        networking = {
          firewall.enable = false;
          nftables.enable = true;
          nftables.tables."filter".family = "inet";
          nftables.tables."filter".content = ''
            chain incoming {
              type filter hook input priority 0;
              policy accept;
            }

            chain forward {
              type filter hook forward priority 0;
              policy accept;
            }

            chain output {
              type filter hook output priority 0;
              policy accept;
            }
          '';
        };
      };

    testScript = ''
      machine.wait_for_unit("network.target")

      with subtest("When nftables are enabled, lxd doesn't depend on iptables anymore"):
          machine.succeed("lsmod | grep nf_tables")
          machine.fail("lsmod | grep ip_tables")
    '';
  }
)
