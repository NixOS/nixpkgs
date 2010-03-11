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


  # !!! Rename these functions to something more sensible.    
  call = f: f { inherit pkgs nixpkgs system; };

  apply = testFun: complete (call testFun);

  complete = t: t // rec {
    nodes =
      if t ? nodes then t.nodes else
      if t ? machine then { machine = t.machine; }
      else { };
    vms = buildVirtualNetwork { inherit nodes; };
    test = runTests vms t.testScript;
    report = makeReport test;
  };

  runInMachine = {
    drv
  , machine
  , preBuild ? ""
  , postBuild ? ""
  }:
    let
      vms =
        buildVirtualNetwork { nodes = { client = machine; } ; };

      buildrunner = writeText "vm-build" ''
        source $1
        ${coreutils}/bin/mkdir -p $TMPDIR
        exec $origBuilder $origArgs 
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
   
  simpleTest = as: (apply ({ ... }: as)).test;

}
