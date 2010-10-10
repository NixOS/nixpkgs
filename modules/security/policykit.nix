{ config, pkgs, ... }:

with pkgs.lib;

let

  conf = pkgs.writeText "PolicyKit.conf"
    ''
      <?xml version="1.0" encoding="UTF-8"?>

      <!DOCTYPE pkconfig PUBLIC "-//freedesktop//DTD PolicyKit Configuration 1.0//EN"
        "http://hal.freedesktop.org/releases/PolicyKit/1.0/config.dtd">

      <config version="0.1">
      </config>
    '';

in

{

  config = {

    environment.systemPackages = [ pkgs.policykit ];

    services.dbus.packages = [ pkgs.policykit ];

    security.pam.services = [ { name = "polkit"; } ];

    users.extraUsers = singleton
      { name = "polkituser";
        uid = config.ids.uids.polkituser;
        description = "PolicyKit user";
      };

    users.extraGroups = singleton
      { name = "polkituser";
        gid = config.ids.gids.polkituser;
      };

    environment.etc =
      [ { source = conf;
          target = "PolicyKit/PolicyKit.conf";
        }
        { source = (pkgs.buildEnv {
            name = "PolicyKit-policies";
            pathsToLink = [ "/share/PolicyKit/policy" ];
            paths = [ pkgs.policykit pkgs.consolekit pkgs.hal ];
          }) + "/share/PolicyKit/policy";
          target = "PolicyKit/policy";
        }
      ];
      
    system.activationScripts.policyKit = stringAfter [ "users" ]
      ''
        mkdir -m 0770 -p /var/run/PolicyKit
        chown root.polkituser /var/run/PolicyKit

        mkdir -m 0770 -p /var/lib/PolicyKit
        chown root.polkituser /var/lib/PolicyKit
        
        mkdir -p /var/lib/misc
        touch /var/lib/misc/PolicyKit.reload
        chmod 0664 /var/lib/misc/PolicyKit.reload
        chown polkituser.polkituser /var/lib/misc/PolicyKit.reload
      '';

  };

}
