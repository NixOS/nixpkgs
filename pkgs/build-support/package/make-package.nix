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

  baseLayer = this: {
    pos = builtins.unsafeGetAttrPos "name" this;
    # TODO: drvAttrs won't be available in RFC 92 dynamic derivations or multi-derivation packages.
    validity = checkMeta.assertValidity {
      inherit (this.public) meta;
      attrs = this.drvAttrs // {
        inherit (this) meta;
      };
    };

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

    public =
      builtins.intersectAttrs {
        tests = null;
        version = null;
      } this
      // {
        /*
          The marker for a [package attribute set](https://nixos.org/manual/nix/stable/glossary.html#package-attribute-set).
          The value is "derivation" for historical reasons.
        */
        type = "derivation";

        # FIXME: this assumes this.drvAttrs, which is a bad dependency on the
        #        derivation layer
        meta = checkMeta.commonMeta {
          inherit (this) validity pos;
          attrs = this.drvAttrs // {
            inherit (this) meta;
          };
          references =
            this.drvAttrs.nativeBuildInputs or [ ]
            ++ this.drvAttrs.buildInputs or [ ]
            ++ this.drvAttrs.propagatedNativeBuildInputs or [ ]
            ++ this.drvAttrs.propagatedBuildInputs or [ ];
        };

        inherit (this) help name;

        override =
          f:
          this.extend (
            this: old: {
              deps = old.deps // f old.deps;
            }
          );

        internals = this;

        # TODO: Support legacy attrs like passthru?
        overrideAttrs =
          f:
          this.extend (
            this: old: {
              setup =
                old.setup
                // (lib.toExtension f) (
                  this.setup or { }
                  // {
                    finalPackage = this.public;
                  }
                ) old.setup or { };
            }
          );
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
    in
    {
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
        // this.setup
      );
      drvOutAttrs = builtins.derivationStrict this.drvAttrs;
      public =
        old.public
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
          baseLayer x
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
in
{
  inherit
    layers
    mkPackage
    ;
}
