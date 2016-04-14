# Configuration for the Name Service Switch (/etc/nsswitch.conf).

{ config, lib, pkgs, ... }:

with lib;

let

  inherit (config.services.avahi) nssmdns;
  inherit (config.services.samba) nsswins;
  ldap = config.users.ldap.enable;
  sssd = config.services.sssd.enable;

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

    # Name Service Switch configuration file.  Required by the C
    # library.  !!! Factor out the mdns stuff.  The avahi module
    # should define an option used by this module.
    environment.etc."nsswitch.conf".text =
      ''
        passwd:    files ${optionalString ldap "ldap"} ${optionalString sssd "sss"}
        group:     files ${optionalString ldap "ldap"} ${optionalString sssd "sss"}
        shadow:    files ${optionalString ldap "ldap"} ${optionalString sssd "sss"}
        hosts:     files ${optionalString nssmdns "mdns_minimal [NOTFOUND=return]"} dns ${optionalString nssmdns "mdns"} ${optionalString nsswins "wins"} myhostname mymachines
        networks:  files dns
        ethers:    files
        services:  files
        protocols: files
        automount: files ${optionalString ldap "ldap"} ${optionalString sssd "sss"}
      '';

    # Systemd provides nss-myhostname to ensure that our hostname
    # always resolves to a valid IP address.  It returns all locally
    # configured IP addresses, or ::1 and 127.0.0.2 as
    # fallbacks. Systemd also provides nss-mymachines to return IP
    # addresses of local containers.
    system.nssModules = [ config.systemd.package ];

  };
}
