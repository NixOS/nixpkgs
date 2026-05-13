{ lib, pkgs, ... }:
{
  name = "afPacket";
  meta.maintainers = with lib.maintainers; [ felbinger ];

  imports = [ ./common.nix ];

  nodes = {
    ids = {
      services.suricata = {
        settings.af-packet = [ { interface = "eth1"; } ];
      };
    };
  };

  testScript = ''
    start_all()

    # check that configuration has been applied correctly with suricatasc
    with subtest("suricata configuration test"):
        ids.wait_for_unit("suricata.service")
        assert '1' in ids.succeed("suricatasc -c 'iface-list' | ${pkgs.jq}/bin/jq .message.count")

    # test detection of events based on a static ruleset (output of id command)
    with subtest("suricata rule test"):
        helper.wait_for_unit("nginx.service")
        ids.wait_for_unit("suricata.service")

        ids.succeed("curl http://192.168.1.1/id/")
        assert "id check returned root [**] [Classification: Potentially Bad Traffic]" in ids.succeed("tail -n 1 /var/log/suricata/fast.log"), "Suricata didn't detect the output of id comment"
  '';
}
