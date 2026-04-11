/**
  Helpers for the three `stdenv.mkDerivation` semantics that live
  *outside* `makeDerivationArgument` -- re-exported from the cross-aware
  cmake / meson helpers, plus a tiny `envWithMainProgram` that bakes
  `meta.mainProgram` into `NIX_MAIN_PROGRAM`.

  Shared between `pkgs/stdenv/generic/make-derivation.nix` (the legacy
  `stdenv.mkDerivation` code path) and
  `pkgs/build-support/package/make-package.nix`'s
  `layers.stdenvMkDerivation`, so both entry points compute the same
  thing from the same source instead of duplicating the logic.
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

    Both `stdenv.mkDerivation`'s internal `env'` and
    `layers.stdenvMkDerivation`'s `envAttrs` are exactly this
    computation.
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
        "  - ${name}: in `env`: ${prettyPrint overlaidEnv.${name}}; in derivation arguments: ${prettyPrint derivationArgs.${name}}";
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
