# This module defines networking options for virtual machines and containers.
# It is intended to be used with systemd-nspawn containers and QEMU virtual machines.
{ config, lib, ... }:
let
  inherit (lib) types;

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

  cfg = config.virtualisation;

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
      defaultText = lib.literalExpression "if cfg.interfaces == {} then [ 1 ] else [ ]";
      example = [
        1
        2
      ];
      description = ''
        Virtual networks to which the container or VM is connected. Each number «N» in
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
        Extra network interfaces to add to the container or VM in addition to the ones
        created by {option}`virtualisation.vlans`.
      '';
      type = types.attrsOf interfaceType;
    };

    virtualisation.allInterfaces = lib.mkOption {
      type = types.attrsOf interfaceType;
      readOnly = true;
      description = ''
        All network interfaces for the container or VM. Combines
        {option}`virtualisation.vlans` and {option}`virtualisation.interfaces`.
      '';
      default = vlansNumbered // cfg.interfaces;
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
  };
}
