{ system
, pkgs ? import ../.. { inherit system config; }
  # Use a minimal kernel?
, minimal ? false
  # Ignored
, config ? { }
  # !!! See comment about args in lib/modules.nix
, specialArgs ? { }
  # Modules to add to each VM
, extraConfigurations ? [ ]
}:

with pkgs;

rec {

  inherit pkgs;


  mkTestDriver =
    let
      testDriverScript = ./test-driver/test-driver.py;
    in
    qemu_pkg: stdenv.mkDerivation {
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
            --prefix PATH : "${lib.makeBinPath [ qemu_pkg vde2 netpbm coreutils ]}" \
        '';
    };

  # Run an automated test suite in the given virtual network.
  # `driver' is the script that runs the network.
  runTests = driver:
    stdenv.mkDerivation {
      name = "vm-test-run-${driver.testName}";

      requiredSystemFeatures = [ "kvm" "nixos-test" ];

      buildCommand =
        ''
          mkdir -p $out

          LOGFILE=/dev/null tests='exec(os.environ["testScript"])' ${driver}/bin/nixos-test-driver
        '';

      passthru = driver.passthru;
    };


  makeTest =
    { testScript
    , enableOCR ? false
    , name ? "unnamed"
      # Skip linting (mainly intended for faster dev cycles)
    , skipLint ? false
    , passthru ? {}
    , ...
    } @ t:
    let
      # A standard store path to the vm monitor is built like this:
      #   /tmp/nix-build-vm-test-run-$name.drv-0/vm-state-machine/monitor
      # The max filename length of a unix domain socket is 108 bytes.
      # This means $name can at most be 50 bytes long.
      maxTestNameLen = 50;
      testNameLen = builtins.stringLength name;



      ocrProg = tesseract4.override { enableLanguages = [ "eng" ]; };

      imagemagick_tiff = imagemagick_light.override { inherit libtiff; };

      # Generate convenience wrappers for running the test driver
      # interactively with the specified network, and for starting the
      # VMs from the command line.
      mkDriver = qemu_pkg:
        let
          build-vms = import ./build-vms.nix {
            inherit system pkgs minimal specialArgs;
            extraConfigurations = extraConfigurations ++ (pkgs.lib.optional (qemu_pkg != null)
              {
                virtualisation.qemu.package = qemu_pkg;
              }
            );
          };

          # FIXME: get this pkg from the module system
          testDriver = mkTestDriver (if qemu_pkg == null then pkgs.qemu_test else qemu_pkg);

          nodes = build-vms.buildVirtualNetwork (
            t.nodes or (if t ? machine then { machine = t.machine; } else { })
          );
          vlans = map (m: m.config.virtualisation.vlans) (lib.attrValues nodes);
          vms = map (m: m.config.system.build.vm) (lib.attrValues nodes);

          testScript' =
            # Call the test script with the computed nodes.
            if lib.isFunction testScript
            then testScript { inherit nodes; }
            else testScript;

          testDriverName = with builtins;
            if testNameLen > maxTestNameLen then
              abort
                ("The name of the test '${name}' must not be longer than ${toString maxTestNameLen} " +
                  "it's currently ${toString testNameLen} characters long.")
            else
              "nixos-test-driver-${name}";
        in
        lib.warnIf skipLint "Linting is disabled" (runCommand testDriverName
          {
            buildInputs = [ makeWrapper ];
            testScript = testScript';
            preferLocalBuild = true;
            testName = name;
            passthru = passthru // {
              inherit nodes;
            };
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
              --run "export testScript=\"\$(${coreutils}/bin/cat $out/test-script)\"" \
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
        meta = (drv.meta or { }) // t.meta;
      };

      driver = mkDriver null;
      driverInteractive = mkDriver pkgs.qemu;

      test = passMeta (runTests driver);

      nodeNames = builtins.attrNames driver.nodes;
      invalidNodeNames = lib.filter
        (node: builtins.match "^[A-z_]([A-z0-9_]+)?$" node == null)
        nodeNames;

    in
    if lib.length invalidNodeNames > 0 then
      throw ''
        Cannot create machines out of (${lib.concatStringsSep ", " invalidNodeNames})!
        All machines are referenced as python variables in the testing framework which will break the
        script when special characters are used.

        Please stick to alphanumeric chars and underscores as separation.
      ''
    else
      test // {
        inherit test driver driverInteractive;
        inherit (driver) nodes;
      };

  runInMachine =
    { drv
    , machine
    , preBuild ? ""
    , postBuild ? ""
    , qemu ? pkgs.qemu_test
    , ... # ???
    }:
    let
      build-vms = import ./build-vms.nix {
        inherit system pkgs minimal specialArgs extraConfigurations;
      };

      vm = build-vms.buildVM { }
        [
          machine
          {
            key = "run-in-machine";
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
        start_all()
        client.wait_for_unit("multi-user.target")
        ${preBuild}
        client.succeed("env -i ${bash}/bin/bash ${buildrunner} /tmp/xchg/saved-env >&2")
        ${postBuild}
        client.succeed("sync") # flush all data before pulling the plug
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
        ${mkTestDriver qemu}/bin/nixos-test-driver --keep-vm-state ${vm.config.system.build.vm}/bin/run-*-vm
      ''; # */

    in
    lib.overrideDerivation drv (attrs: {
      requiredSystemFeatures = [ "kvm" ];
      builder = "${bash}/bin/sh";
      args = [ "-e" vmRunCommand ];
      origArgs = attrs.args;
      origBuilder = attrs.builder;
    });


  runInMachineWithX = { require ? [ ], ... } @ args:
    let
      client =
        { ... }:
        {
          inherit require;
          imports = [
            ../tests/common/auto.nix
          ];
          virtualisation.memorySize = 1024;
          services.xserver.enable = true;
          test-support.displayManager.auto.enable = true;
          services.xserver.displayManager.defaultSession = "none+icewm";
          services.xserver.windowManager.icewm.enable = true;
        };
    in
    runInMachine ({
      machine = client;
      preBuild =
        ''
          client.wait_for_x()
        '';
    } // args);


  simpleTest = as: (makeTest as).test;

}
