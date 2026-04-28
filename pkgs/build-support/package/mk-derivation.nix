/**
  Experimental: rebase the `mkDerivation` interface on top of `mkPackage`.

  This reimplements a meaningful subset of `stdenv.mkDerivation`'s interface
  as a thin shim over `mkPackage`, demonstrating that the single-fixpoint
  package model can express the legacy interface.

  The heavy lifting (env / `__structuredAttrs` / cmakeFlags / mesonFlags /
  NIX_MAIN_PROGRAM / commonMeta enrichment) lives in
  `layers.stdenvMkDerivation`. This file is just the legacy-argument-shape
  adapter: it parses the `argsOrFn` that mkDerivation callers pass,
  wires up `finalAttrs`, and forwards everything else through stdenvArgs.

  What is supported:

  - Plain attrset form: `mkDerivationAsPackage stdenv { pname = "foo"; ... }`
  - Fixed-point form:   `mkDerivationAsPackage stdenv (finalAttrs: { ... })`
  - `pname` / `version` / `name`
  - `passthru`           (merged into `public`, and exposed under `.passthru`)
  - `meta` (with `meta.mainProgram` becoming `NIX_MAIN_PROGRAM` env injection,
    handled by `layers.stdenvMkDerivation`)
  - `env = { ... }` in both non-structured-attrs and
    `__structuredAttrs = true` modes (handled by
    `layers.stdenvMkDerivation`)
  - `finalAttrs.finalPackage`, referencing the fully-realized package attrset
  - `.overrideAttrs` in all three legacy shapes (plain attrset,
    `prev: { ... }`, and `final: prev: { ... }`) with drvPath parity
    against `stdenv.mkDerivation`, inherited from mkPackage's
    `overrideAttrs` which dispatches through `lib.toExtension`.
  - All other attributes are forwarded to `stdenvArgs` (i.e. passed to
    `stdenv.makeDerivationArgument`), matching mkDerivation's "everything else
    goes to the derivation" behaviour.

  What is not (yet) supported:

  - Per-output reference hygiene beyond what `layers.stdenvMkDerivation`
    already does

  Because the heavy lifting lives in `layers.stdenvMkDerivation`,
  calling `mkDerivationAsPackage stdenv attrs` produces a drvPath
  bit-identical to `stdenv.mkDerivation attrs` for every shape the
  `tests.mk-derivation-as-package` regression suite covers (plain
  attrset, `finalAttrs:` fixed-point, name-only, buildInputs, env,
  `__structuredAttrs = true`, legacy `.overrideAttrs` call shapes,
  fixed-output, multi-output, and `inputDerivation`).
*/
{
  lib,
  mkPackage,
}:

stdenv: argsOrFn:
let
  asFun = if lib.isFunction argsOrFn then argsOrFn else (_: argsOrFn);

  reserved = [
    "pname"
    "version"
    "name"
    "passthru"
    "meta"
  ];
in
mkPackage (
  { layers, ... }:
  [
    (layers.stdenvMkDerivation { inherit stdenv; })
    (
      this: old:
      let
        # Legacy mkDerivation resolves `finalAttrs` via its own fixpoint
        # over the attrset itself, independent of the outer package layer
        # fixpoint. Mirror that so `finalAttrs.version` (and friends) are
        # readable from inside the user's function without tripping the
        # outer fixpoint (which only sees `version` *after* we've set it).
        attrs = lib.fix (finalAttrs: asFun (finalAttrs // { finalPackage = this.public; }));
        passthru = attrs.passthru or { };
        meta = attrs.meta or { };
        forwarded = builtins.removeAttrs attrs reserved;
      in
      {
        # `layers.stdenvMkDerivation` (like `layers.derivation`)
        # reconstructs `pname` from `this.name` when `this ? version`,
        # so store the bare pname here rather than the conventional
        # "${pname}-${version}" full name.
        name =
          if attrs ? name then
            attrs.name
          else
            attrs.pname or (throw "mkDerivationAsPackage: need name or pname");
      }
      // lib.optionalAttrs (attrs ? version) {
        inherit (attrs) version;
      }
      // {
        # Forward everything that isn't a mkPackage-level concern
        # (name / version / passthru / meta) into stdenvArgs. env,
        # cmakeFlags, mesonFlags, __structuredAttrs etc. are all just
        # regular stdenvArgs keys; `layers.stdenvMkDerivation` is what
        # gives them their special treatment.
        stdenvArgs = old.stdenvArgs or { } // forwarded;
        inherit meta;
        public =
          old.public
          // passthru
          // {
            inherit passthru;
          }
          // lib.optionalAttrs (attrs ? version) {
            # Legacy mkDerivation exposes `name = "${pname}-${version}"`
            # on the public package attrset. The package layer stores
            # bare pname in `this.name` (see note on the `name`
            # attribute above), so restore the conventional full name
            # for the public surface.
            name = "${attrs.pname}-${attrs.version}";
          };
      }
    )
  ]
)
