# Configuration for the Name Service Switch (/etc/nsswitch.conf).

{ config, pkgs, ... }:

with pkgs.lib;

let

  inherit (config.services.avahi) nssmdns;
  inherit (config.services.samba) nsswins;

in

{
  options = {

    # NSS modules.  Hacky!
    system.nssModules = mkOption {
      type = types.listOf types.path;
      internal = true;
      default = [];
      description = ''
        Search path for NSS (Name Service Switch) modules.  This allows
        several DNS resolution methods to be specified via
        <filename>/etc/nsswitch.conf</filename>.
      '';
      apply = list:
        {
          inherit list;
          path = makeLibraryPath list;
        };
    };

  };

  config = {

    environment.etc =
      [ # Name Service Switch configuration file.  Required by the C library.
        # !!! Factor out the mdns stuff.  The avahi module should define
        # an option used by this module.
        { source = pkgs.writeText "nsswitch.conf"
            ''
              passwd:    files ldap
              group:     files ldap
              shadow:    files ldap
              hosts:     files ${optionalString nssmdns "mdns_minimal [NOTFOUND=return]"} dns ${optionalString nssmdns "mdns"} ${optionalString nsswins "wins"} myhostname
              networks:  files dns
              ethers:    files
              services:  files
              protocols: files
            '';
          target = "nsswitch.conf";
        }
      ];

    # Use nss-myhostname to ensure that our hostname always resolves to
    # a valid IP address.  It returns all locally configured IP
    # addresses, or ::1 and 127.0.0.2 as fallbacks.
    system.nssModules = [ pkgs.systemd ];

  };
}
