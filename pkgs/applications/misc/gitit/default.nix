{ lib, haskellPackages, haskell, removeReferencesTo
# “Plugins” are a fancy way of saying gitit will invoke
# GHC at *runtime*, which in turn makes it pull GHC
# into its runtime closure. Only enable if you really need
# that feature. But if you do you’ll want to use gitit
# as a library anyway.
, pluginSupport ? false
}:

# this is similar to what we do with the pandoc executable

let
  plain = haskellPackages.gitit;
  plugins =
    if pluginSupport
    then plain
    else haskell.lib.compose.disableCabalFlag "plugins" plain;
  static = haskell.lib.compose.justStaticExecutables plugins;

in

static
