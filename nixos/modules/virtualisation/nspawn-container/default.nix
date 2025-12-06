# This module creates a lightweight "container" from the NixOS configuration.
# Building the `config.system.build.nspawn` attribute gives you a command
# that starts a systemd-nspawn container running the NixOS configuration
# defined in `config`. By default, the Nix store is shared read-only with the
# host, which makes (re)building very efficient.
# This shares a lot in common with
# `nixos/modules/virtualisation/nixos-containers.nix`, but doesn't use systemd
# units.
# The networking options here match the options in
# `nixos/modules/virtualisation/nixos-containers.nix` which allows using these
# lightweight containers for nixos integration tests.

{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) types;
  cfg = config.virtualisation;

  interfaceType = types.submodule (
    { name, ... }:
    {
      options = {
        name = lib.mkOption {
          type = types.str;
          default = name;
          description = ''
            Interface name
          '';
        };

        vlan = lib.mkOption {
          type = types.ints.unsigned;
          description = ''
            VLAN to which the network interface is connected.
          '';
        };

        assignIP = lib.mkOption {
          type = types.bool;
          default = false;
          description = ''
            Automatically assign an IP address to the network interface using the same scheme as
            virtualisation.vlans.
          '';
        };
      };
    }
  );

  # Convert legacy VLANs to named interfaces.
  vlansNumbered = lib.listToAttrs (
    lib.forEach (lib.zipLists cfg.vlans (lib.range 1 255)) (
      v:
      let
        name = "eth${toString v.snd}";
      in
      lib.nameValuePair name {
        inherit name;
        vlan = v.fst;
        assignIP = true;
      }
    )
  );
in
{
  options = {
    networking.primaryIPAddress = lib.mkOption {
      type = types.str;
      default = "";
      internal = true;
      description = "Primary IP address used in /etc/hosts.";
    };

    networking.primaryIPv6Address = lib.mkOption {
      type = types.str;
      default = "";
      internal = true;
      description = "Primary IPv6 address used in /etc/hosts.";
    };

    virtualisation.vlans = lib.mkOption {
      type = types.listOf types.ints.unsigned;
      default = if cfg.interfaces == { } then [ 1 ] else [ ];
      defaultText = lib.literalExpression ''if cfg.interfaces == {} then [ 1 ] else [ ]'';
      example = [
        1
        2
      ];
      description = ''
        Virtual networks to which the container is connected. Each number «N» in
        this list causes the container to have a virtual Ethernet interface
        attached to a separate virtual network on which it will be assigned IP
        address `192.168.«N».«M»`, where «M» is the index of this container in
        the list of containers.
      '';
    };

    virtualisation.interfaces = lib.mkOption {
      default = { };
      example = {
        enp1s0.vlan = 1;
      };
      description = ''
        Network interfaces to add to the container.
      '';
      type = types.attrsOf interfaceType;
    };

    virtualisation.allInterfaces = lib.mkOption {
      type = types.attrsOf interfaceType;
      readOnly = true;
      description = ''
        All network interfaces for the VM. Combines
        {option}`virtualisation.vlans` and {option}`virtualisation.interfaces`.
      '';
      default = vlansNumbered // cfg.interfaces;
    };

    virtualisation.initArgs = lib.mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [
        "systemd.unit=rescue.target"
        "systemd.log_level=debug"
        "systemd.log_target=console"
      ];
      description = ''
        Command line arguments to pass to the init process (likely systemd).
        Useful for debugging.
      '';
    };

    virtualisation.rootDir = lib.mkOption {
      type = types.str;
      default = "./${config.system.name}-root";
      defaultText = lib.literalExpression ''"./''${config.system.name}-root"'';
      description = ''
        Path to a directory for the root filesystem for the container.
        The directory will be created on startup if it does not
        exist.
      '';
    };

    virtualisation.systemd-nspawn = {
      package = lib.mkPackageOption pkgs "systemd" { };
      options = lib.mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "--bind=/home:/home" ];
        description = ''
          Options passed to systemd-nspawn.
          See [systemd-nspawn docs](https://www.freedesktop.org/software/systemd/man/latest/systemd-nspawn.html) for a complete list.
        '';
      };
    };
  };

  config = {
    assertions = [
      (
        let
          conflictingKeys = lib.intersectAttrs vlansNumbered cfg.interfaces;
        in
        {
          assertion = conflictingKeys == { };
          message = ''
            `virtualisation.vlans` and `virtualisation.interfaces` have conflicting keys: ${lib.concatStringsSep "," (lib.attrNames conflictingKeys)}
          '';
        }
      )
      (
        let
          allInterfaceNames =
            (lib.mapAttrsToList (k: i: i.name) vlansNumbered)
            ++ (lib.mapAttrsToList (k: i: i.name) cfg.interfaces);
        in
        {
          assertion = lib.allUnique allInterfaceNames;
          message = ''
            `virtualisation.vlans` and `virtualisation.interfaces` have conflicting interface names: ${lib.concatStringsSep "," allInterfaceNames}
          '';
        }
      )
    ];

    boot.isNspawnContainer = true;

    # Needed since nixpkgs 7fb2f407c01b017737eafc26b065d7f56434a992 removed the getty unit by default.
    console.enable = true;

    virtualisation.systemd-nspawn.options = [
      "--private-network"
      "--machine=${config.system.name}"
      "--bind-ro=/nix/store:/nix/store"

      # systemd-nspawn does some cleverness to mount a procfs and sysfs in an
      # unprivileged container, see
      # <https://github.com/systemd/systemd/blob/v258.2/src/nspawn/nspawn.c#L4341-L4349>.
      # Unfortunately, this doesn't work in the Nix build sandbox as we do not
      # have permission to mount filesystems of type `sysfs` nor `procfs`.
      # Fortunately, the build sandbox does provide a `/proc` and `/sys` that
      # we can just forward onto the container.
      "--private-users=no"
      "--bind=/proc:/run/host/proc"
      "--bind=/sys:/run/host/sys"

      # From `man systemd-nspawn`:
      # > Use --keep-unit and --register=no in combination to disable any
      # > kind of unit allocation or registration with systemd-machined.
      "--keep-unit"
      "--register=no"
    ];

    system.build.nspawn =
      let
        toPythonStr =
          s:
          assert builtins.typeOf s == "string";
          # Hack: JSON strings are (AFAIK) valid Python expressions that
          # represent the exact same string.
          builtins.toJSON s;

        toPythonExpression = data: /* python */ "json.loads(${toPythonStr (builtins.toJSON data)})";
      in
      pkgs.writers.writePython3Bin "run-${config.system.name}-nspawn"
        {
          libraries = ps: [
            (pkgs.callPackage ./run-nspawn { python3Packages = ps; })
          ];
        }
        ''
          import json
          import os
          import sys
          from pathlib import Path

          import run_nspawn

          run_nspawn.run(
            container_name=${toPythonStr config.system.name},  # noqa
            root_dir_str=Path(os.environ.get("RUN_NSPAWN_ROOT_DIR", ${toPythonStr cfg.rootDir})),  # noqa
            interfaces=${toPythonExpression (lib.attrValues cfg.allInterfaces)},  # noqa
            nspawn_options=${toPythonExpression config.virtualisation.systemd-nspawn.options} + sys.argv[1:],  # noqa
            init=${toPythonStr "${config.system.build.toplevel}/init"},  # noqa
            init_args=${toPythonExpression cfg.initArgs},  # noqa
          )
        '';
  };
}
