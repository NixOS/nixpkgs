# Configuration for the Name Service Switch (/etc/nsswitch.conf).
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {

    # NSS modules.  Hacky!
    # Only works with nscd!
    system.nssModules = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      internal = true;
      default = [ ];
      description = ''
        Search path for NSS (Name Service Switch) modules.  This allows
        several DNS resolution methods to be specified via
        {file}`/etc/nsswitch.conf`.
      '';
      apply = list: {
        inherit list;
        path = lib.makeLibraryPath list;
      };
    };

    system.nssDatabases = {
      passwd = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = ''
          List of passwd entries to configure in {file}`/etc/nsswitch.conf`.

          Note that "files" is always prepended while "systemd" is appended if nscd is enabled.

          This option only takes effect if nscd is enabled.
        '';
        default = [ ];
      };

      group = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = ''
          List of group entries to configure in {file}`/etc/nsswitch.conf`.

          Note that "files" is always prepended while "systemd" is appended if nscd is enabled.

          This option only takes effect if nscd is enabled.
        '';
        default = [ ];
      };

      shadow = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = ''
          List of shadow entries to configure in {file}`/etc/nsswitch.conf`.

          Note that "files" is always prepended.

          This option only takes effect if nscd is enabled.
        '';
        default = [ ];
      };

      sudoers = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = ''
          List of sudoers entries to configure in {file}`/etc/nsswitch.conf`.

          Note that "files" is always prepended.

          This option only takes effect if nscd is enabled.
        '';
        default = [ ];
      };

      hosts = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = ''
          List of hosts entries to configure in {file}`/etc/nsswitch.conf`.

          Note that "files" is always prepended, and "dns" and "myhostname" are always appended.

          This option only takes effect if nscd is enabled.
        '';
        default = [ ];
      };

      services = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = ''
          List of services entries to configure in {file}`/etc/nsswitch.conf`.

          Note that "files" is always prepended.

          This option only takes effect if nscd is enabled.
        '';
        default = [ ];
      };
    };
  };

  imports = [
    (lib.mkRenamedOptionModule [ "system" "nssHosts" ] [ "system" "nssDatabases" "hosts" ])
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
      passwd:    ${lib.concatStringsSep " " config.system.nssDatabases.passwd}
      group:     ${lib.concatStringsSep " " config.system.nssDatabases.group}
      shadow:    ${lib.concatStringsSep " " config.system.nssDatabases.shadow}
      sudoers:   ${lib.concatStringsSep " " config.system.nssDatabases.sudoers}

      hosts:     ${lib.concatStringsSep " " config.system.nssDatabases.hosts}
      networks:  files

      ethers:    files
      services:  ${lib.concatStringsSep " " config.system.nssDatabases.services}
      protocols: files
      rpc:       files
    '';

    system.nssDatabases = {
      passwd = lib.mkBefore [ "files" ];
      group = lib.mkBefore [ "files" ];
      shadow = lib.mkBefore [ "files" ];
      sudoers = lib.mkBefore [ "files" ];
      hosts = lib.mkMerge [
        (lib.mkOrder 998 [ "files" ])
        (lib.mkOrder 1499 [ "dns" ])
      ];
      services = lib.mkBefore [ "files" ];
    };
  };
}
