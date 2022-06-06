{ lib, nodes, ... }:

with lib;


let
  machines = attrNames nodes;

  machinesNumbered = zipLists machines (range 1 254);

  nodes_ = forEach machinesNumbered (m: nameValuePair m.fst
    [
      ({ config, nodes, pkgs, ... }:
        let
          interfacesNumbered = zipLists config.virtualisation.vlans (range 1 255);
          interfaces = forEach interfacesNumbered ({ fst, snd }:
            nameValuePair "eth${toString snd}" {
              ipv4.addresses =
                [{
                  address = "192.168.${toString fst}.${toString m.snd}";
                  prefixLength = 24;
                }];
            });

          networkConfig =
            {
              networking.hostName = mkDefault m.fst;

              networking.interfaces = listToAttrs interfaces;

              networking.primaryIPAddress =
                optionalString (interfaces != [ ]) (head (head interfaces).value.ipv4.addresses).address;

              # Put the IP addresses of all VMs in this machine's
              # /etc/hosts file.  If a machine has multiple
              # interfaces, use the IP address corresponding to
              # the first interface (i.e. the first network in its
              # virtualisation.vlans option).
              networking.extraHosts = flip concatMapStrings machines
                (m':
                  let config = getAttr m' nodes; in
                  optionalString (config.networking.primaryIPAddress != "")
                    ("${config.networking.primaryIPAddress} " +
                      optionalString (config.networking.domain != null)
                        "${config.networking.hostName}.${config.networking.domain} " +
                      "${config.networking.hostName}\n"));

              virtualisation.qemu.options =
                let qemu-common = import ../qemu-common.nix { inherit lib pkgs; };
                in
                flip concatMap interfacesNumbered
                  ({ fst, snd }: qemu-common.qemuNICFlags snd fst m.snd);
            };

        in
        {
          key = "ip-address";
          config = networkConfig // {
            # Expose the networkConfig items for tests like nixops
            # that need to recreate the network config.
            system.build.networkConfig = networkConfig;
          };
        }
      )
    ]);

  extraNodeConfigs = lib.listToAttrs nodes_;
in
{
  config = {
    defaults = { config, name, ... }: {
      imports = extraNodeConfigs.${name};
    };
  };
}
