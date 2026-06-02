{ lib }:

lib.recursiveUpdate lib (
  import ./extra-lib-common.nix { inherit lib; }
  // {

    /*
      Override arguments to mkRocqDerivation for a Rocq library.

      This function allows you to easily override arguments to mkRocqDerivation,
      even when they are not exposed by the Rocq library directly.

      Type: overrideRocqDerivation :: AttrSet -> RocqLibraryDerivation -> RocqLibraryDerivation

      Example:

      ```nix
      rocqPackages.lib.overrideRocqDerivation
        {
          defaultVersion = "9999";
          release."9999".hash = "sha256-fDoP11rtrIM7+OLdMisv2EF7n/IbGuwFxHiPtg3qCNM=";
        }
        rocqPackages.QuickChick;
      ```

      This example overrides the `defaultVersion` and `release` arguments that
      are passed to `mkRocqDerivation` in the QuickChick derivation.

      Note that there is a difference between using `.override` on a Rocq
      library vs this `overrideRocqDerivation` function. `.override` allows you
      to modify arguments to the derivation itself, for instance by passing
      different versions of dependencies:

      ```nix
      rocqPackages.QuickChick.override { ssreflect = my-cool-ssreflect; }
      ```

      whereas `overrideRocqDerivation` allows you to override arguments to the
      call to `mkRocqDerivation` in the Rocq library.

      Note that all Rocq libraries in Nixpkgs have a `version` argument for
      easily using a different version.  So if all you want to do is use a
      different version, and the derivation for the Rocq library already has
      support for the version you want, you likely only need to update the
      `version` argument on the library derivation.  This is done with
      `.override`:

      ```nix
      rocqPackages.QuickChick.override { version = "1.4.0"; }
      ```
    */
    overrideRocqDerivation =
      f: drv:
      (drv.override (args: {
        mkRocqDerivation = drv_: (args.mkRocqDerivation drv_).override f;
      }));
  }
)
