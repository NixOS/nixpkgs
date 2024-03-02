# Configuration for the Name Service Switch (/etc/nsswitch.conf).

{ config, lib, pkgs, ... }:

with lib;

{
  options = {

    # NSS modules.  Hacky!
    # Only works with nscd!
    system.nssModules = mkOption {
      type = types.listOf types.path;
      internal = true;
      default = [];
      description = lib.mdDoc ''
        Search path for NSS (Name Service Switch) modules.  This allows
        several DNS resolution methods to be specified via
        {file}`/etc/nsswitch.conf`.
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
        description = lib.mdDoc ''
          List of passwd entries to configure in {file}`/etc/nsswitch.conf`.

          Note that "files" is always prepended while "systemd" is appended if nscd is enabled.

          This option only takes effect if nscd is enabled.
        '';
        default = [];
      };

      group = mkOption {
        type = types.listOf types.str;
        description = lib.mdDoc ''
          List of group entries to configure in {file}`/etc/nsswitch.conf`.

          Note that "files" is always prepended while "systemd" is appended if nscd is enabled.

          This option only takes effect if nscd is enabled.
        '';
        default = [];
      };

      shadow = mkOption {
        type = types.listOf types.str;
        description = lib.mdDoc ''
          List of shadow entries to configure in {file}`/etc/nsswitch.conf`.

          Note that "files" is always prepended.

          This option only takes effect if nscd is enabled.
        '';
        default = [];
      };

      hosts = mkOption {
        type = types.listOf types.str;
        description = lib.mdDoc ''
          List of hosts entries to configure in {file}`/etc/nsswitch.conf`.

          Note that "files" is always prepended, and "dns" and "myhostname" are always appended.

          This option only takes effect if nscd is enabled.
        '';
        default = [];
      };

      services = mkOption {
        type = types.listOf types.str;
        description = lib.mdDoc ''
          List of services entries to configure in {file}`/etc/nsswitch.conf`.

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
        assertion = config.system.nssModules.path != "" -> config.services.nscd.enable;
        message = ''
          Loading NSS modules from system.nssModules (${config.system.nssModules.path}),
          requires services.nscd.enable being set to true.

          If disabling nscd is really necessary, it is possible to disable loading NSS modules
          by setting `system.nssModules = lib.mkForce [];` in your configuration.nix.
        '';
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
