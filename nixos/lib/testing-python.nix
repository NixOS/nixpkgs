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

  # Run an automated test suite in the given virtual network.
  runTests = { driver, driverInteractive, pos }:
    stdenv.mkDerivation {
      name = "vm-test-run-${driver.testName}";

      requiredSystemFeatures = [ "kvm" "nixos-test" ];

      buildCommand =
        ''
          mkdir -p $out

          # effectively mute the XMLLogger
          export LOGFILE=/dev/null

          ${driver}/bin/nixos-test-driver
        '';

      passthru = driver.passthru // {
        inherit driver driverInteractive;
      };

      inherit pos; # for better debugging
    };

  # Generate convenience wrappers for running the test driver
  # has vlans, vms and test script defaulted through env variables
  setupDriverForTest = {
      testScript
    , testName
    , nodes
    , qemu_pkg ? pkgs.qemu_test
    , enableOCR ? false
    , skipLint ? false
    , passthru ? {}
  }:
    let
      # Reifies and correctly wraps the python test driver for
      # the respective qemu version and with or without ocr support
      testDriver = pkgs.callPackage ./test-driver {
        inherit enableOCR;
        qemu_pkg = qemu_test;
        imagemagick_light = imagemagick_light.override { inherit libtiff; };
        tesseract4 = tesseract4.override { enableLanguages = [ "eng" ]; };
      };


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

      nodeHostNames = let
        nodesList = map (c: c.config.system.name) (lib.attrValues nodes);
      in nodesList ++ lib.optional (lib.length nodesList == 1) "machine";

      # TODO: This is an implementation error and needs fixing
      # the testing famework cannot legitimately restrict hostnames further
      # beyond RFC1035
      invalidNodeNames = lib.filter
        (node: builtins.match "^[A-z_]([A-z0-9_]+)?$" node == null)
        nodeHostNames;

    in
    if lib.length invalidNodeNames > 0 then
      throw ''
        Cannot create machines out of (${lib.concatStringsSep ", " invalidNodeNames})!
        All machines are referenced as python variables in the testing framework which will break the
        script when special characters are used.

        This is an IMPLEMENTATION ERROR and needs to be fixed. Meanwhile,
        please stick to alphanumeric chars and underscores as separation.
      ''
    else lib.warnIf skipLint "Linting is disabled" (runCommand testDriverName
      {
        inherit testName testScript;
        nativeBuildInputs = [ makeWrapper ];
        preferLocalBuild = true;
        passthru = passthru // {
          inherit nodes;
        };
      }
      ''
        mkdir -p $out/bin

        vmStartScripts=($(for i in ${toString vms}; do echo $i/bin/run-*-vm; done))
        echo -n "$testScript" > $out/test-script
        ln -s ${testDriver}/bin/nixos-test-driver $out/bin/nixos-test-driver

        ${testDriver}/bin/generate-driver-symbols
        ${lib.optionalString (!skipLint) ''
          PYFLAKES_BUILTINS="$(
            echo -n ${lib.escapeShellArg (lib.concatStringsSep "," nodeHostNames)},
            < ${lib.escapeShellArg "driver-symbols"}
          )" ${python3Packages.pyflakes}/bin/pyflakes $out/test-script
        ''}

        # set defaults through environment
        # see: ./test-driver/test-driver.py argparse implementation
        wrapProgram $out/bin/nixos-test-driver \
          --set startScripts "''${vmStartScripts[*]}" \
          --set testScript "$out/test-script" \
          --set vlans '${toString vlans}'
      '');

  # Make a full-blown test
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
      # Instantiates test script with nodes, if it's a function (contract)
      mkTestScript = qemu_pkg:
        # Call the test script with the computed nodes.
        if lib.isFunction testScript
        then testScript { nodes = nodes qemu_pkg false; }
        else testScript;

      nodes = qemu_pkg: addAdditionalPaths:
        let
          testScript' = mkTestScript qemu_pkg;
          build-vms = import ./build-vms.nix {
            inherit system lib pkgs minimal specialArgs;
            extraConfigurations = extraConfigurations ++ [(
              { config, ... }:
              {
                virtualisation.qemu.package = qemu_pkg;

                # Make sure all derivations referenced by the test
                # script are available on the nodes. When the store is
                # accessed through 9p, this isn't important, since
                # everything in the store is available to the guest,
                # but when building a root image it is, as all paths
                # that should be available to the guest has to be
                # copied to the image.
                virtualisation.additionalPaths =
                  lib.optional
                    (config.virtualisation.useNixStoreImage
                     && addAdditionalPaths
                     && builtins.hasContext testScript')
                    (pkgs.writeStringReferencesToFile testScript');

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

      driver = setupDriverForTest {
        inherit enableOCR skipLint passthru;
        testScript = mkTestScript pkgs.qemu_test;
        testName = name;
        qemu_pkg = pkgs.qemu_test;
        nodes = nodes pkgs.qemu_test true;
      };
      driverInteractive = setupDriverForTest {
        inherit enableOCR skipLint passthru;
        testScript = mkTestScript pkgs.qemu;
        testName = name;
        qemu_pkg = pkgs.qemu;
        nodes = nodes pkgs.qemu true;
      };

      test =
        let
          passMeta = drv: drv // lib.optionalAttrs (t ? meta) {
            meta = (drv.meta or { }) // t.meta;
          };
        in passMeta (runTests { inherit driver pos driverInteractive; });

    in
      test // {
        inherit test driver driverInteractive nodes;
      };

  abortForFunction = functionName: abort ''The ${functionName} function was
    removed because it is not an essential part of the NixOS testing
    infrastructure. It had no usage in NixOS or Nixpkgs and it had no designated
    maintainer. You are free to reintroduce it by documenting it in the manual
    and adding yourself as maintainer. It was removed in
    https://github.com/NixOS/nixpkgs/pull/137013
  '';

  runInMachine = abortForFunction "runInMachine";

  runInMachineWithX = abortForFunction "runInMachineWithX";

  simpleTest = as: (makeTest as).test;

}
