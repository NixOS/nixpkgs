# Configuration for the Name Service Switch (/etc/nsswitch.conf).

{ config, lib, pkgs, ... }:

with lib;

{
  options = {
    system.nssModules = mkOption {
      type = types.listOf types.path;
      internal = true;
      default = [];
      description = ''
        Path containing NSS (Name Service Switch) modules.
        This allows several DNS resolution methods to be specified via
        <filename>/etc/nsswitch.conf</filename>.
      '';
      apply = list:
        {
          inherit list;
          path = pkgs.symlinkJoin {
            name = "nss-modules";
            paths = list;
          };
        };
    };

    system.nssDatabases = {
      passwd = mkOption {
        type = types.listOf types.str;
        description = ''
          List of passwd entries to configure in <filename>/etc/nsswitch.conf</filename>.
        '';
        default = [];
      };

      group = mkOption {
        type = types.listOf types.str;
        description = ''
          List of group entries to configure in <filename>/etc/nsswitch.conf</filename>.
        '';
        default = [];
      };

      shadow = mkOption {
        type = types.listOf types.str;
        description = ''
          List of shadow entries to configure in <filename>/etc/nsswitch.conf</filename>.
        '';
        default = [];
      };

      hosts = mkOption {
        type = types.listOf types.str;
        description = ''
          List of hosts entries to configure in <filename>/etc/nsswitch.conf</filename>.
        '';
        default = [];
      };

      services = mkOption {
        type = types.listOf types.str;
        description = ''
          List of services entries to configure in <filename>/etc/nsswitch.conf</filename>.
        '';
        default = [];
      };
    };
  };

  imports = [
    (mkRenamedOptionModule [ "system" "nssHosts" ] [ "system" "nssDatabases" "hosts" ])
  ];

  config = {
    # Provide configured NSS modules at /run/nss-modules
    # We can mix NSS modules from any version of glibc according to
    # https://sourceware.org/legacy-ml/libc-help/2016-12/msg00008.html,
    # so glibc upgrades shouldn't break old userland loading more recent NSS
    # modules (and most likely, NSS modules are already loaded)
    systemd.tmpfiles.rules = [
      "L+ /run/nss-modules - - - - ${config.system.nssModules.path}"
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
      passwd = mkBefore [ "files" ];
      group = mkBefore [ "files" ];
      shadow = mkBefore [ "files" ];
      hosts = mkMerge [
        (mkOrder 998 [ "files" ])
        (mkOrder 1499 [ "dns" ])
      ];
      services = mkBefore [ "files" ];
    };
  };
}
