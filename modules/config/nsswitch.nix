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
        let
          list2 =
            list
            # !!! this should be in the LDAP module
            ++ optional config.users.ldap.enable pkgs.nss_ldap;
        in {
          list = list2;
          path = makeLibraryPath list2;
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
            hosts:     files ${optionalString nssmdns "mdns_minimal [NOTFOUND=return]"} dns ${optionalString nssmdns "mdns"}
            networks:  files dns
            ethers:    files
            services:  files
            protocols: files
          '';
        target = "nsswitch.conf";
      }
    ];

  environment.shellInit =
    if config.system.nssModules.path != "" then
      ''
        LD_LIBRARY_PATH=${config.system.nssModules.path}:$LD_LIBRARY_PATH
      ''
    else "";

  # NSS modules need to be in `systemPath' so that (i) the builder
  # chroot gets to seem them, and (ii) applications can benefit from
  # changes in the list of NSS modules at run-time, without requiring
  # a reboot.
  environment.systemPackages = [ config.system.nssModules.list ];
}
