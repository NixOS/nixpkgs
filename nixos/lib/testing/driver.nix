{
  config,
  lib,
  hostPkgs,
  ...
}:
let
  inherit (lib) mkOption types literalMD;

  inherit (config) sshBackdoor;

  inherit (hostPkgs.stdenv.hostPlatform) isLinux;

  # Reifies and correctly wraps the python test driver for
  # the respective qemu version and with or without ocr support
  testDriver = config.pythonTestDriverPackage.override {
    inherit (config) enableOCR extraPythonPackages;
    qemu_pkg = config.qemu.package;
    enableNspawn = config.containers != { };
  };

  pythonizeName =
    name:
    let
      head = lib.substring 0 1 name;
      tail = lib.substring 1 (-1) name;
    in
    (if builtins.match "[A-z_]" head == null then "_" else head)
    + lib.stringAsChars (c: if builtins.match "[A-z0-9_]" c == null then "_" else c) tail;

  vlanTypeHints = lib.strings.concatMapStringsSep "\n" (
    i: "vlan${toString i}: VLan"
  ) config.driverConfiguration.vlans;

  vmMachineNames = lib.attrNames config.driverConfiguration.vms;
  containerMachineNames = lib.attrNames config.driverConfiguration.containers;

  theOnlyMachine =
    let
      exactlyOneMachine = lib.length (lib.attrValues config.nodes) == 1;
      allMachineNames = map (c: c.system.name) (lib.attrValues config.allMachines);
    in
    lib.optional (exactlyOneMachine && !lib.elem "machine" allMachineNames) "machine";

  pythonizedVmNames = map pythonizeName (vmMachineNames ++ theOnlyMachine);
  vmMachineTypeHints = map (name: "${name}: QemuMachine;") pythonizedVmNames;

  pythonizedContainerNames = map pythonizeName containerMachineNames;
  containerMachineTypeHints = map (name: "${name}: NspawnMachine;") pythonizedContainerNames;

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

        ${lib.optionalString (!config.skipTypeCheck) ''
          # prepend type hints so the test script can be type checked with mypy

          cat "${../test-script-prepend.py}" >> testScriptWithTypes
          echo "${toString vmMachineTypeHints}" >> testScriptWithTypes
          echo "${toString containerMachineTypeHints}" >> testScriptWithTypes
          echo "${toString vlanTypeHints}" >> testScriptWithTypes
          echo -n "$testScript" >> testScriptWithTypes

          echo "Running type check (enable/disable: config.skipTypeCheck)"
          echo "See https://nixos.org/manual/nixos/stable/#test-opt-skipTypeCheck"

          mypy  --no-implicit-optional \
                --pretty \
                --no-color-output \
                testScriptWithTypes
        ''}

        echo -n "$testScript" > testScriptFile

        cp "${config.driverConfiguration.test_script}" $out/test-script

        ln -s ${testDriver}/bin/nixos-test-driver $out/bin/nixos-test-driver

        ${testDriver}/bin/generate-driver-symbols
        ${lib.optionalString (!config.skipLint) ''
          echo "Linting test script (enable/disable: config.skipLint)"
          echo "See https://nixos.org/manual/nixos/stable/#test-opt-skipLint"

          PYFLAKES_BUILTINS="$(
            echo -n ${
              lib.escapeShellArg (lib.concatStringsSep "," (pythonizedVmNames ++ pythonizedContainerNames))
            },
            cat ${lib.escapeShellArg "driver-symbols"}
          )" ${hostPkgs.python3Packages.pyflakes}/bin/pyflakes $out/test-script
        ''}

        wrapProgram $out/bin/nixos-test-driver \
          --add-flags "--config ${config.driverConfigurationFile}" \
          --add-flags "--log-level ${config.logLevel}" \
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
    pythonTestDriverPackage = mkOption {
      description = "Package containing the python NixOS test driver implemetnation";
      type = types.package;
      default = hostPkgs.nixos-test-driver;
      readOnly = true;
    };

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

    qemu.forceAccel = mkOption {
      description = ''
        Whether to force the use of hardware-accelerated virtualisation.
        When enabled, QEMU will not fall back to the slower software emulation
        (TCG) and will instead error out if the accelerator is not available.
      '';
      type = types.bool;
      default = false;
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

    logLevel = mkOption {
      description = "Log level for the test driver.";
      type = types.enum [
        "debug"
        "info"
        "warning"
        "error"
      ];
      default = "info";
      example = "warning";
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

    nodeDefaults =
      { config, ... }:
      {
        # This is needed for the SSH backdoor to function.
        # Set this to `true` by default to not change essential QEMU flags
        # depending on whether debugging is enabled.
        #
        # If needed, this can still be turned off.
        virtualisation.qemu.enableSharedMemory = lib.mkDefault isLinux;

        assertions = [
          {
            assertion = sshBackdoor.enable -> config.virtualisation.qemu.enableSharedMemory;
            message = ''
              When turning on the SSH backdoor of the NixOS test-framework,
              `virtualisation.qemu.enableSharedMemory` MUST be `true`
              (affected: ${config.networking.hostName}).
            '';
          }
        ];
      };
  };
}
