{ lib, stdenv, haskellPackages, haskell
# “Plugins” are a fancy way of saying gitit will invoke
# GHC at *runtime*, which in turn makes it pull GHC
# into its runtime closure. Only enable if you really need
# that feature. But if you do you’ll want to use gitit
# as a library anyway.
, pluginSupport ? false
}:

let
  inherit (haskell.lib.compose)
    enableCabalFlag
    disableCabalFlag
    justStaticExecutables
    overrideCabal
  ;

  base = (if pluginSupport then enableCabalFlag else disableCabalFlag)
    "plugins"
    haskellPackages.gitit;

  # Removes erroneous references from dead code that GHC can't eliminate
  aarch64DarwinFix = overrideCabal (drv:
    lib.optionalAttrs (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) {
      postInstall = ''
        ${drv.postInstall or ""}
        remove-references-to -t ${haskellPackages.HTTP} "$out/bin/gitit"
        remove-references-to -t ${haskellPackages.HTTP} "$out/bin/expireGititCache"
        remove-references-to -t ${haskellPackages.happstack-server} "$out/bin/gitit"
        remove-references-to -t ${haskellPackages.hoauth2} "$out/bin/gitit"
        remove-references-to -t ${haskellPackages.pandoc} "$out/bin/gitit"
        remove-references-to -t ${haskellPackages.pandoc-types} "$out/bin/gitit"
      '';
    });
in

if pluginSupport
then base
else lib.pipe (base.override { ghc-paths = null; }) [
  justStaticExecutables
  aarch64DarwinFix
]
