/**
  Shared helpers for the `stdenv.mkDerivation` semantics that live
  *outside* `makeDerivationArgument`:

    - `envWithMainProgram` -- overlay `NIX_MAIN_PROGRAM` from
      `meta.mainProgram` onto the user-supplied `env` attrset
    - `validateEnv` -- assert the overlaid env is an attrset of
      scalars/derivations, doesn't collide with derivation-arg keys,
      etc.
    - `processDerivationArgs` -- the full pipeline wiring
      `envWithMainProgram`, `validateEnv`, `makeCMakeFlags`,
      `makeMesonFlags`, and the `__structuredAttrs` `env`-nesting
      dance into a single call that both `make-derivation.nix` and
      `layers.stdenvMkDerivation` delegate to.
    - `mkInputDerivation` -- the build-time-deps-only passthru used
      by `nix-build shell.nix -A inputDerivation`, stripped of
      fixed-output and output-check attrs so it always builds.
    - `fixedOutputRelatedAttrs` / `outputCheckAttrs` -- the constant
      lists of keys `mkInputDerivation` strips.
    - `makeCMakeFlags` / `makeMesonFlags` -- re-exported from the
      cross-aware helpers in `cmake.nix` / `meson.nix` so callers
      only import this one file.

  Shared between `pkgs/stdenv/generic/make-derivation.nix` (the
  legacy `stdenv.mkDerivation` code path) and
  `pkgs/build-support/package/make-package.nix`'s
  `layers.stdenvMkDerivation`, so both entry points compute the
  same thing from the same source instead of duplicating the logic.
*/
{ lib, stdenv }:

let
  inherit (import ./cmake.nix { inherit lib stdenv; }) makeCMakeFlags;
  inherit (import ./meson.nix { inherit lib stdenv; }) makeMesonFlags;
in
rec {
  inherit makeCMakeFlags makeMesonFlags;

  /**
    Given the user-supplied `env` attrset and the package's `meta`,
    return the effective env attrset with `NIX_MAIN_PROGRAM` overlaid
    from `meta.mainProgram` (if set).

    Called from `processDerivationArgs` below (and via that indirection
    from both `stdenv.mkDerivation` and `layers.stdenvMkDerivation`),
    and also exposed directly so callers that don't want the rest of
    the processing pipeline can compute just the overlay.
  */
  envWithMainProgram =
    {
      env ? { },
      meta ? { },
    }:
    env
    // lib.optionalAttrs (meta.mainProgram or null != null) {
      NIX_MAIN_PROGRAM = meta.mainProgram;
    };

  /**
    Validate the effective `env` attrset for a stdenv.mkDerivation-
    style package. Three checks, matching upstream `make-derivation.nix`'s
    `checkedEnv` block:

    1. The raw user-supplied `env` must be an attrset and not a
       derivation. Guards against `env = someDerivation` mistakes
       where the user forgot to nest.
    2. The overlaid env (with NIX_MAIN_PROGRAM) must not collide
       with any key in the derivation-arg attrset.
    3. Each value must be a scalar (string / bool / int) or a
       derivation; other types (attrsets, lists, functions) don't
       make sense as environment variables.

    Returns the overlaid env on success. Takes:

      - `env`: raw user-supplied env attrset (pre-overlay)
      - `overlaidEnv`: env with NIX_MAIN_PROGRAM overlaid, as returned
        by `envWithMainProgram`
      - `derivationArgs`: the derivation-arg attrset to check for
        overlap, i.e. everything else passed to the final
        `derivation` call
  */
  validateEnv =
    {
      env,
      overlaidEnv,
      derivationArgs ? { },
    }:
    let
      overlappingNames = builtins.attrNames (builtins.intersectAttrs overlaidEnv derivationArgs);
      prettyPrint = lib.generators.toPretty { };
      makeError =
        name:
        "  - ${name}: in `env`: ${prettyPrint overlaidEnv.${name}}; in derivation arguments: ${
            prettyPrint derivationArgs.${name}
          }";
      errors = lib.concatMapStringsSep "\n" makeError overlappingNames;
    in
    assert lib.assertMsg (lib.isAttrs env && !lib.isDerivation env)
      "`env` must be an attribute set of environment variables. Set `env.env` or pick a more specific name.";
    assert lib.assertMsg (overlappingNames == [ ])
      "The `env` attribute set cannot contain any attributes passed to derivation. The following attributes are overlapping:\n${errors}";
    lib.mapAttrs (
      n: v:
      assert lib.assertMsg (lib.isString v || lib.isBool v || lib.isInt v || lib.isDerivation v)
        "The `env` attribute set can only contain derivation, string, boolean or integer attributes. The `${n}` attribute is of type ${builtins.typeOf v}.";
      v
    ) overlaidEnv;

  /**
    Derivation-arg keys that make a derivation fixed-output. Stripped
    from `derivationArg` when computing `inputDerivation`, since the
    inputDerivation intentionally is *not* fixed-output.
  */
  fixedOutputRelatedAttrs = [
    "outputHashAlgo"
    "outputHash"
    "outputHashMode"
  ];

  /**
    Derivation-arg keys that describe runtime output checks. Stripped
    from `derivationArg` when computing `inputDerivation`, since the
    inputDerivation produces the *inputs*, so restrictions that were
    meant for the outputs no longer serve a purpose.
  */
  outputCheckAttrs = [
    "allowedReferences"
    "allowedRequisites"
    "disallowedReferences"
    "disallowedRequisites"
    "outputChecks"
  ];

  /**
    Build an `inputDerivation` passthru: a derivation that always
    builds successfully and whose runtime dependencies are the
    original derivation's *build-time* dependencies. Used by
    e.g. `nix-build shell.nix -A inputDerivation` to pre-fetch
    everything needed to enter a `nix-shell` without actually
    building the package.

    Takes:

      - `derivationArg`: the pre-merge (without `checkedEnv`)
        derivation-arg attrset as returned by
        `processDerivationArgs`
      - `stdenvShell`: the shell the inputDerivation builder runs
        under, typically `stdenv.shell`

    Returns a plain derivation (not a package attrset).
  */
  mkInputDerivation =
    {
      derivationArg,
      stdenvShell,
    }:
    derivation (
      (builtins.removeAttrs derivationArg (fixedOutputRelatedAttrs ++ outputCheckAttrs))
      // {
        # Add a name in case the original drv didn't have one
        name = "inputDerivation" + lib.optionalString (derivationArg ? name) "-${derivationArg.name}";
        # This always only has one output
        outputs = [ "out" ];
        # This doesn't require any system features even if the
        # original derivation did.
        requiredSystemFeatures = [ ];

        # Propagate the original builder and arguments, since we
        # override them and they might contain references to build
        # inputs
        _derivation_original_builder = derivationArg.builder;
        _derivation_original_args = derivationArg.args;

        builder = stdenvShell;
        # The builtin `declare -p` dumps all bash and environment
        # variables, which is where all build input references end up
        # (e.g. $PATH for binaries). By writing this to $out, Nix can
        # find and register them as runtime dependencies (since Nix
        # greps for store paths through $out to find them). Using
        # placeholder for $out works with and without
        # structuredAttrs. This build script does not use setup.sh or
        # stdenv, to keep the env most pristine.
        args = [
          "-c"
          ''
            out="${builtins.placeholder "out"}"
            if [ -e "$NIX_ATTRS_SH_FILE" ]; then . "$NIX_ATTRS_SH_FILE"; fi
            declare -p > $out
            for var in $passAsFile; do
                pathVar="''${var}Path"
                printf "%s" "$(< "''${!pathVar}")" >> $out
            done
          ''
        ];
      }
    );

  /**
    The full "process a stdenv.mkDerivation attrset into a ready-to-
    call `derivation` argument set" pipeline: env extraction with
    NIX_MAIN_PROGRAM overlay, cmake/meson flag computation,
    optionally-nested `structuredAttrs.env`, and env validation.

    Both `pkgs/stdenv/generic/make-derivation.nix`'s `derivationArg`
    let-binding and `layers.stdenvMkDerivation`'s `drvAttrs`
    computation are now thin wrappers around this one.

    Takes:

      - `stdenvArgs`: the attrs to feed into `derivation`, minus
        `meta` / `passthru` / `pos`. May contain `env = { ... }`.
      - `meta`: package meta attrset (only read for `mainProgram`).
      - `makeDerivationArgument`: stdenv's `makeDerivationArgument`
        function, passed in because the helper itself has no stdenv
        of its own.

    Returns `{ derivationArg, checkedEnv }` where the final
    derivation is computed as `derivation (derivationArg // checkedEnv)`
    (non-structured-attrs mode) or any equivalent rearrangement
    (structured mode, where `env` is additionally carried as a nested
    key inside `derivationArg`).
  */
  processDerivationArgs =
    {
      stdenvArgs,
      meta ? { },
      makeDerivationArgument,
    }:
    let
      env = stdenvArgs.env or { };
      __structuredAttrs = stdenvArgs.__structuredAttrs or false;
      overlaidEnv = envWithMainProgram { inherit env meta; };
      derivationArg = makeDerivationArgument (
        (builtins.removeAttrs stdenvArgs [ "env" ])
        // lib.optionalAttrs __structuredAttrs { env = checkedEnv; }
        // {
          cmakeFlags = makeCMakeFlags stdenvArgs;
          mesonFlags = makeMesonFlags stdenvArgs;
        }
      );
      checkedEnv = validateEnv {
        inherit env overlaidEnv;
        derivationArgs = derivationArg;
      };
    in
    {
      inherit derivationArg checkedEnv;
    };
}
