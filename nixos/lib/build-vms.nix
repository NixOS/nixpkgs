{ system, minimal ? false, config ? {} }:

let pkgs = import ../.. { inherit system config; }; in

with pkgs.lib;
with import ../lib/qemu-flags.nix;

rec {

  inherit pkgs;


  # Build a virtual network from an attribute set `{ machine1 =
  # config1; ... machineN = configN; }', where `machineX' is the
  # hostname and `configX' is a NixOS system configuration.  Each
  # machine is given an arbitrary IP address in the virtual network.
  buildVirtualNetwork =
    nodes: let nodesOut = mapAttrs (n: buildVM nodesOut) (assignIPAddresses nodes); in nodesOut;


  buildVM =
    nodes: configurations:

    import ./eval-config.nix {
      inherit system;
      modules = configurations ++
        [ ../modules/virtualisation/qemu-vm.nix
          ../modules/testing/test-instrumentation.nix # !!! should only get added for automated test runs
          { key = "no-manual"; services.nixosManual.enable = false; }
        ] ++ optional minimal ../modules/testing/minimal-kernel.nix;
      extraArgs = { inherit nodes; };
    };


  # Given an attribute set { machine1 = config1; ... machineN =
  # configN; }, sequentially assign IP addresses in the 192.168.1.0/24
  # range to each machine, and set the hostname to the attribute name.
  assignIPAddresses = nodes:

    let

      machines = attrNames nodes;

      machinesNumbered = zipLists machines (range 1 254);

      nodes_ = flip map machinesNumbered (m: nameValuePair m.fst
        [ ( { config, pkgs, nodes, ... }:
            let
              interfacesNumbered = zipLists config.virtualisation.vlans (range 1 255);
              interfaces = flip map interfacesNumbered ({ fst, snd }:
                nameValuePair "eth${toString snd}" { ip4 =
                  [ { address = "192.168.${toString fst}.${toString m.snd}";
                      prefixLength = 24;
                  } ];
                });
            in
            { key = "ip-address";
              config =
                { networking.hostName = m.fst;

                  networking.interfaces = listToAttrs interfaces;

                  networking.primaryIPAddress =
                    optionalString (interfaces != []) (head (head interfaces).value.ip4).address;

                  # Put the IP addresses of all VMs in this machine's
                  # /etc/hosts file.  If a machine has multiple
                  # interfaces, use the IP address corresponding to
                  # the first interface (i.e. the first network in its
                  # virtualisation.vlans option).
                  networking.extraHosts = flip concatMapStrings machines
                    (m': let config = (getAttr m' nodes).config; in
                      optionalString (config.networking.primaryIPAddress != "")
                        ("${config.networking.primaryIPAddress} " +
                         "${config.networking.hostName}\n"));

                  virtualisation.qemu.options =
                    flip map interfacesNumbered
                      ({ fst, snd }: qemuNICFlags snd fst m.snd);
                };
            }
          )
          (getAttr m.fst nodes)
        ] );

    in listToAttrs nodes_;

}
