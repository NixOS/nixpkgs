{ config, pkgs, ... }:

with pkgs.lib;

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

    system.activationScripts.policyKit = fullDepEntry
      ''
        mkdir -m 0770 -p /var/run/PolicyKit
        chown root.polkituser /var/run/PolicyKit

        mkdir -m 0770 -p /var/lib/PolicyKit
        chown root.polkituser /var/lib/PolicyKit
        
        mkdir -p /var/lib/misc
        touch /var/lib/misc/PolicyKit.reload
        chmod 0664 /var/lib/misc/PolicyKit.reload
        chown polkituser.polkituser /var/lib/misc/PolicyKit.reload
      '' [ "users" ];

  };

}
