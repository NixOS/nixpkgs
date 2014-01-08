{ cabal, alex, binary, Cabal, cautiousFile, concreteTyperep
, dataAccessor, dataAccessorMtl, dataAccessorTemplate, derive, Diff
, dlist, dyre, filepath, fingertree, ghcPaths, hashable, hint
, HUnit, mtl, parsec, pointedlist, pureMD5, QuickCheck, random
, regexBase, regexTdfa, split, testFramework, testFrameworkHunit
, time, uniplate, unixCompat, unorderedContainers, utf8String, vty
, pango, gtk, gio, glib, cairo
, xdgBasedir
}:

cabal.mkDerivation (self: {
  pname = "yi";
  version = "0.7.0";
  sha256 = "0mzcjgp12k5mxb37r6chxsk726b1qxds49ch656bpgrg7n22w2j1";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary Cabal cautiousFile concreteTyperep dataAccessor
    dataAccessorMtl dataAccessorTemplate derive Diff dlist dyre
    filepath fingertree ghcPaths hashable hint mtl parsec pointedlist
    pureMD5 QuickCheck random regexBase regexTdfa split time uniplate
    unixCompat unorderedContainers utf8String vty xdgBasedir pango gtk
    gio glib cairo
  ];
  testDepends = [
    filepath HUnit QuickCheck testFramework testFrameworkHunit
  ];
  buildTools = [ alex ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/Yi";
    description = "The Haskell-Scriptable Editor";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
  configureFlags="-fpango";
  jailbreak=true;
  doCheck=false; # Tests fail in version on hackage because files are missing
})
