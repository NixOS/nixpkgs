{ lib, pkgs, ... }:
{
  name = "suricata";
  meta.maintainers = with lib.maintainers; [ felbinger ];

  nodes = {
    ids = {
      networking.interfaces.eth1 = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "192.168.1.2";
            prefixLength = 24;
          }
        ];
      };

      # disable suricata-update because this requires an Internet connection
      systemd.services.suricata-update.enable = false;

      # install suricata package to make suricatasc program available
      environment.systemPackages = with pkgs; [ suricata ];

      services.suricata = {
        enable = true;
        settings = {
          vars.address-groups.HOME_NET = "192.168.1.0/24";
          unix-command.enabled = true;
          outputs = [ { fast.enabled = true; } ];
          af-packet = [ { interface = "eth1"; } ];
          classification-file = "${pkgs.suricata}/etc/suricata/classification.config";
        };
      };

      # create suricata.rules with the rule to detect the output of the id command
      systemd.tmpfiles.rules = [
        ''f /var/lib/suricata/rules/suricata.rules 644 suricata suricata 0 alert ip any any -> any any (msg:"GPL ATTACK_RESPONSE id check returned root"; content:"uid=0|28|root|29|"; classtype:bad-unknown; sid:2100498; rev:7; metadata:created_at 2010_09_23, updated_at 2019_07_26;)''
      ];
    };
    helper = {
      imports = [ ../modules/profiles/minimal.nix ];

      networking.interfaces.eth1 = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "192.168.1.1";
            prefixLength = 24;
          }
        ];
      };

      services.nginx = {
        enable = true;
        virtualHosts."localhost".locations = {
          "/id/".return = "200 'uid=0(root) gid=0(root) groups=0(root)'";
        };
      };
      networking.firewall.allowedTCPPorts = [ 80 ];
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
