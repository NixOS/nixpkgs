{ lib }:

lib.recursiveUpdate lib (
  import ../rocq/extra-lib-common.nix { inherit lib; }
  // {

    /*
      Override arguments to mkCoqDerivation for a Coq library.

      This function allows you to easily override arguments to mkCoqDerivation,
      even when they are not exposed by the Coq library directly.

      Type: overrideCoqDerivation :: AttrSet -> CoqLibraryDerivation -> CoqLibraryDerivation

      Example:

      ```nix
      coqPackages.lib.overrideCoqDerivation
        {
          defaultVersion = "9999";
          release."9999".hash = "sha256-fDoP11rtrIM7+OLdMisv2EF7n/IbGuwFxHiPtg3qCNM=";
        }
        coqPackages.QuickChick;
      ```

      This example overrides the `defaultVersion` and `release` arguments that
      are passed to `mkCoqDerivation` in the QuickChick derivation.

      Note that there is a difference between using `.override` on a Coq
      library vs this `overrideCoqDerivation` function. `.override` allows you
      to modify arguments to the derivation itself, for instance by passing
      different versions of dependencies:

      ```nix
      coqPackages.QuickChick.override { ssreflect = my-cool-ssreflect; }
      ```

      whereas `overrideCoqDerivation` allows you to override arguments to the
      call to `mkCoqDerivation` in the Coq library.

      Note that all Coq libraries in Nixpkgs have a `version` argument for
      easily using a different version.  So if all you want to do is use a
      different version, and the derivation for the Coq library already has
      support for the version you want, you likely only need to update the
      `version` argument on the library derivation.  This is done with
      `.override`:

      ```nix
      coqPackages.QuickChick.override { version = "1.4.0"; }
      ```
    */
    overrideCoqDerivation =
      f: drv:
      (drv.override (args: {
        mkCoqDerivation = drv_: (args.mkCoqDerivation drv_).override f;
      }));
  }
)
