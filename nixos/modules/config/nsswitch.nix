# Configuration for the Name Service Switch (/etc/nsswitch.conf).

{ config, lib, pkgs, ... }:

with lib;

let

  # only with nscd up and running we can load NSS modules that are not integrated in NSS
  canLoadExternalModules = config.services.nscd.enable;
  myhostname = canLoadExternalModules;
  mymachines = canLoadExternalModules;
  nssmdns = canLoadExternalModules && config.services.avahi.nssmdns;
  nsswins = canLoadExternalModules && config.services.samba.nsswins;
  ldap = canLoadExternalModules && (config.users.ldap.enable && config.users.ldap.nsswitch);
  sssd = canLoadExternalModules && config.services.sssd.enable;
  resolved = canLoadExternalModules && config.services.resolved.enable;
  googleOsLogin = canLoadExternalModules && config.security.googleOsLogin.enable;

  hostArray = [ "files" ]
    ++ optional mymachines "mymachines"
    ++ optional nssmdns "mdns_minimal [NOTFOUND=return]"
    ++ optional nsswins "wins"
    ++ optional resolved "resolve [!UNAVAIL=return]"
    ++ [ "dns" ]
    ++ optional nssmdns "mdns"
    ++ optional myhostname "myhostname";

  passwdArray = [ "files" ]
    ++ optional sssd "sss"
    ++ optional ldap "ldap"
    ++ optional mymachines "mymachines"
    ++ optional googleOsLogin "cache_oslogin oslogin"
    ++ [ "systemd" ];

  shadowArray = [ "files" ]
    ++ optional sssd "sss"
    ++ optional ldap "ldap";

  servicesArray = [ "files" ]
    ++ optional sssd "sss";

in {
  options = {

    # NSS modules.  Hacky!
    # Only works with nscd!
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
    assertions = [
      {
        # generic catch if the NixOS module adding to nssModules does not prevent it with specific message.
        assertion = config.system.nssModules.path != "" -> canLoadExternalModules;
        message = "Loading NSS modules from path ${config.system.nssModules.path} requires nscd being enabled.";
      }
      {
        # resolved does not need to add to nssModules, therefore needs an extra assertion
        assertion = resolved -> canLoadExternalModules;
        message = "Loading systemd-resolved's nss-resolve NSS module requires nscd being enabled.";
      }
    ];

    # Name Service Switch configuration file.  Required by the C
    # library.  !!! Factor out the mdns stuff.  The avahi module
    # should define an option used by this module.
    environment.etc."nsswitch.conf".text = ''
      passwd:    ${concatStringsSep " " passwdArray}
      group:     ${concatStringsSep " " passwdArray}
      shadow:    ${concatStringsSep " " shadowArray}

      hosts:     ${concatStringsSep " " hostArray}
      networks:  files

      ethers:    files
      services:  ${concatStringsSep " " servicesArray}
      protocols: files
      rpc:       files
    '';

    # Systemd provides nss-myhostname to ensure that our hostname
    # always resolves to a valid IP address.  It returns all locally
    # configured IP addresses, or ::1 and 127.0.0.2 as
    # fallbacks. Systemd also provides nss-mymachines to return IP
    # addresses of local containers.
    system.nssModules = (optionals canLoadExternalModules [ config.systemd.package.out ])
      ++ optional googleOsLogin pkgs.google-compute-engine-oslogin.out;
  };
}
