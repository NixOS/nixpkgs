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
      interfacesNumbered = zipLists config.virtualisation.vlans (range 1 255);
      interfaces = forEach interfacesNumbered ({ fst, snd }:
        nameValuePair "eth${toString snd}" {
          ipv4.addresses =
            [{
              address = "192.168.${toString fst}.${toString config.virtualisation.test.nodeNumber}";
              prefixLength = 24;
            }];
        });

      networkConfig =
        {
          networking.hostName = mkDefault config.virtualisation.test.nodeName;

          networking.interfaces = listToAttrs interfaces;

          networking.primaryIPAddress =
            optionalString (interfaces != [ ]) (head (head interfaces).value.ipv4.addresses).address;

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

          virtualisation.qemu.options =
            let qemu-common = import ../qemu-common.nix { inherit lib pkgs; };
            in
            flip concatMap interfacesNumbered
              ({ fst, snd }: qemu-common.qemuNICFlags snd fst config.virtualisation.test.nodeNumber);
        };

    in
    {
      key = "ip-address";
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
