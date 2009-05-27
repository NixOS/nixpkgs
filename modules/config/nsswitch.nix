# Configuration for the Name Service Switch (/etc/nsswitch.conf).

{config, pkgs, ...}:

let

  options = {

    # NSS modules.  Hacky!
    system.nssModules = pkgs.lib.mkOption {
      internal = true;
      default = [];
      description = "
        Search path for NSS (Name Service Switch) modules.  This allows
        several DNS resolution methods to be specified via
        <filename>/etc/nsswitch.conf</filename>.
      ";
      merge = pkgs.lib.mergeListOption;
      apply = list:
        let
          list2 =
            list
            # !!! this should be in the LDAP module
            ++ pkgs.lib.optional config.users.ldap.enable pkgs.nss_ldap;
        in {
          list = list2;
          path = pkgs.lib.makeLibraryPath list2;
        };
    };

  };

in

{
  require = [options];

  environment.etc =
    [ # Name Service Switch configuration file.  Required by the C library.
      # !!! Factor out the mdns stuff.  The avahi module should define
      # an option used by this module.
      { source =
          if config.services.avahi.nssmdns
          then ./nsswitch-mdns.conf
          else ./nsswitch.conf;
        target = "nsswitch.conf";
      }
    ];

  environment.shellInit =
    if config.system.nssModules.path != "" then
      ''
        LD_LIBRARY_PATH=${config.system.nssModules.path}:$LD_LIBRARY_PATH
      ''
    else "";
}
