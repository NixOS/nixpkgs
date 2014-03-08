{ system, minimal ? false }:

with import ./build-vms.nix { inherit system minimal; };
with pkgs;

rec {

  inherit pkgs;


  testDriver = stdenv.mkDerivation {
    name = "nixos-test-driver";

    buildInputs = [ makeWrapper perl ];

    unpackPhase = "true";

    installPhase =
      ''
        mkdir -p $out/bin
        cp ${./test-driver/test-driver.pl} $out/bin/nixos-test-driver
        chmod u+x $out/bin/nixos-test-driver

        libDir=$out/lib/perl5/site_perl
        mkdir -p $libDir
        cp ${./test-driver/Machine.pm} $libDir/Machine.pm
        cp ${./test-driver/Logger.pm} $libDir/Logger.pm

        wrapProgram $out/bin/nixos-test-driver \
          --prefix PATH : "${pkgs.qemu_kvm}/bin:${pkgs.vde2}/bin:${imagemagick}/bin:${coreutils}/bin" \
          --prefix PERL5LIB : "${lib.makePerlPath [ perlPackages.TermReadLineGnu perlPackages.XMLWriter perlPackages.IOTty ]}:$out/lib/perl5/site_perl"
      '';
  };


  # Run an automated test suite in the given virtual network.
  # `driver' is the script that runs the network.
  runTests = driver:
    stdenv.mkDerivation {
      name = "vm-test-run";

      requiredSystemFeatures = [ "kvm" "nixos-test" ];

      buildInputs = [ pkgs.libxslt ];

      buildCommand =
        ''
          mkdir -p $out/nix-support

          LOGFILE=$out/log.xml tests='eval $ENV{testScript}; die $@ if $@;' ${driver}/bin/nixos-test-driver || failed=1

          # Generate a pretty-printed log.
          xsltproc --output $out/log.html ${./test-driver/log2html.xsl} $out/log.xml
          ln -s ${./test-driver/logfile.css} $out/logfile.css
          ln -s ${./test-driver/treebits.js} $out/treebits.js

          touch $out/nix-support/hydra-build-products
          echo "report testlog $out log.html" >> $out/nix-support/hydra-build-products

          for i in */xchg/coverage-data; do
            mkdir -p $out/coverage-data
            mv $i $out/coverage-data/$(dirname $(dirname $i))
          done

          [ -z "$failed" ] || touch $out/nix-support/failed
        ''; # */
    };


  makeTest = testFun: complete (call testFun);
  makeTests = testsFun: lib.mapAttrs (name: complete) (call testsFun);

  apply = makeTest; # compatibility
  call = f: f { inherit pkgs system; };

  complete = { testScript, ... } @ t: t // rec {

    nodes = buildVirtualNetwork (
      t.nodes or (if t ? machine then { machine = t.machine; } else { }));

    testScript =
      # Call the test script with the computed nodes.
      if builtins.isFunction t.testScript
      then t.testScript { inherit nodes; }
      else t.testScript;

    vlans = map (m: m.config.virtualisation.vlans) (lib.attrValues nodes);

    vms = map (m: m.config.system.build.vm) (lib.attrValues nodes);

    # Generate onvenience wrappers for running the test driver
    # interactively with the specified network, and for starting the
    # VMs from the command line.
    driver = runCommand "nixos-test-driver"
      { buildInputs = [ makeWrapper];
        inherit testScript;
        preferLocalBuild = true;
      }
      ''
        mkdir -p $out/bin
        echo "$testScript" > $out/test-script
        ln -s ${testDriver}/bin/nixos-test-driver $out/bin/
        vms="$(for i in ${toString vms}; do echo $i/bin/run-*-vm; done)"
        wrapProgram $out/bin/nixos-test-driver \
          --add-flags "$vms" \
          --run "testScript=\"\$(cat $out/test-script)\"" \
          --set testScript '"$testScript"' \
          --set VLANS '"${toString vlans}"'
        ln -s ${testDriver}/bin/nixos-test-driver $out/bin/nixos-run-vms
        wrapProgram $out/bin/nixos-run-vms \
          --add-flags "$vms" \
          --set tests '"startAll; joinAll;"' \
          --set VLANS '"${toString vlans}"' \
          ${lib.optionalString (builtins.length vms == 1) "--set USE_SERIAL 1"}
      ''; # "

    test = runTests driver;

    report = releaseTools.gcovReport { coverageRuns = [ test ]; };
  };


  runInMachine =
    { drv
    , machine
    , preBuild ? ""
    , postBuild ? ""
    , ... # ???
    }:
    let
      vm = buildVM { }
        [ machine
          { key = "run-in-machine";
            networking.hostName = "client";
            nix.readOnlyStore = false;
          }
        ];

      buildrunner = writeText "vm-build" ''
        source $1

        ${coreutils}/bin/mkdir -p $TMPDIR
        cd $TMPDIR

        $origBuilder $origArgs

        exit $?
      '';

      testscript = ''
        startAll;
        $client->waitForUnit("multi-user.target");
        ${preBuild}
        $client->succeed("env -i ${pkgs.bash}/bin/bash ${buildrunner} /tmp/xchg/saved-env >&2");
        ${postBuild}
        $client->succeed("sync"); # flush all data before pulling the plug
      '';

      vmRunCommand = writeText "vm-run" ''
        ${coreutils}/bin/mkdir $out
        ${coreutils}/bin/mkdir -p vm-state-client/xchg
        export > vm-state-client/xchg/saved-env
        export tests='${testscript}'
        ${testDriver}/bin/nixos-test-driver ${vm.config.system.build.vm}/bin/run-*-vm
      ''; # */

    in
      lib.overrideDerivation drv (attrs: {
        requiredSystemFeatures = [ "kvm" ];
        builder = "${bash}/bin/sh";
        args = ["-e" vmRunCommand];
        origArgs = attrs.args;
        origBuilder = attrs.builder;
      });


  runInMachineWithX = { require ? [], ... } @ args:
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
        preBuild =
          ''
            $client->waitForX;
          '';
      } // args);


  simpleTest = as: (makeTest ({ ... }: as)).test;

}
