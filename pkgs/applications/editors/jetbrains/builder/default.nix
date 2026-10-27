# Builder for JetBrains IDEs (`mkJetBrainsProduct`)

{
  # keep-sorted start
  callPackage,
  lib,
  stdenv,
  # keep-sorted end

  vmopts ? null,
}:
let
  baseBuilder = if stdenv.hostPlatform.isDarwin then ./darwin.nix else ./linux.nix;
in
# Makes a JetBrains IDE
lib.extendMkDerivation {
  constructDrv = callPackage baseBuilder {
    inherit vmopts;
    # Args to not pass to mkDerivation in the base builders. Since both get the same args
    # passed in, both have the same list of args to ignore, even if they don't both use
    # all of them.
    excludeDrvArgNames = [
      "product"
      "productShort"
      "buildNumber"
      "wmClass"
      "jetbrains-libdbm"
      "fsnotifier"
      "extraLdPath"
      "extraWrapperArgs"
    ];
  };

  extendDrvArgs =
    # NOTE: See linux.nix and darwin.nix for additional specific arguments
    finalAttrs:
    {
      buildNumber,
      product,

      jetbrains-libdbm,
      fsnotifier,

      meta ? { },
      passthru ? { },
      ...
    }:
    {
      passthru = passthru // {
        inherit
          buildNumber
          product
          jetbrains-libdbm
          fsnotifier
          ;

        updateScript = ../updater/main.py;

        tests = {
          plugins = callPackage ../plugins/tests.nix { ide = finalAttrs.finalPackage; };
        };
      };
    };
}
