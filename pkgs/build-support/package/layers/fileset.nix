/**
  `mkPackage` layer for sourcing a package from a `lib.fileset`.

  Usage:

  ```nix
  mkPackage ({ layers, lib, stdenv, ... }: [
    (layers.derivation { inherit stdenv; })
    (layers.fileset {
      root = ./.;
      fileset = lib.fileset.unions [ ./Makefile ./src ];
      # optional; defaults to the package name
      name = "my-package-src";
    })
    (this: old: {
      name = "my-package";
      version = "0.1";
      stdenvArgs = old.stdenvArgs or { } // {
        # no need to set src — the fileset layer fills it in
      };
    })
  ])
  ```

  Unlike `layers.derivation`, this layer does not require you to clear out any
  derivation attributes first: it simply populates `this.stdenvArgs.src` from the
  fileset. It also validates at evaluation time that every path referenced by
  the fileset actually exists under `root`, surfacing typos early.
*/
{ lib }:

{
  root,
  fileset,
  name ? null,
}:

this: old: {
  stdenvArgs =
    old.stdenvArgs or { }
    // {
      src = lib.fileset.toSource {
        inherit root fileset;
      };
    }
    // lib.optionalAttrs (name != null) {
      name = name;
    };
}
