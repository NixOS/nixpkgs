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
      testDriverLib = ./test-driver/lib;
      ocrProg = tesseract4.override { enableLanguages = [ "eng" ]; };
      imagemagick_tiff = imagemagick_light.override { inherit libtiff; };
      name = "nixos-test-driver";
    in
    { qemu_pkg ? pkgs.qemu_test, enableOCR ? false}: stdenv.mkDerivation {
      inherit name;

      nativeBuildInputs = [ makeWrapper ];
      buildInputs = [ (python3.withPackages (p: [ p.ptpython p.python-json-logger ])) ];
      checkInputs = with python3Packages; [ pylint black mypy ];

      dontUnpack = true;

      preferLocalBuild = true;

      buildPhase = ''
        PYTHONPATH="${testDriverLib}:$PYTHONPATH"
        python <<EOF
        from pydoc import importfile
        with open('driver-symbols', 'w') as fp:
          t = importfile("${testDriverScript}")
          driver = t.Driver([], "")
          test_symbols = list(driver.test_symbols().keys())
          fp.write(','.join(test_symbols))
        EOF
      '';

      doCheck = true;
      checkPhase = ''
        PYTHONPATH="${testDriverLib}:$PYTHONPATH"
        mypy --disallow-untyped-defs \
             --no-implicit-optional \
             --ignore-missing-imports \
             ${testDriverScript} $(find ${testDriverLib} -type f)

        pylint --errors-only ${testDriverScript} $(find ${testDriverLib} -type f)
        black --check --diff ${testDriverScript} $(find ${testDriverLib} -type f)
      '';

      installPhase =
        ''
          mkdir -p $out/bin
          cp ${testDriverScript} $out/bin/nixos-test-driver
          # FIX: exec -a does not work for python shebangs
          substituteInPlace $out/bin/nixos-test-driver --subst-var name
          chmod u+x $out/bin/nixos-test-driver

          wrapProgram $out/bin/nixos-test-driver \
            --argv0  ${name} \
            --prefix PYTHONPATH : ${testDriverLib} \
            --prefix PATH : "${lib.makeBinPath [ qemu_pkg vde2 netpbm coreutils ]}" \
            ${lib.optionalString enableOCR
              "--prefix PATH : '${ocrProg}/bin:${imagemagick_tiff}/bin'"} \

          install -m 0644 -vD driver-symbols $out/nix-support/driver-symbols
        '';
    };

  # Run an automated test suite in the given virtual network.
  runTests = { driver, pos }:
    stdenv.mkDerivation {
      name = "vm-test-run-${driver.testName}";
      requiredSystemFeatures = [ "kvm" "nixos-test" ];
      buildCommand =
        ''
          mkdir -p $out
          ${driver}/bin/nixos-test-driver
        '';

      passthru = driver.passthru // {
        inherit driver;
      };
      inherit pos; # for better debugging
    };


  # Generate convenience wrappers for running the test driver
  # has vlans, vms and test script defaulted through env variables
  # also instantiates test script with nodes, if it's a function (contract)
  mkDriver = {
      testScript
    , testName
    , nodes
    , qemu_pkg ? pkgs.qemu_test
    , enableOCR ? false
    , skipLint ? false
    , passthru ? {}
  }:
    let
      # FIXME: get this pkg from the module system
      testDriver = mkTestDriver { inherit qemu_pkg enableOCR;};

      testDriverName =
        let
          # A standard store path to the vm monitor is built like this:
          #   /tmp/nix-build-vm-test-run-$name.drv-0/vm-state-machine/monitor
          # The max filename length of a unix domain socket is 108 bytes.
          # This means $name can at most be 50 bytes long.
          maxTestNameLen = 50;
          testNameLen = builtins.stringLength testName;
        in with builtins;
          if testNameLen > maxTestNameLen then
            abort
              ("The name of the test '${testName}' must not be longer than ${toString maxTestNameLen} " +
                "it's currently ${toString testNameLen} characters long.")
          else
            "nixos-test-driver-${testName}";

      vlans = map (m: m.config.virtualisation.vlans) (lib.attrValues nodes);
      vms = map (m: m.config.system.build.vm) (lib.attrValues nodes);

      nodeHostNames = map (c: c.config.system.name) (lib.attrValues nodes);
      invalidNodeNames = lib.filter
        (node: builtins.match "^[A-z_]([A-z0-9_]+)?$" node == null)
        (builtins.attrNames nodes);

      testScript' =
        # Call the test script with the computed nodes.
        if lib.isFunction testScript
        then testScript { inherit nodes; }
        else testScript;

    in
    if lib.length invalidNodeNames > 0 then
      throw ''
        Cannot create machines out of (${lib.concatStringsSep ", " invalidNodeNames})!
        All machines are referenced as python variables in the testing framework which will break the
        script when special characters are used.

        Please stick to alphanumeric chars and underscores as separation.
      ''
    else lib.warnIf skipLint "Linting is disabled" (runCommand testDriverName
      {
        inherit testName;
        nativeBuildInputs = [ makeWrapper ];
        testScript = testScript';
        preferLocalBuild = true;
        passthru = passthru // {
          inherit nodes;
        };
      }
      ''
        mkdir -p $out/bin

        vmStartScripts=($(for i in ${toString vms}; do echo $i/bin/run-*-vm; done))
        ln -s ${testDriver}/bin/nixos-test-driver $out/bin/nixos-test-driver

        echo ${lib.concatStringsSep "," nodeHostNames} > $out/nodenames

        echo -n "$testScript" > $out/test-script
        ${lib.optionalString (!skipLint) ''
           PYFLAKES_BUILTINS="$(
            echo -n ${lib.escapeShellArg (lib.concatStringsSep "," nodeHostNames)},
            < ${lib.escapeShellArg "${testDriver}/nix-support/driver-symbols"}
           )" ${python3Packages.pyflakes}/bin/pyflakes $out/test-script
        ''}

        # set defaults through environment
        # see: ./test-driver/test-driver.py argparse implementation
        wrapProgram $out/bin/nixos-test-driver \
          --set startScripts "''${vmStartScripts[*]}" \
          --set testScript "$out/test-script" \
          --set vlans '${toString vlans}'
       ''); # "

  makeTest =
    { testScript
    , enableOCR ? false
    , name ? "unnamed"
      # Skip linting (mainly intended for faster dev cycles)
    , skipLint ? false
    , passthru ? {}
    , # For meta.position
      pos ? # position used in error messages and for meta.position
        (if t.meta.description or null != null
          then builtins.unsafeGetAttrPos "description" t.meta
          else builtins.unsafeGetAttrPos "testScript" t)
    , ...
    } @ t:
    let
      nodes = qemu_pkg:
        let
          build-vms = import ./build-vms.nix {
            inherit system pkgs minimal specialArgs;
            extraConfigurations = extraConfigurations ++ [(
              {
                virtualisation.qemu.package = qemu_pkg;
                # Ensure we do not use aliases. Ideally this is only set
                # when the test framework is used by Nixpkgs NixOS tests.
                nixpkgs.config.allowAliases = false;
              }
            )];
          };
        in
          build-vms.buildVirtualNetwork (
              t.nodes or (if t ? machine then { machine = t.machine; } else { })
          );

      driver = mkDriver {
        inherit testScript enableOCR skipLint;
        testName = name;
        nodes = nodes pkgs.qemu_test;
      };
      driverInteractive = mkDriver {
        inherit testScript enableOCR skipLint;
        testName = name;
        nodes = nodes pkgs.qemu;
      };

      test =
        let
          passMeta = drv: drv // lib.optionalAttrs (t ? meta) {
            meta = (drv.meta or { }) // t.meta;
          };
        in passMeta (runTests { inherit driver pos; });
    in
      test // {
        inherit test driver driverInteractive nodes;
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

      testDriver = mkTestDriver { inherit qemu; };

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
        ${testDriver}/bin/nixos-test-driver --keep-vm-state ${vm.config.system.build.vm}/bin/run-*-vm
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
