# Configuration for the Name Service Switch (/etc/nsswitch.conf).

{ config, pkgs, ... }:

with pkgs.lib;

let

  options = {

    # NSS modules.  Hacky!
    system.nssModules = mkOption {
      internal = true;
      default = [];
      description = "
        Search path for NSS (Name Service Switch) modules.  This allows
        several DNS resolution methods to be specified via
        <filename>/etc/nsswitch.conf</filename>.
      ";
      merge = mergeListOption;
      apply = list:
        {
          inherit list;
          path = makeLibraryPath list;
          dir = pkgs.symlinkJoin "nss-modules" (map (p: "${p}/lib") list);
        };
    };

  };

  inherit (config.services.avahi) nssmdns;

in

{
  require = [ options ];

  environment.etc =
    [ # Name Service Switch configuration file.  Required by the C library.
      # !!! Factor out the mdns stuff.  The avahi module should define
      # an option used by this module.
      { source = pkgs.writeText "nsswitch.conf"
          ''
            passwd:    files ldap
            group:     files ldap
            shadow:    files ldap
            hosts:     files ${optionalString nssmdns "mdns_minimal [NOTFOUND=return]"} dns ${optionalString nssmdns "mdns"} myhostname
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
}
