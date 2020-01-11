{ system
, pkgs ? import ../.. { inherit system config; }
  # Use a minimal kernel?
, minimal ? false
  # Ignored
, config ? {}
  # Modules to add to each VM
, extraConfigurations ? [] }:

with import ./build-vms.nix { inherit system pkgs minimal extraConfigurations; };
with pkgs;

let
  jquery-ui = callPackage ./testing/jquery-ui.nix { };
  jquery = callPackage ./testing/jquery.nix { };

in rec {

  inherit pkgs;


  testDriver = let
    testDriverScript = ./test-driver/test-driver.py;
  in stdenv.mkDerivation {
    name = "nixos-test-driver";

    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [ (python3.withPackages (p: [ p.ptpython ])) ];
    checkInputs = with python3Packages; [ pylint black mypy ];

    dontUnpack = true;

    preferLocalBuild = true;

    doCheck = true;
    checkPhase = ''
      mypy --disallow-untyped-defs \
           --no-implicit-optional \
           --ignore-missing-imports ${testDriverScript}
      pylint --errors-only ${testDriverScript}
      black --check --diff ${testDriverScript}
    '';

    installPhase =
      ''
        mkdir -p $out/bin
        cp ${testDriverScript} $out/bin/nixos-test-driver
        chmod u+x $out/bin/nixos-test-driver
        # TODO: copy user script part into this file (append)

        wrapProgram $out/bin/nixos-test-driver \
          --prefix PATH : "${lib.makeBinPath [ qemu_test vde2 netpbm coreutils ]}" \
      '';
  };


  # Run an automated test suite in the given virtual network.
  # `driver' is the script that runs the network.
  runTests = driver:
    stdenv.mkDerivation {
      name = "vm-test-run-${driver.testName}";

      requiredSystemFeatures = [ "kvm" "nixos-test" ];

      buildInputs = [ libxslt ];

      buildCommand =
        ''
          mkdir -p $out/nix-support

          LOGFILE=$out/log.xml tests='exec(os.environ["testScript"])' ${driver}/bin/nixos-test-driver

          # Generate a pretty-printed log.
          xsltproc --output $out/log.html ${./test-driver/log2html.xsl} $out/log.xml
          ln -s ${./test-driver/logfile.css} $out/logfile.css
          ln -s ${./test-driver/treebits.js} $out/treebits.js
          ln -s ${jquery}/js/jquery.min.js $out/
          ln -s ${jquery}/js/jquery.js $out/
          ln -s ${jquery-ui}/js/jquery-ui.min.js $out/
          ln -s ${jquery-ui}/js/jquery-ui.js $out/

          touch $out/nix-support/hydra-build-products
          echo "report testlog $out log.html" >> $out/nix-support/hydra-build-products

          for i in */xchg/coverage-data; do
            mkdir -p $out/coverage-data
            mv $i $out/coverage-data/$(dirname $(dirname $i))
          done
        '';
    };


  makeTest =
    { testScript
    , makeCoverageReport ? false
    , enableOCR ? false
    , name ? "unnamed"
    # Skip linting (mainly intended for faster dev cycles)
    , skipLint ? false
    , ...
    } @ t:

    let
      # A standard store path to the vm monitor is built like this:
      #   /tmp/nix-build-vm-test-run-$name.drv-0/vm-state-machine/monitor
      # The max filename length of a unix domain socket is 108 bytes.
      # This means $name can at most be 50 bytes long.
      maxTestNameLen = 50;
      testNameLen = builtins.stringLength name;

      testDriverName = with builtins;
        if testNameLen > maxTestNameLen then
          abort ("The name of the test '${name}' must not be longer than ${toString maxTestNameLen} " +
            "it's currently ${toString testNameLen} characters long.")
        else
          "nixos-test-driver-${name}";

      nodes = buildVirtualNetwork (
        t.nodes or (if t ? machine then { machine = t.machine; } else { }));

      testScript' =
        # Call the test script with the computed nodes.
        if lib.isFunction testScript
        then testScript { inherit nodes; }
        else testScript;

      vlans = map (m: m.config.virtualisation.vlans) (lib.attrValues nodes);

      vms = map (m: m.config.system.build.vm) (lib.attrValues nodes);

      ocrProg = tesseract4.override { enableLanguages = [ "eng" ]; };

      imagemagick_tiff = imagemagick_light.override { inherit libtiff; };

      # Generate onvenience wrappers for running the test driver
      # interactively with the specified network, and for starting the
      # VMs from the command line.
      driver = let warn = if skipLint then lib.warn "Linting is disabled!" else lib.id; in warn (runCommand testDriverName
        { buildInputs = [ makeWrapper];
          testScript = testScript';
          preferLocalBuild = true;
          testName = name;
        }
        ''
          mkdir -p $out/bin

          echo -n "$testScript" > $out/test-script
          ${lib.optionalString (!skipLint) ''
            ${python3Packages.black}/bin/black --check --diff $out/test-script
          ''}

          ln -s ${testDriver}/bin/nixos-test-driver $out/bin/
          vms=($(for i in ${toString vms}; do echo $i/bin/run-*-vm; done))
          wrapProgram $out/bin/nixos-test-driver \
            --add-flags "''${vms[*]}" \
            ${lib.optionalString enableOCR
              "--prefix PATH : '${ocrProg}/bin:${imagemagick_tiff}/bin'"} \
            --run "export testScript=\"\$(cat $out/test-script)\"" \
            --set VLANS '${toString vlans}'
          ln -s ${testDriver}/bin/nixos-test-driver $out/bin/nixos-run-vms
          wrapProgram $out/bin/nixos-run-vms \
            --add-flags "''${vms[*]}" \
            ${lib.optionalString enableOCR "--prefix PATH : '${ocrProg}/bin'"} \
            --set tests 'start_all(); join_all();' \
            --set VLANS '${toString vlans}' \
            ${lib.optionalString (builtins.length vms == 1) "--set USE_SERIAL 1"}
        ''); # "

      passMeta = drv: drv // lib.optionalAttrs (t ? meta) {
        meta = (drv.meta or {}) // t.meta;
      };

      test = passMeta (runTests driver);
      report = passMeta (releaseTools.gcovReport { coverageRuns = [ test ]; });

      nodeNames = builtins.attrNames nodes;
      invalidNodeNames = lib.filter
        (node: builtins.match "^[A-z_][A-z0-9_]+$" node == null) nodeNames;

    in
      if lib.length invalidNodeNames > 0 then
        throw ''
          Cannot create machines out of (${lib.concatStringsSep ", " invalidNodeNames})!
          All machines are referenced as perl variables in the testing framework which will break the
          script when special characters are used.

          Please stick to alphanumeric chars and underscores as separation.
        ''
      else
        (if makeCoverageReport then report else test) // {
          inherit nodes driver test;
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
            virtualisation.writableStore = false;
          }
        ];

      buildrunner = writeText "vm-build" ''
        source $1

        ${coreutils}/bin/mkdir -p $TMPDIR
        cd $TMPDIR

        exec $origBuilder $origArgs
      '';

      testScript = ''
        startAll;
        $client->waitForUnit("multi-user.target");
        ${preBuild}
        $client->succeed("env -i ${bash}/bin/bash ${buildrunner} /tmp/xchg/saved-env >&2");
        ${postBuild}
        $client->succeed("sync"); # flush all data before pulling the plug
      '';

      vmRunCommand = writeText "vm-run" ''
        xchg=vm-state-client/xchg
        ${coreutils}/bin/mkdir $out
        ${coreutils}/bin/mkdir -p $xchg

        for i in $passAsFile; do
          i2=''${i}Path
          _basename=$(${coreutils}/bin/basename ''${!i2})
          ${coreutils}/bin/cp ''${!i2} $xchg/$_basename
          eval $i2=/tmp/xchg/$_basename
          ${coreutils}/bin/ls -la $xchg
        done

        unset i i2 _basename
        export | ${gnugrep}/bin/grep -v '^xchg=' > $xchg/saved-env
        unset xchg

        export tests='${testScript}'
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
        { ... }:
        {
          inherit require;
          virtualisation.memorySize = 1024;
          services.xserver.enable = true;
          services.xserver.displayManager.auto.enable = true;
          services.xserver.displayManager.defaultSession = "none+icewm";
          services.xserver.windowManager.icewm.enable = true;
        };
    in
      runInMachine ({
        machine = client;
        preBuild =
          ''
            $client->waitForX;
          '';
      } // args);


  simpleTest = as: (makeTest as).test;

}
