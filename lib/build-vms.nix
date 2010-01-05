{ nixpkgs, services, system }:

let pkgs = import nixpkgs { config = {}; inherit system; }; in

with pkgs;

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
            QEMU_OPTS="-redir tcp:\$port2::80 -net nic,vlan=1 -net socket,vlan=1,mcast=232.0.1.1:1234" \$i/bin/run-*-vm &
          done
          EOF
          chmod +x $out/bin/run-vms
        ''; # */
    };


  buildVM =
    nodes: configurations:

    import ./eval-config.nix {
      inherit nixpkgs services system;
      modules = configurations ++
        [ ../modules/virtualisation/qemu-vm.nix # !!!
          ../modules/testing/test-instrumentation.nix # !!! should only get added for automated test runs
        ];
      extraArgs = { inherit nodes; };
      /* !!! bug in the module/option handling: this ignores the
         config from assignIPAddresses.  Too much magic. 
      configuration = {
        imports = [configuration "${nixos}/modules/virtualisation/qemu-vm.nix"];
        config = {
          # We don't need the manual in a test VM, and leaving it out
          # speeds up evaluation quite a bit.
          services.nixosManual.enable = false;
        };
      };
      */
    };


  # Given an attribute set { machine1 = config1; ... machineN =
  # configN; }, sequentially assign IP addresses in the 192.168.1.0/24
  # range to each machine, and set the hostname to the attribute name.
  assignIPAddresses = nodes:

    let
    
      machines = lib.attrNames nodes;

      machinesWithIP = zip machines
        (map (n: "192.168.1.${toString n}") (lib.range 1 254));

      # Generate a /etc/hosts file.
      hosts = lib.concatMapStrings (m: "${m.second} ${m.first}\n") machinesWithIP;

      nodes_ = map (m: lib.nameValuePair m.first [
          { config =
              { networking.hostName = m.first;
                networking.interfaces =
                  [ { name = "eth1";
                      ipAddress = m.second;
                    }
                  ];
                networking.extraHosts = hosts;
                services.nixosManual.enable = false; # !!!
              };
          }
          (lib.getAttr m.first nodes)
        ]) machinesWithIP;

    in lib.listToAttrs nodes_;

    
  # Zip two lists together.  Should be moved to pkgs.lib.
  zip = xs: ys:
    if xs != [] && ys != [] then
      [ {first = lib.head xs; second = lib.head ys;} ]
      ++ zip (lib.tail xs) (lib.tail ys)
    else [];


}
