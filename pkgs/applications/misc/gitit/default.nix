{ lib, haskellPackages, haskell
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
  ;

  base = (if pluginSupport then enableCabalFlag else disableCabalFlag)
    "plugins"
    haskellPackages.gitit;
in

if pluginSupport
then base
else justStaticExecutables base
