{ config, lib, hostPkgs, ... }:
let
  inherit (lib) mkOption types literalMD mdDoc;

  # Reifies and correctly wraps the python test driver for
  # the respective qemu version and with or without ocr support
  testDriver = hostPkgs.callPackage ../test-driver {
    inherit (config) enableOCR extraPythonPackages;
    qemu_pkg = config.qemu.package;
    imagemagick_light = hostPkgs.imagemagick_light.override { inherit (hostPkgs) libtiff; };
    tesseract4 = hostPkgs.tesseract4.override { enableLanguages = [ "eng" ]; };
  };


  vlans = map (m: m.virtualisation.vlans) (lib.attrValues config.nodes);
  vms = map (m: m.system.build.vm) (lib.attrValues config.nodes);

  nodeHostNames =
    let
      nodesList = map (c: c.system.name) (lib.attrValues config.nodes);
    in
    nodesList ++ lib.optional (lib.length nodesList == 1 && !lib.elem "machine" nodesList) "machine";

  # TODO: This is an implementation error and needs fixing
  # the testing famework cannot legitimately restrict hostnames further
  # beyond RFC1035
  invalidNodeNames = lib.filter
    (node: builtins.match "^[A-z_]([A-z0-9_]+)?$" node == null)
    nodeHostNames;

  uniqueVlans = lib.unique (builtins.concatLists vlans);
  vlanNames = map (i: "vlan${toString i}: VLan;") uniqueVlans;
  machineNames = map (name: "${name}: Machine;") nodeHostNames;

  withChecks =
    if lib.length invalidNodeNames > 0 then
      throw ''
        Cannot create machines out of (${lib.concatStringsSep ", " invalidNodeNames})!
        All machines are referenced as python variables in the testing framework which will break the
        script when special characters are used.

        This is an IMPLEMENTATION ERROR and needs to be fixed. Meanwhile,
        please stick to alphanumeric chars and underscores as separation.
      ''
    else
      lib.warnIf config.skipLint "Linting is disabled";

  driver =
    hostPkgs.runCommand "nixos-test-driver-${config.name}"
      {
        # inherit testName; TODO (roberth): need this?
        nativeBuildInputs = [
          hostPkgs.makeWrapper
        ] ++ lib.optionals (!config.skipTypeCheck) [ hostPkgs.mypy ];
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

          cat -n testScriptWithTypes

          mypy  --no-implicit-optional \
                --pretty \
                --no-color-output \
                testScriptWithTypes
        ''}

        echo -n "$testScript" >> $out/test-script

        ln -s ${testDriver}/bin/nixos-test-driver $out/bin/nixos-test-driver

        ${testDriver}/bin/generate-driver-symbols
        ${lib.optionalString (!config.skipLint) ''
          PYFLAKES_BUILTINS="$(
            echo -n ${lib.escapeShellArg (lib.concatStringsSep "," nodeHostNames)},
            < ${lib.escapeShellArg "driver-symbols"}
          )" ${hostPkgs.python3Packages.pyflakes}/bin/pyflakes $out/test-script
        ''}

        # set defaults through environment
        # see: ./test-driver/test-driver.py argparse implementation
        wrapProgram $out/bin/nixos-test-driver \
          --set startScripts "''${vmStartScripts[*]}" \
          --set testScript "$out/test-script" \
          --set vlans '${toString vlans}' \
          ${lib.escapeShellArgs (lib.concatMap (arg: ["--add-flags" arg]) config.extraDriverArgs)}
      '';

in
{
  options = {

    driver = mkOption {
      description = mdDoc "Package containing a script that runs the test.";
      type = types.package;
      defaultText = literalMD "set by the test framework";
    };

    hostPkgs = mkOption {
      description = mdDoc "Nixpkgs attrset used outside the nodes.";
      type = types.raw;
      example = lib.literalExpression ''
        import nixpkgs { inherit system config overlays; }
      '';
    };

    qemu.package = mkOption {
      description = mdDoc "Which qemu package to use for the virtualisation of [{option}`nodes`](#test-opt-nodes).";
      type = types.package;
      default = hostPkgs.qemu_test;
      defaultText = "hostPkgs.qemu_test";
    };

    enableOCR = mkOption {
      description = mdDoc ''
        Whether to enable Optical Character Recognition functionality for
        testing graphical programs. See [Machine objects](`ssec-machine-objects`).
      '';
      type = types.bool;
      default = false;
    };

    extraPythonPackages = mkOption {
      description = mdDoc ''
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
      description = mdDoc ''
        Extra arguments to pass to the test driver.

        They become part of [{option}`driver`](#test-opt-driver) via `wrapProgram`.
      '';
      type = types.listOf types.str;
      default = [];
    };

    skipLint = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Do not run the linters. This may speed up your iteration cycle, but it is not something you should commit.
      '';
    };

    skipTypeCheck = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Disable type checking. This must not be enabled for new NixOS tests.

        This may speed up your iteration cycle, unless you're working on the [{option}`testScript`](#test-opt-testScript).
      '';
    };
  };

  config = {
    _module.args.hostPkgs = config.hostPkgs;

    driver = withChecks driver;

    # make available on the test runner
    passthru.driver = config.driver;
  };
}
