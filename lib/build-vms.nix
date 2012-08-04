{ system, minimal ? false }:

let pkgs = import <nixpkgs> { config = {}; inherit system; }; in

with pkgs;
with import ../lib/qemu-flags.nix;

rec {

  inherit pkgs;


  # Build a virtual network from an attribute set `{ machine1 =
  # config1; ... machineN = configN; }', where `machineX' is the
  # hostname and `configX' is a NixOS system configuration.  Each
  # machine is given an arbitrary IP address in the virtual network.
  buildVirtualNetwork =
    nodes: let nodesOut = lib.mapAttrs (n: buildVM nodesOut) (assignIPAddresses nodes); in nodesOut;


  buildVM =
    nodes: configurations:

    import ./eval-config.nix {
      inherit system;
      modules = configurations ++
        [ ../modules/virtualisation/qemu-vm.nix
          ../modules/testing/test-instrumentation.nix # !!! should only get added for automated test runs
          { key = "no-manual"; services.nixosManual.enable = false; }
        ] ++ lib.optional minimal ../modules/testing/minimal-kernel.nix;
      extraArgs = { inherit nodes; };
    };


  # Given an attribute set { machine1 = config1; ... machineN =
  # configN; }, sequentially assign IP addresses in the 192.168.1.0/24
  # range to each machine, and set the hostname to the attribute name.
  assignIPAddresses = nodes:

    let

      machines = lib.attrNames nodes;

      machinesNumbered = lib.zipTwoLists machines (lib.range 1 254);

      nodes_ = lib.flip map machinesNumbered (m: lib.nameValuePair m.first
        [ ( { config, pkgs, nodes, ... }:
            let
              interfacesNumbered = lib.zipTwoLists config.virtualisation.vlans (lib.range 1 255);
              interfaces =
                lib.flip map interfacesNumbered ({ first, second }:
                  { name = "eth${toString second}";
                    ipAddress = "192.168.${toString first}.${toString m.second}";
                    subnetMask = "255.255.255.0";
                  }
                );
            in
            { key = "ip-address";
              config =
                { networking.hostName = m.first;

                  networking.interfaces = interfaces;

                  networking.primaryIPAddress =
                    lib.optionalString (interfaces != []) (lib.head interfaces).ipAddress;

                  # Put the IP addresses of all VMs in this machine's
                  # /etc/hosts file.  If a machine has multiple
                  # interfaces, use the IP address corresponding to
                  # the first interface (i.e. the first network in its
                  # virtualisation.vlans option).
                  networking.extraHosts = lib.flip lib.concatMapStrings machines
                    (m: let config = (lib.getAttr m nodes).config; in
                      lib.optionalString (config.networking.primaryIPAddress != "")
                        ("${config.networking.primaryIPAddress} " +
                         "${config.networking.hostName}\n"));

                  virtualisation.qemu.options =
                    lib.flip map interfacesNumbered
                      ({ first, second }: qemuNICFlags second first m.second);
                };
            }
          )
          (lib.getAttr m.first nodes)
        ] );

    in lib.listToAttrs nodes_;

}
