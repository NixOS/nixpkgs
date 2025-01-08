{ lib, nodes, ... }:

let

  nodeNumbers = lib.listToAttrs (lib.zipListsWith lib.nameValuePair (lib.attrNames nodes) (lib.range 1 254));

  networkModule =
    {
      config,
      nodes,
      pkgs,
      ...
    }:
    let
      qemu-common = import ../qemu-common.nix { inherit lib pkgs; };

      # Convert legacy VLANs to named interfaces and merge with explicit interfaces.
      vlansNumbered = lib.forEach (lib.zipLists config.virtualisation.vlans (lib.range 1 255)) (v: {
        name = "eth${toString v.snd}";
        vlan = v.fst;
        assignIP = true;
      });
      explicitInterfaces = lib.mapAttrsToList (n: v: v // { name = n; }) config.virtualisation.interfaces;
      interfaces = vlansNumbered ++ explicitInterfaces;
      interfacesNumbered = lib.zipLists interfaces (lib.range 1 255);

      # Automatically assign IP addresses to requested interfaces.
      assignIPs = lib.filter (i: i.assignIP) interfaces;
      ipInterfaces = lib.forEach assignIPs (
        i:
        lib.nameValuePair i.name {
          ipv4.addresses = [
            {
              address = "192.168.${toString i.vlan}.${toString config.virtualisation.test.nodeNumber}";
              prefixLength = 24;
            }
          ];
          ipv6.addresses = [
            {
              address = "2001:db8:${toString i.vlan}::${toString config.virtualisation.test.nodeNumber}";
              prefixLength = 64;
            }
          ];
        }
      );

      qemuOptions = lib.flatten (
        lib.forEach interfacesNumbered (
          { fst, snd }: qemu-common.qemuNICFlags snd fst.vlan config.virtualisation.test.nodeNumber
        )
      );
      udevRules = lib.forEach interfacesNumbered (
        { fst, snd }:
        # MAC Addresses for QEMU network devices are lowercase, and udev string comparison is case-sensitive.
        ''SUBSYSTEM=="net",ACTION=="add",ATTR{address}=="${lib.toLower (qemu-common.qemuNicMac fst.vlan config.virtualisation.test.nodeNumber)}",NAME="${fst.name}"''
      );

      networkConfig = {
        networking.hostName = lib.mkDefault config.virtualisation.test.nodeName;

        networking.interfaces = lib.listToAttrs ipInterfaces;

        networking.primaryIPAddress =
          lib.optionalString (ipInterfaces != [ ])
            (lib.head (lib.head ipInterfaces).value.ipv4.addresses).address;

        networking.primaryIPv6Address =
          lib.optionalString (ipInterfaces != [ ])
            (lib.head (lib.head ipInterfaces).value.ipv6.addresses).address;

        # Put the IP addresses of all VMs in this machine's
        # /etc/hosts file.  If a machine has multiple
        # interfaces, use the IP address corresponding to
        # the first interface (i.e. the first network in its
        # virtualisation.vlans option).
        networking.extraHosts = lib.flip lib.concatMapStrings (lib.attrNames nodes) (
          m':
          let
            config = nodes.${m'};
            hostnames =
              lib.optionalString (
                config.networking.domain != null
              ) "${config.networking.hostName}.${config.networking.domain} "
              + "${config.networking.hostName}\n";
          in
          lib.optionalString (
            config.networking.primaryIPAddress != ""
          ) "${config.networking.primaryIPAddress} ${hostnames}"
          + lib.optionalString (config.networking.primaryIPv6Address != "") (
            "${config.networking.primaryIPv6Address} ${hostnames}"
          )
        );

        virtualisation.qemu.options = qemuOptions;
        boot.initrd.services.udev.rules = lib.concatMapStrings (x: x + "\n") udevRules;
      };

    in
    {
      key = "network-interfaces";
      config = networkConfig // {
        # Expose the networkConfig items for tests like nixops
        # that need to recreate the network config.
        system.build.networkConfig = networkConfig;
      };
    };

  nodeNumberModule = (
    regular@{ config, name, ... }:
    {
      options = {
        virtualisation.test.nodeName = lib.mkOption {
          internal = true;
          default = name;
          # We need to force this in specilisations, otherwise it'd be
          # readOnly = true;
          description = ''
            The `name` in `nodes.<name>`; stable across `specialisations`.
          '';
        };
        virtualisation.test.nodeNumber = lib.mkOption {
          internal = true;
          type = lib.types.int;
          readOnly = true;
          default = nodeNumbers.${config.virtualisation.test.nodeName};
          description = ''
            A unique number assigned for each node in `nodes`.
          '';
        };

        # specialisations override the `name` module argument,
        # so we push the real `virtualisation.test.nodeName`.
        specialisation = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.submodule {
              options.configuration = lib.mkOption {
                type = lib.types.submoduleWith {
                  modules = [
                    {
                      config.virtualisation.test.nodeName =
                        # assert regular.config.virtualisation.test.nodeName != "configuration";
                        regular.config.virtualisation.test.nodeName;
                    }
                  ];
                };
              };
            }
          );
        };
      };
    }
  );

in
{
  config = {
    extraBaseModules = {
      imports = [
        networkModule
        nodeNumberModule
      ];
    };
  };
}
