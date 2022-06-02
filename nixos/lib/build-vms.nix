{ system
, # Use a minimal kernel?
  minimal ? false
, # Ignored
  config ? null
, # Nixpkgs, for qemu, lib and more
  pkgs, lib
, # !!! See comment about args in lib/modules.nix
  specialArgs ? {}
, # NixOS configuration to add to the VMs
  extraConfigurations ? []
}:

with lib;

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
      inherit system specialArgs;
      modules = configurations ++ extraConfigurations;
      baseModules =  (import ../modules/module-list.nix) ++
        [ ../modules/virtualisation/qemu-vm.nix
          ../modules/testing/test-instrumentation.nix # !!! should only get added for automated test runs
          { key = "no-manual"; documentation.nixos.enable = false; }
          { key = "no-revision";
            # Make the revision metadata constant, in order to avoid needless retesting.
            # The human version (e.g. 21.05-pre) is left as is, because it is useful
            # for external modules that test with e.g. testers.nixosTest and rely on that
            # version number.
            config.system.nixos.revision = mkForce "constant-nixos-revision";
          }
          { key = "nodes"; _module.args.nodes = nodes; }
        ] ++ optional minimal ../modules/testing/minimal-kernel.nix;
    };


  # Given an attribute set { machine1 = config1; ... machineN =
  # configN; }, sequentially assign IP addresses in the 192.168.1.0/24
  # range to each machine, and set the hostname to the attribute name.
  assignIPAddresses = nodes:

    let

      machines = attrNames nodes;

      machinesNumbered = zipLists machines (range 1 254);

      nodes_ = forEach machinesNumbered (m: nameValuePair m.fst
        [ ( { config, nodes, ... }:
            let
              interfacesNumbered = zipLists config.virtualisation.vlans (range 1 255);
              interfaces = forEach interfacesNumbered ({ fst, snd }:
                nameValuePair "eth${toString snd}" { ipv4.addresses =
                  [ { address = "192.168.${toString fst}.${toString m.snd}";
                      prefixLength = 24;
                  } ];
                });

              networkConfig =
                { networking.hostName = mkDefault m.fst;

                  networking.interfaces = listToAttrs interfaces;

                  networking.primaryIPAddress =
                    optionalString (interfaces != []) (head (head interfaces).value.ipv4.addresses).address;

                  # Put the IP addresses of all VMs in this machine's
                  # /etc/hosts file.  If a machine has multiple
                  # interfaces, use the IP address corresponding to
                  # the first interface (i.e. the first network in its
                  # virtualisation.vlans option).
                  networking.extraHosts = flip concatMapStrings machines
                    (m': let config = (getAttr m' nodes).config; in
                      optionalString (config.networking.primaryIPAddress != "")
                        ("${config.networking.primaryIPAddress} " +
                         optionalString (config.networking.domain != null)
                           "${config.networking.hostName}.${config.networking.domain} " +
                         "${config.networking.hostName}\n"));

                  virtualisation.qemu.options =
                    let qemu-common = import ../lib/qemu-common.nix { inherit lib pkgs; };
                    in flip concatMap interfacesNumbered
                      ({ fst, snd }: qemu-common.qemuNICFlags snd fst m.snd);
                };

              in
                { key = "ip-address";
                  config = networkConfig // {
                    # Expose the networkConfig items for tests like nixops
                    # that need to recreate the network config.
                    system.build.networkConfig = networkConfig;
                  };
                }
          )
          (getAttr m.fst nodes)
        ] );

    in listToAttrs nodes_;

}
