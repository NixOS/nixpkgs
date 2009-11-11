{ nixos ? ./..
, nixpkgs ? ../../nixpkgs
, services ? ../../nixos/services
, system ? builtins.currentSystem
}:

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

    import "${nixos}/lib/eval-config.nix" {
      inherit nixpkgs services system;
      modules = configurations ++ [
        "${nixos}/modules/virtualisation/qemu-vm.nix" # !!!
        "${nixos}/modules/testing/test-instrumentation.nix" # !!! should only get added for automated test runs
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


  # Run an automated test suite in the given virtual network.
  # `network' must be the result of a call to the
  # `buildVirtualNetwork' function.  `tests' is a Perl fragment
  # describing the tests.
  runTests = network: tests:
    stdenv.mkDerivation {
      name = "vm-test-run";
      inherit tests;
      buildCommand =
        ''
          mkdir $out
          cp ${./test-driver/Machine.pm} Machine.pm
          
          ${perl}/bin/perl ${./test-driver/test-driver.pl} ${network}/vms/*/bin/run-*-vm
          
          for i in */coverage-data; do
            ensureDir $out/coverage-data
            mv $i $out/coverage-data/$(dirname $i)
          done

          for i in $out/*.png; do
            ensureDir $out/nix-support
            echo "report screenshot $i" >> $out/nix-support/hydra-build-products
          done
        ''; # */
    };


  # Generate a coverage report from the coverage data produced by
  # runTests.
  makeReport = x: runCommand "report" { buildInputs = [rsync]; }
    ''
      for d in ${x}/coverage-data/*; do

          echo "doing $d"

          ensureDir $TMPDIR/gcov/

          for i in $(cd $d/nix/store && ls); do
              if ! test -e $TMPDIR/gcov/nix/store/$i; then
                  echo "copying $i"
                  mkdir -p $TMPDIR/gcov/$(echo $i | cut -c34-)
                  rsync -rv /nix/store/$i/.build/* $TMPDIR/gcov/
              fi
          done

          chmod -R u+w $TMPDIR/gcov

          find $TMPDIR/gcov -name "*.gcda" -exec rm {} \;

          for i in $(cd $d/nix/store && ls); do
              rsync -rv $d/nix/store/$i/.build/* $TMPDIR/gcov/
          done

          find $TMPDIR/gcov -name "*.gcda" -exec chmod 644 {} \;
          
          echo "producing info..."
          ${pkgs.lcov}/bin/geninfo --ignore-errors source,gcov $TMPDIR/gcov --output-file $TMPDIR/app.info
          cat $TMPDIR/app.info >> $TMPDIR/full.info
      done
            
      echo "making report..."
      ensureDir $out/coverage
      ${pkgs.lcov}/bin/genhtml --show-details $TMPDIR/full.info -o $out/coverage
      cp $TMPDIR/full.info $out/coverage/

      ensureDir $out/nix-support
      echo "report coverage $out/coverage" >> $out/nix-support/hydra-build-products
    ''; # */
    
}
