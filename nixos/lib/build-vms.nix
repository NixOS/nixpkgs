{ system, minimal ? false }:

let pkgs = import ./nixpkgs.nix { config = {}; inherit system; }; in

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

      machinesNumbered = zipTwoLists machines (range 1 254);

      nodes_ = flip map machinesNumbered (m: nameValuePair m.first
        [ ( { config, pkgs, nodes, ... }:
            let
              interfacesNumbered = zipTwoLists config.virtualisation.vlans (range 1 255);
              interfaces = flip map interfacesNumbered ({ first, second }:
                nameValuePair "eth${toString second}"
                  { ipAddress = "192.168.${toString first}.${toString m.second}";
                    subnetMask = "255.255.255.0";
                  });
            in
            { key = "ip-address";
              config =
                { networking.hostName = m.first;

                  networking.interfaces = listToAttrs interfaces;

                  networking.primaryIPAddress =
                    optionalString (interfaces != []) (head interfaces).value.ipAddress;

                  # Put the IP addresses of all VMs in this machine's
                  # /etc/hosts file.  If a machine has multiple
                  # interfaces, use the IP address corresponding to
                  # the first interface (i.e. the first network in its
                  # virtualisation.vlans option).
                  networking.extraHosts = flip concatMapStrings machines
                    (m: let config = (getAttr m nodes).config; in
                      optionalString (config.networking.primaryIPAddress != "")
                        ("${config.networking.primaryIPAddress} " +
                         "${config.networking.hostName}\n"));

                  virtualisation.qemu.options =
                    flip map interfacesNumbered
                      ({ first, second }: qemuNICFlags second first m.second);
                };
            }
          )
          (getAttr m.first nodes)
        ] );

    in listToAttrs nodes_;

}
