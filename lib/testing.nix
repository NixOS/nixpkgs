{ nixpkgs, services, system }:

with import ./build-vms.nix { inherit nixpkgs services system; };
with pkgs;

rec {

  inherit pkgs;


  # Run an automated test suite in the given virtual network.
  # `network' must be the result of a call to the
  # `buildVirtualNetwork' function.  `tests' is a Perl fragment
  # describing the tests.
  runTests = network: tests:
    stdenv.mkDerivation {
      name = "vm-test-run";
      inherit tests;
      
      buildInputs = [ pkgs.qemu_kvm pkgs.imagemagick ];
      
      buildCommand =
        ''
          mkdir $out
          cp ${./test-driver/Machine.pm} Machine.pm
          ensureDir $out/nix-support
          
          ${perl}/bin/perl ${./test-driver/test-driver.pl} ${network}/vms/*/bin/run-*-vm
          
          for i in */coverage-data; do
            ensureDir $out/coverage-data
            mv $i $out/coverage-data/$(dirname $i)
          done

          touch $out/nix-support/hydra-build-products

          for i in $out/*.png; do
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


  makeTest = testFun: complete (call testFun);
  makeTests = testsFun: lib.mapAttrs (name: complete) (call testsFun);

  apply = makeTest; # compatibility
  call = f: f { inherit pkgs nixpkgs system; };

  complete = t: t // rec {
    nodes =
      if t ? nodes then t.nodes else
      if t ? machine then { machine = t.machine; }
      else { };
    vms = buildVirtualNetwork { inherit nodes; };
    test = runTests vms
      # Call the test script with the computed nodes.
      (if builtins.isFunction t.testScript then t.testScript { inherit (vms) nodes; } else t.testScript);
    report = makeReport test;
  };

  runInMachine =
    { drv
    , machine
    , preBuild ? ""
    , postBuild ? ""
    , ...
    }:
    let
      vms =
        buildVirtualNetwork { nodes = { client = machine; } ; };

      # ugly workaround, until we figure out why some fs actions work properly inside 
      # the vm. (e.g. unlink gives access denied over smb in qemu). note that the function
      # now only works for derivations that lead to a directory in the store, not a file. 
      buildrunner = writeText "vm-build" ''
        source $1
        origout=$out
        out=$TMPDIR$out

        echo "--------------------------------"
        echo "Creating $out"
        echo "--------------------------------"
        ${coreutils}/bin/mkdir -p $out

        echo "--------------------------------"
        echo "Linking $origout to $out "
        echo "--------------------------------"
        ${coreutils}/bin/ln -s $out $origout

        echo "--------------------------------"
        echo "Creating $TMPDIR"
        echo "--------------------------------"
        ${coreutils}/bin/mkdir -p $TMPDIR

        echo "--------------------------------"
        echo "Running builder"
        echo "--------------------------------"
        $origBuilder $origArgs 

        echo "--------------------------------"
        echo "Removing link $origout"
        echo "--------------------------------"
        ${coreutils}/bin/rm -vf $origout

        echo "--------------------------------"
        echo "Creating $origout"
        echo "--------------------------------"
        ${coreutils}/bin/mkdir -p $origout

        echo "--------------------------------"
        echo "Copying $out/* to $origout/"
        echo "--------------------------------"
        ${coreutils}/bin/cp -Rv $out/* $origout/
        out=$origout 
      '';

      testscript = ''
        startAll;
        ${preBuild}
        print STDERR $client->mustSucceed("source ${buildrunner} /hostfs".$client->stateDir."/saved-env");
        ${postBuild}
      '';

      vmRunCommand = writeText "vm-run" ''
        ${coreutils}/bin/mkdir -p client
        export > client/saved-env
        export PATH=${qemu_kvm}/bin:${coreutils}/bin
        cp ${./test-driver/Machine.pm} Machine.pm
        export tests='${testscript}'
        ${perl}/bin/perl ${./test-driver/test-driver.pl} ${vms}/vms/*/bin/run-*-vm
      '';

    in
      lib.overrideDerivation drv (attrs: {
        builder = "${bash}/bin/sh";
        args = ["-e" vmRunCommand];
        origArgs = attrs.args;
        origBuilder = attrs.builder;
      });

  runInMachineWithX = { require ? [], ...}@args :
    let
      client =
        { config, pkgs, ... }:
        {
          inherit require;
          virtualisation.memorySize = 1024;
          services.xserver.enable = true;
          services.xserver.displayManager.slim.enable = false;
          services.xserver.displayManager.auto.enable = true;
          services.xserver.windowManager.default = "icewm";
          services.xserver.windowManager.icewm.enable = true;
          services.xserver.desktopManager.default = "none";
        };
    in
      runInMachine ({
            machine = client;
            preBuild = ''
              $client->waitForX;
            '' ;
          } // args );   

  simpleTest = as: (makeTest ({ ... }: as)).test;

}
