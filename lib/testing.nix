{ nixpkgs, services, system }:

with import ./build-vms.nix { inherit nixpkgs services system; };
with pkgs;

rec {

  inherit pkgs;


  testDriver = stdenv.mkDerivation {
    name = "nixos-test-driver";
    buildCommand =
      ''
        mkdir -p $out/bin
        cp ${./test-driver/test-driver.pl} $out/bin/nixos-test-driver
        chmod u+x $out/bin/nixos-test-driver
        
        libDir=$out/lib/perl5/site_perl
        mkdir -p $libDir
        cp ${./test-driver/Machine.pm} $libDir/Machine.pm

        substituteInPlace $out/bin/nixos-test-driver \
          --subst-var-by perl "${perl}/bin/perl" \
          --subst-var-by readline "${perlPackages.TermReadLineGnu}/lib/perl5/site_perl" \
          --subst-var-by extraPath "${imagemagick}/bin" \
          --subst-var libDir
      '';
  };


  # Run an automated test suite in the given virtual network.
  # `network' must be the result of a call to the
  # `buildVirtualNetwork' function.  `tests' is a Perl fragment
  # describing the tests.
  runTests = network: tests:
    stdenv.mkDerivation {
      name = "vm-test-run";
      
      requiredSystemFeatures = [ "kvm" ];
      
      inherit tests;
      
      buildInputs = [ pkgs.qemu_kvm ];

      buildCommand =
        ''
          ensureDir $out/nix-support

          ${testDriver}/bin/nixos-test-driver ${network}/vms/*/bin/run-*-vm
          
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
    
    testScript =
      # Call the test script with the computed nodes.
      if builtins.isFunction t.testScript
      then t.testScript { inherit (vms) nodes; }
      else t.testScript;
      
    test = runTests vms testScript;
      
    report = makeReport test;

    # Generate a convenience wrapper for running the test driver
    # interactively with the specified network.
    driver = runCommand "nixos-test-driver"
      { buildInputs = [ makeWrapper];
        inherit testScript;
      }
      ''
        mkdir -p $out/bin
        ln -s ${vms}/bin/* $out/bin/
        ln -s ${testDriver}/bin/* $out/bin/
        wrapProgram $out/bin/nixos-test-driver \
          --add-flags "${vms}/vms/*/bin/run-*-vm" \
          --run "testScript=\"\$(cat $out/test-script)\"" \
          --set testScript '"$testScript"'
        echo "$testScript" > $out/test-script
      ''; # "
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

      buildrunner = writeText "vm-build" ''
        source $1
 
        ${coreutils}/bin/mkdir -p $TMPDIR
        cd $TMPDIR
        
        $origBuilder $origArgs
         
        exit $?
      '';

      testscript = ''
        startAll;
        ${preBuild}
        print STDERR $client->mustSucceed("env -i ${pkgs.bash}/bin/bash ${buildrunner} /hostfs".$client->stateDir."/saved-env");
        ${postBuild}
      '';

      vmRunCommand = writeText "vm-run" ''
        ${coreutils}/bin/mkdir -p client
        export > client/saved-env
        export PATH=${qemu_kvm}/bin:${coreutils}/bin
        cp ${./test-driver/Machine.pm} Machine.pm
        export tests='${testscript}'
        ${testDriver}/bin/nixos-test-driver ${vms}/vms/*/bin/run-*-vm
      ''; # */

    in
      lib.overrideDerivation drv (attrs: {
        requiredSystemFeatures = [ "kvm" ];
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
