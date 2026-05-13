{ lib, pkgs, ... }:
{
  name = "nfqueue";
  meta.maintainers = with lib.maintainers; [ felbinger ];

  imports = [ ./common.nix ];

  nodes = {
    ids = {
      # need to put an early queue statement for suricata, so use a custom firewall.
      networking.nftables.enable = true;
      networking.nftables.tables.nixos-fw.enable = false;
      networking.nftables.ruleset = ''
        table inet default {
          chain input {
            type filter hook input priority filter;
            queue flags fanout to 100 - 103
          }
          chain output {
            type filter hook output priority filter;
            queue flags fanout to 100 - 103
          }
        }
      '';
      services.suricata = {
        enable = true;
        netfilterQueues = [ 100 101 102 103 ];
        settings.nfq = {
          mode = "accept";
          fail-open = true;
        };
      };
    };
  };

  testScript = ''
    start_all()

    # check that configuration has been applied correctly with suricatasc
    with subtest("suricata configuration test"):
        ids.wait_for_unit("suricata.service")
        assert '4' in ids.wait_until_succeeds("suricatasc -c 'iface-list' | ${pkgs.jq}/bin/jq .message.count", timeout=5)

    # test detection of events based on a static ruleset (output of id command)
    with subtest("suricata rule test"):
        helper.wait_for_unit("nginx.service")
        ids.wait_for_unit("suricata.service")

        ids.succeed("curl http://192.168.1.1/id/")
        assert "id check returned root [**] [Classification: Potentially Bad Traffic]" in ids.succeed("tail -n 1 /var/log/suricata/fast.log"), "Suricata didn't detect the output of id comment"
  '';
}
