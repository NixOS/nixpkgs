{
  config,
  lib,
  hostPkgs,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    literalExpression
    literalMD
    ;

  inherit (hostPkgs.stdenv.hostPlatform) isLinux isx86_64;

  machines = config.machines;
in
{
  options = {
    name = mkOption {
      description = "The name of the test, used in derivation names.";
      type = types.str;
    };

    machines = mkOption {
      description = ''
        The virtual machines to boot, keyed by the name a test script uses to
        refer to them.

        A test with exactly one machine can also refer to it as `machine`.
      '';
      type = types.lazyAttrsOf (
        types.submodule (
          { name, ... }:
          {
            _file = "pkgs/build-support/testers/vm-test/machine-options.nix";
            imports = [ ./machine-options.nix ];
            config.name = name;
          }
        )
      );
      default = { };
      example = literalExpression ''
        {
          server.image = pkgs.arch-cloud-image;
        }
      '';
    };

    testScript = mkOption {
      description = ''
        A Python coroutine body that drives the machines.

        The top level is async using `asyncio`.

        ```python
        await machine.wait_for_unit("sshd.service")
        out = await machine.succeed("cat /etc/os-release")
        ```

        See the `Machine` object documentation in the `image-test-driver`
        package for the full API.
      '';
      type = types.lines;
    };

    testScriptString = mkOption {
      description = "The resolved test script.";
      internal = true;
      readOnly = true;
      default =
        if config.testScriptFile != null then
          builtins.readFile config.testScriptFile
        else
          config.testScript;
      defaultText = literalMD "`testScriptFile` if set, otherwise `testScript`.";
      type = types.lines;
    };

    testScriptFile = mkOption {
      description = ''
        Like [`testScript`](#test-opt-testScript), but read from a file.
      '';
      type = types.nullOr types.path;
      default = null;
    };

    globalTimeout = mkOption {
      description = ''
        A deadline for the whole test, in seconds.
      '';
      type = types.ints.positive;
      default = 1800;
      example = 600;
    };

    driver = mkOption {
      description = "The driver package that runs the test.";
      type = types.package;
      default = hostPkgs.image-test-driver;
      defaultText = literalExpression "hostPkgs.image-test-driver";
    };

    driverConfiguration = mkOption {
      description = "The configuration handed to the driver.";
      internal = true;
      type = types.raw;
    };

    driverConfigurationFile = mkOption {
      description = "The driver configuration, serialized.";
      internal = true;
      type = types.path;
    };

    rawTestDerivation = mkOption {
      description = ''
        The test before `meta` and `passthru` are attached.

        Not intended for general use; use [`test`](#test-opt-test) instead.
      '';
      internal = true;
      type = types.package;
    };

    test = mkOption {
      description = "The derivation that runs the test.";
      type = types.package;
    };

    meta = mkOption {
      description = ''
        `meta` attributes for the returned derivation.
      '';
      type = types.submodule {
        options = {
          maintainers = mkOption {
            type = types.listOf types.raw;
            default = [ ];
            description = "The maintainers of this test.";
          };
          teams = mkOption {
            type = types.listOf types.raw;
            default = [ ];
            description = "The maintainer teams of this test.";
          };
          timeout = mkOption {
            description = "";
            type = types.ints.positive;
            default = 1800;
          };
          broken = mkOption {
            type = types.bool;
            default = false;
          };
          platforms = mkOption {
            description = ''
              Platforms the test can run on.
            '';
            type = types.listOf types.raw;
            default = lib.platforms.linux;
          };
          hydraPlatforms = mkOption {
            description = ''
              Platforms Hydra should build this test on.

              Defaults to nothing for now.
            '';
            type = types.listOf types.raw;
            default = [ ];
          };
        };
      };
      default = { };
    };

    skipLint = mkOption {
      description = ''
        Do not lint the test script.

        Do not commit a `skipLint` test, it's useful for development.
      '';
      type = types.bool;
      default = false;
    };

    skipTypeCheck = mkOption {
      description = ''
        Do not type check the test script.

        Do not commit a `skipTypeCheck` test, it's useful for development.
      '';
      type = types.bool;
      default = false;
    };

    requiredFeatures = mkOption {
      description = "Builder features this test needs.";
      type = types.submodule {
        options.kvm = mkOption {
          type = types.bool;
          default = isLinux && machines != { };
          defaultText = literalMD "`true` when running on Linux with any machines defined.";
          description = "Whether KVM is required.";
        };
      };
      default = { };
    };

    passthru = mkOption {
      description = "Extra attributes for consumers of the test derivation.";
      type = types.lazyAttrsOf types.raw;
      default = { };
    };
  };

  imports = [
    # `assertions` is generic to the module system, not specific to NixOS.
    ../../../../lib/modules/generic/assertions.nix
  ];

  config = {
    assertions = [
      {
        assertion = config.testScript != "" || config.testScriptFile != null;
        message = "`testScript` or `testScriptFile` must be set.";
      }
      {
        # test.thing hardcodes `-machine q35,accel=kvm` plus x86 OVMF.
        assertion = !isLinux || isx86_64 || machines == { };
        message = ''
          Image tests currently only know how to boot an x86_64 guest.
        '';
      }
    ];

    driverConfiguration = {
      machines = lib.mapAttrs (_: machine: machine.driverConfiguration) machines;
      global_timeout = config.globalTimeout;
      test_script = hostPkgs.writeText "test-script" config.testScriptString;
    };

    driverConfigurationFile = hostPkgs.writers.writeJSON "driver-configuration.json" config.driverConfiguration;

    rawTestDerivation = hostPkgs.stdenvNoCC.mkDerivation {
      name = "image-test-run-${config.name}";
      requiredSystemFeatures = lib.attrNames (
        lib.filterAttrs (_: enabled: enabled) config.requiredFeatures
      );
      meta = {
        inherit (config.meta)
          maintainers
          teams
          timeout
          broken
          ;
        platforms = config.meta.platforms;
        hydraPlatforms = config.meta.hydraPlatforms;
      };
      nativeBuildInputs =
        config.driver.passthru.runtimeDependencies or [ ]
        ++ lib.optionals (!config.skipLint) [ hostPkgs.ruff ]
        ++ lib.optionals (!config.skipTypeCheck) [
          hostPkgs.ty
          hostPkgs.python3
        ];

      buildCommand = ''
        mkdir -p $out

        ${lib.optionalString (!config.skipTypeCheck || !config.skipLint) ''
          python3 ${./prepare-typecheck.py} \
            ${./test-script-prepend.py} \
            ${config.driverConfiguration.test_script} \
            test-script-with-types
        ''}

        ${lib.optionalString (!config.skipTypeCheck) ''
          ty check \
            --python "${hostPkgs.python3.interpreter}" \
            --extra-search-path "${config.driver}/${hostPkgs.python3.sitePackages}" \
            test-script-with-types
        ''}

        ${lib.optionalString (!config.skipLint) ''
          echo "Linting the test script (disable with skipLint)"
          ruff check --select F test-script-with-types
        ''}

        ${lib.getExe config.driver} \
          --config ${config.driverConfigurationFile} \
          --log-level info \
          -o $out
      '';
    };

    passthru = {
      inherit (config) driverConfiguration;

      driverInteractive = hostPkgs.writeShellScriptBin "image-test-interactive-${config.name}" ''
        exec ${lib.getExe config.driver} \
          --config ${config.driverConfigurationFile} \
          --log-level info \
          --interactive \
          -o "$PWD"
      '';
    };

    test = config.rawTestDerivation.overrideAttrs (previous: {
      passthru = (previous.passthru or { }) // config.passthru;
    });
  };
}
