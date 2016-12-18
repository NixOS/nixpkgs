# Configuration for the Name Service Switch (/etc/nsswitch.conf).

{ config, lib, pkgs, ... }:

with lib;

let

  inherit (config.services.avahi) nssmdns;
  inherit (config.services.samba) nsswins;
  ldap = (config.users.ldap.enable && config.users.ldap.nsswitch);

  hostArray = [ "files" "mymachines" ]
    ++ optionals nssmdns [ "mdns_minimal [!UNAVAIL=return]" ]
    ++ optionals nsswins [ "wins" ]
    ++ [ "dns" ]
    ++ optionals nssmdns [ "mdns" ]
    ++ ["myhostname" ];

  passwdArray = [ "files" ]
    ++ optionals ldap [ "ldap" ]
    ++ [ "mymachines" ];

  shadowArray = [ "files" ]
    ++ optionals ldap [ "ldap" ];

in {
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
    environment.etc."nsswitch.conf".text = ''
      passwd:    ${concatStringsSep " " passwdArray}
      group:     ${concatStringsSep " " passwdArray}
      shadow:    ${concatStringsSep " " shadowArray}

      hosts:     ${concatStringsSep " " hostArray}
      networks:  files

      ethers:    files
      services:  files
      protocols: files
      rpc:       files
    '';

    # Systemd provides nss-myhostname to ensure that our hostname
    # always resolves to a valid IP address.  It returns all locally
    # configured IP addresses, or ::1 and 127.0.0.2 as
    # fallbacks. Systemd also provides nss-mymachines to return IP
    # addresses of local containers.
    system.nssModules = [ config.systemd.package.out ];

  };
}
