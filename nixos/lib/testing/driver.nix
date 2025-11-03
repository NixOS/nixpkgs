{
  config,
  lib,
  hostPkgs,
  ...
}:
let
  inherit (lib) mkOption types literalMD;

  # Reifies and correctly wraps the python test driver for
  # the respective qemu version and with or without ocr support
  testDriver = hostPkgs.callPackage ../test-driver {
    inherit (config) enableOCR extraPythonPackages;
    qemu_pkg = config.qemu.package;
    imagemagick_light = hostPkgs.imagemagick_light.override { inherit (hostPkgs) libtiff; };
    tesseract4 = hostPkgs.tesseract4.override { enableLanguages = [ "eng" ]; };
  };

  vlans = map (
    m: (m.virtualisation.vlans ++ (lib.mapAttrsToList (_: v: v.vlan) m.virtualisation.interfaces))
  ) (lib.attrValues config.nodes);
  vms = map (m: m.system.build.vm) (lib.attrValues config.nodes);

  nodeHostNames =
    let
      nodesList = map (c: c.system.name) (lib.attrValues config.nodes);
    in
    nodesList ++ lib.optional (lib.length nodesList == 1 && !lib.elem "machine" nodesList) "machine";

  pythonizeName =
    name:
    let
      head = lib.substring 0 1 name;
      tail = lib.substring 1 (-1) name;
    in
    (if builtins.match "[A-z_]" head == null then "_" else head)
    + lib.stringAsChars (c: if builtins.match "[A-z0-9_]" c == null then "_" else c) tail;

  uniqueVlans = lib.unique (builtins.concatLists vlans);
  vlanNames = map (i: "vlan${toString i}: VLan;") uniqueVlans;
  pythonizedNames = map pythonizeName nodeHostNames;
  machineNames = map (name: "${name}: Machine;") pythonizedNames;

  withChecks = lib.warnIf config.skipLint "Linting is disabled";

  driver =
    hostPkgs.runCommand "nixos-test-driver-${config.name}"
      {
        # inherit testName; TODO (roberth): need this?
        nativeBuildInputs = [
          hostPkgs.makeWrapper
        ]
        ++ lib.optionals (!config.skipTypeCheck) [ hostPkgs.mypy ];
        buildInputs = [ testDriver ];
        testScript = config.testScriptString;
        preferLocalBuild = true;
        passthru = config.passthru;
        meta = config.meta // {
          mainProgram = "nixos-test-driver";
        };
      }
      ''
        mkdir -p $out/bin

        vmStartScripts=($(for i in ${toString vms}; do echo $i/bin/run-*-vm; done))

        ${lib.optionalString (!config.skipTypeCheck) ''
          # prepend type hints so the test script can be type checked with mypy
          cat "${../test-script-prepend.py}" >> testScriptWithTypes
          echo "${builtins.toString machineNames}" >> testScriptWithTypes
          echo "${builtins.toString vlanNames}" >> testScriptWithTypes
          echo -n "$testScript" >> testScriptWithTypes

          echo "Running type check (enable/disable: config.skipTypeCheck)"
          echo "See https://nixos.org/manual/nixos/stable/#test-opt-skipTypeCheck"

          mypy  --no-implicit-optional \
                --pretty \
                --no-color-output \
                testScriptWithTypes
        ''}

        echo -n "$testScript" >> $out/test-script

        ln -s ${testDriver}/bin/nixos-test-driver $out/bin/nixos-test-driver

        ${testDriver}/bin/generate-driver-symbols
        ${lib.optionalString (!config.skipLint) ''
          echo "Linting test script (enable/disable: config.skipLint)"
          echo "See https://nixos.org/manual/nixos/stable/#test-opt-skipLint"

          PYFLAKES_BUILTINS="$(
            echo -n ${lib.escapeShellArg (lib.concatStringsSep "," pythonizedNames)},
            cat ${lib.escapeShellArg "driver-symbols"}
          )" ${hostPkgs.python3Packages.pyflakes}/bin/pyflakes $out/test-script
        ''}

        # set defaults through environment
        # see: ./test-driver/test-driver.py argparse implementation
        wrapProgram $out/bin/nixos-test-driver \
          --set startScripts "''${vmStartScripts[*]}" \
          --set testScript "$out/test-script" \
          --set globalTimeout "${toString config.globalTimeout}" \
          --set vlans '${toString vlans}' \
          ${lib.escapeShellArgs (
            lib.concatMap (arg: [
              "--add-flags"
              arg
            ]) config.extraDriverArgs
          )}
      '';

in
{
  options = {

    driver = mkOption {
      description = "Package containing a script that runs the test.";
      type = types.package;
      defaultText = literalMD "set by the test framework";
    };

    hostPkgs = mkOption {
      description = "Nixpkgs attrset used outside the nodes.";
      type = types.raw;
      example = lib.literalExpression ''
        import nixpkgs { inherit system config overlays; }
      '';
    };

    qemu.package = mkOption {
      description = "Which qemu package to use for the virtualisation of [{option}`nodes`](#test-opt-nodes).";
      type = types.package;
      default = hostPkgs.qemu_test;
      defaultText = "hostPkgs.qemu_test";
    };

    globalTimeout = mkOption {
      description = ''
        A global timeout for the complete test, expressed in seconds.
        Beyond that timeout, every resource will be killed and released and the test will fail.

        By default, we use a 1 hour timeout.
      '';
      type = types.int;
      default = 60 * 60;
      example = 10 * 60;
    };

    enableOCR = mkOption {
      description = ''
        Whether to enable Optical Character Recognition functionality for
        testing graphical programs. See [`Machine objects`](#ssec-machine-objects).
      '';
      type = types.bool;
      default = false;
    };

    extraPythonPackages = mkOption {
      description = ''
        Python packages to add to the test driver.

        The argument is a Python package set, similar to `pkgs.pythonPackages`.
      '';
      example = lib.literalExpression ''
        p: [ p.numpy ]
      '';
      type = types.functionTo (types.listOf types.package);
      default = ps: [ ];
    };

    extraDriverArgs = mkOption {
      description = ''
        Extra arguments to pass to the test driver.

        They become part of [{option}`driver`](#test-opt-driver) via `wrapProgram`.
      '';
      type = types.listOf types.str;
      default = [ ];
    };

    skipLint = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Do not run the linters. This may speed up your iteration cycle, but it is not something you should commit.
      '';
    };

    skipTypeCheck = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Disable type checking. This must not be enabled for new NixOS tests.

        This may speed up your iteration cycle, unless you're working on the [{option}`testScript`](#test-opt-testScript).
      '';
    };
  };

  config = {
    _module.args = {
      hostPkgs =
        # Comment is in nixos/modules/misc/nixpkgs.nix
        lib.mkOverride lib.modules.defaultOverridePriority config.hostPkgs;
    };

    driver = withChecks driver;

    # make available on the test runner
    passthru.driver = config.driver;
  };
}
