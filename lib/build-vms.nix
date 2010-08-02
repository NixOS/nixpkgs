{ nixpkgs, services, system }:

let pkgs = import nixpkgs { config = {}; inherit system; }; in

with pkgs;
with import ../lib/qemu-flags.nix;

rec {

  inherit pkgs;

  
  # Build a virtual network from an attribute set `{ machine1 =
  # config1; ... machineN = configN; }', where `machineX' is the
  # hostname and `configX' is a NixOS system configuration.  The
  # result is a script that starts a QEMU instance for each virtual
  # machine.  Each machine is given an arbitrary IP address in the
  # virtual network.
  buildVirtualNetwork =
    { nodes }:

    let nodes_ = lib.mapAttrs (n: buildVM nodes_) (assignIPAddresses nodes); in

    stdenv.mkDerivation {
      name = "vms";
      buildCommand =
        ''
          ensureDir $out/vms
          ${
            lib.concatMapStrings (vm:
              ''
                ln -sn ${vm.config.system.build.vm} $out/vms/${vm.config.networking.hostName}
              ''
            ) (lib.attrValues nodes_)
          }

          ensureDir $out/bin
          cat > $out/bin/run-vms <<EOF
          #! ${stdenv.shell}
          port=8080
          for i in $out/vms/*; do
            port2=\$((port++))
            echo "forwarding localhost:\$port2 to \$(basename \$i):80"
            QEMU_OPTS="-redir tcp:\$port2::80" \$i/bin/run-*-vm &
          done
          EOF
          chmod +x $out/bin/run-vms
        ''; # */
      passthru = { nodes = nodes_; };
    };


  buildVM =
    nodes: configurations:

    import ./eval-config.nix {
      inherit nixpkgs services system;
      modules = configurations ++
        [ ../modules/virtualisation/qemu-vm.nix
          ../modules/testing/test-instrumentation.nix # !!! should only get added for automated test runs
          { key = "no-manual"; services.nixosManual.enable = false; }
        ];
      extraArgs = { inherit nodes; };
    };


  # Given an attribute set { machine1 = config1; ... machineN =
  # configN; }, sequentially assign IP addresses in the 192.168.1.0/24
  # range to each machine, and set the hostname to the attribute name.
  assignIPAddresses = nodes:

    let
    
      machines = lib.attrNames nodes;

      machinesNumbered = lib.zip machines (lib.range 1 254);

      nodes_ = lib.flip map machinesNumbered (m: lib.nameValuePair m.first
        [ ( { config, pkgs, nodes, ... }:
            let
              interfacesNumbered = lib.zip config.virtualisation.vlans (lib.range 1 255);
              interfaces = 
                lib.flip map interfacesNumbered ({ first, second }:
                  { name = "eth${toString second}";
                    ipAddress = "192.168.${toString first}.${toString m.second}";
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
                    lib.flip lib.concatMapStrings interfacesNumbered
                      ({ first, second }: qemuNICFlags second first );
                };
            }
          )
          (lib.getAttr m.first nodes)
        ] );

    in lib.listToAttrs nodes_;

}
