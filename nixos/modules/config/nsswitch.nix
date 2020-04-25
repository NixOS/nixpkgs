# Configuration for the Name Service Switch (/etc/nsswitch.conf).

{ config, lib, pkgs, ... }:

with lib;

let

  # only with nscd up and running we can load NSS modules that are not integrated in NSS
  canLoadExternalModules = config.services.nscd.enable;
  myhostname = canLoadExternalModules;
  mymachines = canLoadExternalModules;
  # XXX Move these to their respective modules
  nssmdns = canLoadExternalModules && config.services.avahi.nssmdns;
  nsswins = canLoadExternalModules && config.services.samba.nsswins;
  ldap = canLoadExternalModules && (config.users.ldap.enable && config.users.ldap.nsswitch);
  sssd = canLoadExternalModules && config.services.sssd.enable;
  resolved = canLoadExternalModules && config.services.resolved.enable;
  googleOsLogin = canLoadExternalModules && config.security.googleOsLogin.enable;

  hostArray = mkMerge [
    (mkBefore [ "files" ])
    (mkIf mymachines [ "mymachines" ])
    (mkIf nssmdns [ "mdns_minimal [NOTFOUND=return]" ])
    (mkIf nsswins [ "wins" ])
    (mkIf resolved [ "resolve [!UNAVAIL=return]" ])
    (mkAfter [ "dns" ])
    (mkIf nssmdns (mkOrder 1501 [ "mdns" ])) # 1501 to ensure it's after dns
    (mkIf myhostname (mkOrder 1600 [ "myhostname" ])) # 1600 to ensure it's always the last
  ];

  passwdArray = mkMerge [
    (mkBefore [ "files" ])
    (mkIf sssd [ "sss" ])
    (mkIf ldap [ "ldap" ])
    (mkIf mymachines [ "mymachines" ])
    (mkIf googleOsLogin [ "cache_oslogin oslogin" ])
    (mkIf canLoadExternalModules (mkAfter [ "systemd" ]))
  ];

  shadowArray = mkMerge [
    (mkBefore [ "files" ])
    (mkIf sssd [ "sss" ])
    (mkIf ldap [ "ldap" ])
  ];

  servicesArray = mkMerge [
    (mkBefore [ "files" ])
    (mkIf sssd [ "sss" ])
  ];

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

    system.nssDatabases = {
      passwd = mkOption {
        type = types.listOf types.str;
        description = ''
          List of passwd entries to configure in <filename>/etc/nsswitch.conf</filename>.

          Note that "files" is always prepended while "systemd" is appended if nscd is enabled.

          This option only takes effect if nscd is enabled.
        '';
        default = [];
      };

      group = mkOption {
        type = types.listOf types.str;
        description = ''
          List of group entries to configure in <filename>/etc/nsswitch.conf</filename>.

          Note that "files" is always prepended while "systemd" is appended if nscd is enabled.

          This option only takes effect if nscd is enabled.
        '';
        default = [];
      };

      shadow = mkOption {
        type = types.listOf types.str;
        description = ''
          List of shadow entries to configure in <filename>/etc/nsswitch.conf</filename>.

          Note that "files" is always prepended.

          This option only takes effect if nscd is enabled.
        '';
        default = [];
      };

      hosts = mkOption {
        type = types.listOf types.str;
        description = ''
          List of hosts entries to configure in <filename>/etc/nsswitch.conf</filename>.

          Note that "files" is always prepended, and "dns" and "myhostname" are always appended.

          This option only takes effect if nscd is enabled.
        '';
        default = [];
      };

      services = mkOption {
        type = types.listOf types.str;
        description = ''
          List of services entries to configure in <filename>/etc/nsswitch.conf</filename>.

          Note that "files" is always prepended.

          This option only takes effect if nscd is enabled.
        '';
        default = [];
      };
    };
  };

  imports = [
    (mkRenamedOptionModule [ "system" "nssHosts" ] [ "system" "nssDatabases" "hosts" ])
  ];

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
    # library.
    environment.etc."nsswitch.conf".text = ''
      passwd:    ${concatStringsSep " " config.system.nssDatabases.passwd}
      group:     ${concatStringsSep " " config.system.nssDatabases.group}
      shadow:    ${concatStringsSep " " config.system.nssDatabases.shadow}

      hosts:     ${concatStringsSep " " config.system.nssDatabases.hosts}
      networks:  files

      ethers:    files
      services:  ${concatStringsSep " " config.system.nssDatabases.services}
      protocols: files
      rpc:       files
    '';

    system.nssDatabases = {
      passwd = passwdArray;
      group = passwdArray;
      shadow = shadowArray;
      hosts = hostArray;
      services = servicesArray;
    };

    # Systemd provides nss-myhostname to ensure that our hostname
    # always resolves to a valid IP address.  It returns all locally
    # configured IP addresses, or ::1 and 127.0.0.2 as
    # fallbacks. Systemd also provides nss-mymachines to return IP
    # addresses of local containers.
    system.nssModules = (optionals canLoadExternalModules [ config.systemd.package.out ])
      ++ optional googleOsLogin pkgs.google-compute-engine-oslogin.out;
  };
}
