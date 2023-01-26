{ lib, nodes, ... }:

let
  inherit (lib)
    attrNames concatMap concatMapStrings flip forEach head
    listToAttrs mkDefault mkOption nameValuePair optionalString
    range types zipListsWith zipLists
    mdDoc
    ;

  nodeNumbers =
    listToAttrs
      (zipListsWith
        nameValuePair
        (attrNames nodes)
        (range 1 254)
      );

  networkModule = { config, nodes, pkgs, ... }:
    let
      qemu-common = import ../qemu-common.nix { inherit lib pkgs; };

      # Convert legacy VLANs to named interfaces and merge with explicit interfaces.
      vlansNumbered = forEach (zipLists config.virtualisation.vlans (range 1 255)) (v: {
        name = "eth${toString v.snd}";
        vlan = v.fst;
        assignIP = true;
      });
      explicitInterfaces = lib.mapAttrsToList (n: v: v // { name = n; }) config.virtualisation.interfaces;
      interfaces = vlansNumbered ++ explicitInterfaces;
      interfacesNumbered = zipLists interfaces (range 1 255);

      # Automatically assign IP addresses to requested interfaces.
      assignIPs = lib.filter (i: i.assignIP) interfaces;
      ipInterfaces = forEach assignIPs (i:
        nameValuePair i.name { ipv4.addresses =
          [ { address = "192.168.${toString i.vlan}.${toString config.virtualisation.test.nodeNumber}";
              prefixLength = 24;
            }];
        });

      qemuOptions = lib.flatten (forEach interfacesNumbered ({ fst, snd }:
        qemu-common.qemuNICFlags snd fst.vlan config.virtualisation.test.nodeNumber));
      udevRules = forEach interfacesNumbered ({ fst, snd }:
        "SUBSYSTEM==\"net\",ACTION==\"add\",ATTR{address}==\"${qemu-common.qemuNicMac fst.vlan config.virtualisation.test.nodeNumber}\",NAME=\"${fst.name}\"");

      networkConfig =
        {
          networking.hostName = mkDefault config.virtualisation.test.nodeName;

          networking.interfaces = listToAttrs ipInterfaces;

          networking.primaryIPAddress =
            optionalString (ipInterfaces != [ ]) (head (head ipInterfaces).value.ipv4.addresses).address;

          # Put the IP addresses of all VMs in this machine's
          # /etc/hosts file.  If a machine has multiple
          # interfaces, use the IP address corresponding to
          # the first interface (i.e. the first network in its
          # virtualisation.vlans option).
          networking.extraHosts = flip concatMapStrings (attrNames nodes)
            (m':
              let config = nodes.${m'}; in
              optionalString (config.networking.primaryIPAddress != "")
                ("${config.networking.primaryIPAddress} " +
                  optionalString (config.networking.domain != null)
                    "${config.networking.hostName}.${config.networking.domain} " +
                  "${config.networking.hostName}\n"));

          virtualisation.qemu.options = qemuOptions;
          boot.initrd.services.udev.rules = concatMapStrings (x: x + "\n") udevRules;
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

  nodeNumberModule = (regular@{ config, name, ... }: {
    options = {
      virtualisation.test.nodeName = mkOption {
        internal = true;
        default = name;
        # We need to force this in specilisations, otherwise it'd be
        # readOnly = true;
        description = mdDoc ''
          The `name` in `nodes.<name>`; stable across `specialisations`.
        '';
      };
      virtualisation.test.nodeNumber = mkOption {
        internal = true;
        type = types.int;
        readOnly = true;
        default = nodeNumbers.${config.virtualisation.test.nodeName};
        description = mdDoc ''
          A unique number assigned for each node in `nodes`.
        '';
      };

      # specialisations override the `name` module argument,
      # so we push the real `virtualisation.test.nodeName`.
      specialisation = mkOption {
        type = types.attrsOf (types.submodule {
          options.configuration = mkOption {
            type = types.submoduleWith {
              modules = [
                {
                  config.virtualisation.test.nodeName =
                    # assert regular.config.virtualisation.test.nodeName != "configuration";
                    regular.config.virtualisation.test.nodeName;
                }
              ];
            };
          };
        });
      };
    };
  });

in
{
  config = {
    extraBaseModules = { imports = [ networkModule nodeNumberModule ]; };
  };
}
