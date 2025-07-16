{
  config,
  hostPkgs,
  lib,
  options,
  ...
}:
let
  inherit (lib) types mkOption;

  # TODO (lib): Also use lib equivalent in nodes.nix
  /**
    Create a module system definition that overrides an existing option from a different module evaluation.

    Type: Option a -> (a -> a) -> Definition a
  */
  mkOneUp =
    /**
      Option from an existing module evaluation, e.g.
      - `(lib.evalModules ...).options.x` when invoking `evalModules` again,
      - or `{ options, ... }:` when invoking `extendModules`.
    */
    opt:
    /**
      Function from the old value to the new definition, which will be wrapped with `mkOverride`.
    */
    f:
    lib.mkOverride (opt.highestPrio - 1) (f opt.value);

in
{
  options = {
    passthru = mkOption {
      type = types.lazyAttrsOf types.raw;
      description = ''
        Attributes to add to the returned derivations,
        which are not necessarily part of the build.

        This is a bit like doing `drv // { myAttr = true; }` (which would be lost by `overrideAttrs`).
        It does not change the actual derivation, but adds the attribute nonetheless, so that
        consumers of what would be `drv` have more information.
      '';
    };

    rawTestDerivation = mkOption {
      type = types.package;
      description = ''
        Unfiltered version of `test`, for troubleshooting the test framework and `testBuildFailure` in the test framework's test suite.
        This is not intended for general use. Use `test` instead.
      '';
      internal = true;
    };

    rawTestDerivationArg = mkOption {
      type = types.functionTo types.raw;
      description = ''
        Argument passed to `mkDerivation` to create the `rawTestDerivation`.
      '';
    };

    test = mkOption {
      type = types.package;
      # TODO: can the interactive driver be configured to access the network?
      description = ''
        Derivation that runs the test as its "build" process.

        This implies that NixOS tests run isolated from the network, making them
        more dependable.
      '';
    };
  };

  config = {
    rawTestDerivation = hostPkgs.stdenv.mkDerivation config.rawTestDerivationArg;
    rawTestDerivationArg =
      finalAttrs:
      assert lib.assertMsg (!config.sshBackdoor.enable)
        "The SSH backdoor is currently not supported for non-interactive testing! Please make sure to only set `interactive.sshBackdoor.enable = true;`!";
      {
        name = "vm-test-run-${config.name}";

        requiredSystemFeatures =
          [ "nixos-test" ]
          ++ lib.optionals hostPkgs.stdenv.hostPlatform.isLinux [ "kvm" ]
          ++ lib.optionals hostPkgs.stdenv.hostPlatform.isDarwin [ "apple-virt" ];

        buildCommand = ''
          mkdir -p $out

          # effectively mute the XMLLogger
          export LOGFILE=/dev/null

          ${config.driver}/bin/nixos-test-driver -o $out
        '';

        passthru = config.passthru;

        meta = config.meta;
      };
    test = lib.lazyDerivation {
      # lazyDerivation improves performance when only passthru items and/or meta are used.
      derivation = config.rawTestDerivation;
      inherit (config) passthru meta;
    };

    # useful for inspection (debugging / exploration)
    passthru.config = config;

    /**
      For discoverTests only. Deprecated. Will be removed when discoverTests can be removed from NixOS all-tests.nix.
    */
    passthru.test = config.test;

    # Docs: nixos/doc/manual/development/writing-nixos-tests.section.md
    /**
      See https://nixos.org/manual/nixos/unstable#sec-override-nixos-test
    */
    passthru.overrideTestDerivation =
      f:
      config.passthru.extend {
        modules = [
          {
            rawTestDerivationArg = mkOneUp options.rawTestDerivationArg (lib.extends (lib.toExtension f));
          }
        ];
      };
  };
}
