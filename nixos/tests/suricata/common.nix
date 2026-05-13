{ lib, pkgs, ... }:
{
  # shared configuration module for suricata tests. it not a NixOS test by itself.
  meta.maintainers= with lib.maintainers; [ felbinger ];

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
          classification-file = "${pkgs.suricata}/etc/suricata/classification.config";
        };
      };

      # create suricata.rules with the rule to detect the output of the id command
      systemd.tmpfiles.rules = [
        ''f /var/lib/suricata/rules/suricata.rules 644 suricata suricata 0 alert ip any any -> any any (msg:"GPL ATTACK_RESPONSE id check returned root"; content:"uid=0|28|root|29|"; classtype:bad-unknown; sid:2100498; rev:7; metadata:created_at 2010_09_23, updated_at 2019_07_26;)''
      ];
    };
    helper = {
      imports = [ ../../modules/profiles/minimal.nix ];

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
}
