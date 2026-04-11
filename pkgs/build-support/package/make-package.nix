{
  lib,
  callPackage,
  stdenv,
  config,
  ...
}:
let
  checkMeta = import ../../stdenv/generic/check-meta.nix {
    inherit lib config;
    # Nix itself uses the `system` field of a derivation to decide where
    # to build it. This is a bit confusing for cross compilation.
    inherit (stdenv) hostPlatform;
  };

  baseLayer = this: rec {
    pos = builtins.unsafeGetAttrPos "name" this;

    # The "base" override-attrs callable. Always refers to the
    # baseLayer-defined version (never to whatever a user
    # `passthru.overrideAttrs = ...` install may have written to
    # `public.overrideAttrs`). `overrideAttrs` exposed below uses
    # this for its `self.overrideAttrs`, mirroring how legacy
    # `stdenv.mkDerivation`'s `lib.fix`-based `selfAttrs.overrideAttrs`
    # is the let-binding's freshly-defined function rather than the
    # user-overridden one. Without this separation, entangled-style
    # passthru chains (`addEntangled self.overrideAttrs`) loop on
    # themselves.
    baseOverrideAttrs =
      f:
      this.extend (
        this: old:
        let
          # Read name / pname / version directly off the layer
          # state (`src` = prior layer `old` / the new `this`) rather
          # than from `src.public`. Layers that merge `this.stdenvArgs`
          # into their `public` (e.g. `layers.stdenvMkDerivation`)
          # otherwise create a cycle here when the user installs
          # an entangled override: reading `src.public.name` would
          # force `this.stdenvArgs`, which in turn depends on the
          # overlay this very `attrsView` is being computed for.
          # `name` / `version` are set top-level on `this` by the
          # user layer; `pname` is seeded here from `src.name` when
          # a version is present, mirroring baseLayer's public
          # surface.
          attrsView =
            src:
            (src.stdenvArgs or { })
            // lib.optionalAttrs (src ? version) {
              pname = src.name;
              inherit (src) version;
            }
            // lib.optionalAttrs (src ? name) {
              inherit (src) name;
            }
            // {
              passthru = src.public.passthru or { };
              meta = src.meta or { };
            };
          prevView = attrsView old;
          finalView = attrsView this // {
            finalPackage = this.public;
            # Expose the *base* overrideAttrs as `self.overrideAttrs`,
            # not `this.public.overrideAttrs` (which the user may
            # have overridden via `passthru.overrideAttrs`).
            overrideAttrs = this.baseOverrideAttrs;
          };
          overlay = (lib.toExtension f) finalView prevView;
          hasPassthru = overlay ? passthru;
          hasMeta = overlay ? meta;
          overlayStdenvArgs = builtins.removeAttrs overlay [
            "passthru"
            "meta"
          ];
        in
        {
          stdenvArgs = old.stdenvArgs or { } // overlayStdenvArgs;
          public =
            old.public
            // overlayStdenvArgs
            // lib.optionalAttrs hasPassthru (
              overlay.passthru
              // {
                passthru = old.public.passthru or { } // overlay.passthru;
              }
            );
        }
        // lib.optionalAttrs hasMeta {
          meta = overlay.meta;
        }
      );

    # In the repl, use :p pkg.help
    # Since https://github.com/NixOS/nix/pull/10208
    help =
      if this.deps == { } then
        ''
          # Overriding dependencies

          This package does not have overridable dependencies using the .override attribute.

        ''
      else
        ''
          # Overriding dependencies

          This package allows its dependencies to be overridden, using the .override
          attribute. For example:

              pkg.override (old: { dep = f old.dep; })

          Instead of dep, you may set the following attributes:

              ${lib.concatMapStringsSep ", " lib.strings.escapeNixIdentifier (lib.attrNames this.deps)}
        '';

    deps = { };

    # Default to an empty meta so packages that don't set one (e.g.
    # pure `mkPackage` usages without a derivation layer) don't crash
    # when `public.meta` is read.
    meta = { };

    public =
      builtins.intersectAttrs {
        tests = null;
        version = null;
      } this
      # When the package has `version`, mkPackage stores the bare
      # pname in `this.name`. Seed `pname` on public from there so
      # `pkg.pname` matches `stdenv.mkDerivation`'s public surface.
      # Reading `this.name` is safe (it's set by the user-layer and
      # not by override layers, so no fixpoint cycle).
      // lib.optionalAttrs (this ? version) {
        pname = this.name;
      }
      // {
        /*
          The marker for a [package attribute set](https://nixos.org/manual/nix/stable/glossary.html#package-attribute-set).
          The value is "derivation" for historical reasons.
        */
        type = "derivation";

        # Plain pass-through. `layers.derivation` (or any other layer
        # that produces an actual derivation) is expected to replace
        # this with the commonMeta-processed version on its own
        # `old.public`.
        inherit (this) meta;

        inherit (this) help name;

        override =
          f:
          this.extend (
            this: old: {
              deps = old.deps // f old.deps;
            }
          );

        internals = this;

        # User-facing override hook. Initially equal to
        # `baseOverrideAttrs`. User-installed wrappers (e.g.
        # `passthru.overrideAttrs = addEntangled self.overrideAttrs`)
        # propagate to `public.overrideAttrs` via the override
        # implementation's `// overlay.passthru` flow, but
        # `self.overrideAttrs` stays bound to `baseOverrideAttrs`
        # to avoid the self-loop legacy mkDerivation also avoids
        # via its `lib.fix`-based let-binding.
        overrideAttrs = baseOverrideAttrs;
      };
  };

  layers.derivation =
    { stdenv, ... }:
    this: old:
    let
      outputs = lib.genAttrs (this.drvAttrs.outputs) (
        outputName:
        this.public
        // {
          outPath =
            assert this.validity.handled;
            this.drvOutAttrs.${outputName};
          inherit outputName;
          outputSpecified = true;
        }
      );

      # checkMeta's view of the package: raw derivation args plus
      # whatever `meta` the package set. Shared by both `validity`
      # and the enriched `public.meta` below.
      checkedAttrs = this.drvAttrs // { inherit (this) meta; };
    in
    {
      # Moved out of `baseLayer`: both `validity` and the commonMeta
      # enrichment of `public.meta` fundamentally reference `drvAttrs`,
      # which is populated *by this layer*. Keeping them here means
      # packages built without a derivation layer (or with a future
      # multi-derivation / RFC 92 dynamic-derivation layer) don't trip
      # on a missing `drvAttrs` just to compute meta.
      validity = checkMeta.assertValidity {
        inherit (this.public) meta;
        attrs = checkedAttrs;
      };
      drvAttrs = stdenv.makeDerivationArgument (
        (
          if this ? version then
            {
              pname = this.name;
              inherit (this) version;
            }
          else
            {
              inherit (this) name;
            }
        )
        // this.stdenvArgs
      );
      drvOutAttrs = builtins.derivationStrict this.drvAttrs;
      public =
        old.public
        // {
          meta = checkMeta.commonMeta {
            inherit (this) validity pos;
            attrs = checkedAttrs;
            references =
              this.drvAttrs.nativeBuildInputs or [ ]
              ++ this.drvAttrs.buildInputs or [ ]
              ++ this.drvAttrs.propagatedNativeBuildInputs or [ ]
              ++ this.drvAttrs.propagatedBuildInputs or [ ];
          };
        }
        // rec {
          outPath =
            assert this.validity.handled;
            this.drvOutAttrs.${outputName};
          outputName = lib.head this.drvAttrs.outputs;
          # legacy attribute for single-drv packages
          drvPath =
            assert this.validity.handled;
            this.drvOutAttrs.drvPath;
        }
        // outputs;
    };

  /**
    A native `mkPackage` layer that implements the full
    `stdenv.mkDerivation` surface: it extends `layers.derivation`
    (name / version wiring, `drvAttrs` via `makeDerivationArgument`,
    `drvOutAttrs`, `validity`, commonMeta, per-output attrsets) with
    the three semantics that live *outside* `makeDerivationArgument`
    in upstream `make-derivation.nix`:

      - `env = { ... }` extraction: top-level merge, plus nested
        `structuredAttrs.env` under `__structuredAttrs = true`
      - `cmakeFlags` / `mesonFlags` computation, including cross-
        compilation flags from `pkgs/build-support/lib/cmake.nix`
        and `pkgs/build-support/lib/meson.nix`
      - `NIX_MAIN_PROGRAM` injection from `meta.mainProgram`

    Historically these were hand-rolled inside `mk-derivation.nix`,
    which meant every package using `mkPackage` directly had to
    reimplement them (or miss them entirely; cf. the pre-refactor
    hello package, which set `env = { ... }` at the layer level
    where nothing read it).

    Use this layer instead of `layers.derivation` when you want full
    `stdenv.mkDerivation` semantics. `mkDerivationAsPackage` is built
    on top of it. `layers.derivation` stays as a minimal alternative
    for packages that want just the bare `makeDerivationArgument`
    pipeline without the mkDerivation extras.
  */
  layers.stdenvMkDerivation =
    { stdenv, ... }:
    let
      inherit (import ../lib/mk-derivation-extras.nix { inherit lib stdenv; })
        processDerivationArgs
        ;
    in
    this: old:
    let
      outputs = lib.genAttrs (this.drvAttrs.outputs) (
        outputName:
        this.public
        // {
          outPath =
            assert this.validity.handled;
            this.drvOutAttrs.${outputName};
          inherit outputName;
          outputSpecified = true;
        }
      );

      # The name / pname / version injection that `stdenv.mkDerivation`
      # would normally get from the user's top-level attrs. Prepending
      # it to `this.stdenvArgs` means the shared helper can treat our
      # input the same way it treats a legacy mkDerivation call.
      nameArgs =
        if this ? version then
          {
            pname = this.name;
            inherit (this) version;
          }
        else
          {
            inherit (this) name;
          };

      inherit (processDerivationArgs {
        stdenvArgs = nameArgs // this.stdenvArgs;
        inherit (this) meta;
        inherit (stdenv) makeDerivationArgument;
      }) derivationArg checkedEnv;

      checkedAttrs = this.drvAttrs // { inherit (this) meta; };
    in
    {
      validity = checkMeta.assertValidity {
        inherit (this.public) meta;
        attrs = checkedAttrs;
      };
      drvAttrs = derivationArg // checkedEnv;
      drvOutAttrs = builtins.derivationStrict this.drvAttrs;
      public =
        old.public
        # Mirror legacy `extendDerivation`'s behaviour of exposing
        # the raw derivation args (src, patches, name, pname,
        # version, ...) on the package attrset so downstream tools
        # that read them directly (e.g.
        # `pkgs/build-support/src-only/tests.nix` reading
        # `hello.patches`) keep working against mkPackage-based
        # packages. `this.stdenvArgs` is a plain attrset computed by
        # earlier layers with no fixpoint dependency on `public`
        # itself, so merging it here does not create a cycle (unlike
        # `this.drvAttrs`, which flows through
        # `makeDerivationArgument`).
        // this.stdenvArgs
        // {
          # `stdenv.mkDerivation`'s `makeDerivationArgument` adds
          # `inherit stdenv` to the derivation args, which legacy
          # `extendDerivation` then exposes on the package attrset.
          # Mirror that explicitly here so tools that read
          # `pkg.stdenv` (e.g. `pkgs/build-support/src-only/tests.nix`)
          # work the same against mkPackage-based packages. Reading
          # the layer's `stdenv` parameter directly is safe (no
          # fixpoint dependency).
          inherit stdenv;
          # `makeDerivationArgument` sets `system =
          # stdenv.buildPlatform.system` on every derivation; legacy
          # `extendDerivation` then mirrors it onto the package. Tools
          # like `pkgs/top-level/packages-info.nix` read `pkg.system`
          # directly, so expose it the same way here. Read from
          # `stdenv.buildPlatform` rather than `this.drvAttrs.system`
          # to avoid pulling the whole derivation argument pipeline
          # into the fixpoint path of `public`.
          inherit (stdenv.buildPlatform) system;
          meta = checkMeta.commonMeta {
            inherit (this) validity pos;
            attrs = checkedAttrs;
            references =
              this.drvAttrs.nativeBuildInputs or [ ]
              ++ this.drvAttrs.buildInputs or [ ]
              ++ this.drvAttrs.propagatedNativeBuildInputs or [ ]
              ++ this.drvAttrs.propagatedBuildInputs or [ ];
          };
        }
        // rec {
          outPath =
            assert this.validity.handled;
            this.drvOutAttrs.${outputName};
          outputName = lib.head this.drvAttrs.outputs;
          drvPath =
            assert this.validity.handled;
            this.drvOutAttrs.drvPath;
          # Match `stdenv.mkDerivation`'s public surface so consumers
          # that iterate `pkg.outputs` see the same list in both
          # forms.
          inherit (this.drvAttrs) outputs;
        }
        // outputs;
    };

  /**
    Resolve the dependency function arguments of a package function and
    run it to produce a layer (or list of layers) for the mkPackage
    fixpoint.

    Because each function-arg name is looked up via `callPackage`, the
    function may mix traditional spliced single-package arguments
    (e.g. `pkg-config`, `zlib`) with whole package-set arguments
    (e.g. `pkgsBuildHost`, `pkgsHostTarget`). The two styles produce
    bit-identical drvPaths under both native and cross compilation; see
    `pkgs/test/mk-package-package-set-deps.nix` for the regression test.
  */
  layers.withDeps =
    f: externalArgs: this: old:
    let
      fargs = lib.functionArgs f;
      spy = lib.setFunctionArgs (args: { inherit args; }) (
        lib.mapAttrs (
          _k: _v:
          # say we have a default, so that unknown attrs aren't a problem and
          # they can be defined by a subsequent layer.
          true
        ) fargs
      );
      # TODO: make callPackage a parameter?
      values = (callPackage spy externalArgs).args;
      old2 = old // {
        deps = old.deps or { } // values;
        inherit values;
      };
      r = f (
        lib.mapAttrs (
          name: hasDefault:
          builtins.addErrorContext "while evaluating the package function argument `${name}`" (
            externalArgs.${name} or (this.deps.${name}
              or (throw "Dependency ${name} went missing from the package internal `deps` attribute. Did you forget to preserve previous deps? Write e.g. `deps = prev.deps // { ... }`")
            )
          )
        ) fargs
      );
      r' = if lib.isList r then lib.composeManyExtensions r else r;
    in
    old2 // r' this old2;
  # lib.composeExtensions f ({ })

  # TODO: layers.meson
  # TODO: layers.cmake
  # TODO: layers.pkg-config
  # TODO: layers.<some language>

  layers.noop = _this: _old: { };

  layers.buildNpmPackage = callPackage ../node/build-npm-package/layer.nix { };

  layers.fileset = import ./layers/fileset.nix { inherit lib; };

  mkPackageWith =
    {
      # these are not overridable by the layer implementations - not suited for `deps`
      externalDeps ? { inherit layers; },
    }:
    f:
    lib.encapsulate (
      this:
      let
        baseLayer' =
          x:
          let
            base = baseLayer x;
            # Rewire externalDeps on the outer encapsulate fixpoint.
            overrideExternalDeps =
              f:
              this.extend (
                this: old: {
                  externalDeps = old.externalDeps // f old.externalDeps;
                }
              );
            overrideLayers =
              f:
              overrideExternalDeps (old: {
                layers = old.layers // f old.layers;
              });
          in
          base
          // {
            /**
              Extend the package layers with the given function.
            */
            extend =
              f:
              this.extend (
                this: old: {
                  userLayer = lib.composeExtensions old.userLayer f;
                }
              );
            inherit overrideExternalDeps overrideLayers;
            # Re-export the `overrideExternalDeps` / `overrideLayers`
            # sugar on `public`. Defined here rather than in `baseLayer`
            # because their implementations need closure access to the
            # outer encapsulate fixpoint (`this.externalDeps`), which is
            # only reachable from `baseLayer'`.
            public = base.public // {
              inherit overrideExternalDeps overrideLayers;
            };
          };
      in
      # The root of the mkPackage fixpoint is responsible for managing the deps,
      # and combining the layers (without adding an extra fixpoint).
      # Virtually all package logic happens in userLayer.
      {
        userLayer =
          final: prev:
          this.externalDeps.layers.withDeps f (
            this.externalDeps
            // {
              # Package attributes
              inherit final prev;
              # Dependencies
              /**
                Override the package dependencies that are not overridable by the individual layer implementations,
                Notably, the `layers` attribute.
              */
              overrideExternalDeps =
                newDeps:
                this.extend (
                  this: old: {
                    externalDeps = old.externalDeps // newDeps;
                  }
                );
            }
          ) final prev;
        inherit externalDeps;
        package = lib.extends this.userLayer baseLayer' this.package;
        inherit (this.package) public;
      }
    );
  mkPackage = mkPackageWith { };

  /**
    Sugar for separating a package function from its default dependency
    choices. Instead of writing

        { mkPackage }:
        mkPackage ({ stdenv, postgresql_14, ... }: [
          (this: old: { stdenvArgs.buildInputs = [ postgresql_14 ]; ... })
        ])

    and baking in the version choice inline (where it isn't stable across
    package sets and can't be overridden without renaming), write

        { mkPackageWithDefaults }:
        mkPackageWithDefaults {
          defaults = { postgresql_14, ... }: { postgresql = postgresql_14; };
          function = { stdenv, postgresql, ... }: [
            (this: old: { stdenvArgs.buildInputs = [ postgresql ]; ... })
          ];
        }

    The package function now references the stable identifier
    `postgresql`, and the default choice of which concrete package
    backs it is cleanly separated into `defaults`. Both `.override`
    and `.overrideAttrs` work as expected: overriding `postgresql`
    flows through `this.deps` on top of the seeded default.

    Implementation: a small seed layer runs before the user's layers
    and merges the resolved defaults into `this.deps`. The user's
    function arg lookup for `postgresql` then finds the seeded value
    via the normal `externalArgs.${name} or this.deps.${name}`
    fallback in `layers.withDeps`, with `.override` layers on top.
  */
  mkPackageWithDefaults =
    {
      function,
      defaults ? null,
    }:
    let
      fnFargs = lib.functionArgs function;
      defFargs = if defaults == null then { } else lib.functionArgs defaults;
      # Union of both sets of function args, all marked as optional
      # (has default = true) so the spy inside `layers.withDeps` can
      # resolve them through callPackage even when the ambient package
      # set doesn't actually contain a `postgresql` / `boost` / etc.
      allFargs = lib.mapAttrs (_: _: true) (defFargs // fnFargs);
      wrapper =
        args:
        let
          resolvedDefaults =
            if defaults == null then
              { }
            else
              defaults (builtins.intersectAttrs defFargs args);
          userResult = function (builtins.intersectAttrs fnFargs args);
          userLayers = if lib.isList userResult then userResult else [ userResult ];
        in
        [
          (_this: old: {
            deps = (old.deps or { }) // resolvedDefaults;
          })
        ]
        ++ userLayers;
    in
    mkPackage (lib.setFunctionArgs wrapper allFargs);

  mkDerivationAsPackage = import ./mk-derivation.nix { inherit lib mkPackage; };
in
{
  inherit
    layers
    mkPackage
    mkPackageWithDefaults
    mkDerivationAsPackage
    ;
}
