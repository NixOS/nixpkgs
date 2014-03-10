{ cabal, alex, binary, Cabal, cautiousFile, concreteTyperep
, dataAccessor, dataAccessorMtl, dataAccessorTemplate, derive, Diff
, dlist, dyre, filepath, fingertree, glib, gtk, hashable, hint
, HUnit, mtl, pango, parsec, pointedlist, QuickCheck, random
, regexBase, regexTdfa, split, testFramework, testFrameworkHunit
, time, uniplate, unixCompat, unorderedContainers, utf8String, vty
, xdgBasedir
}:

cabal.mkDerivation (self: {
  pname = "yi";
  version = "0.7.1";
  sha256 = "111xg7qpjhsqf6pfr136wh8km3lrgpzghd9h5rlypafr61w59vly";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary Cabal cautiousFile concreteTyperep dataAccessor
    dataAccessorMtl dataAccessorTemplate derive Diff dlist dyre
    filepath fingertree glib gtk hashable hint mtl pango parsec
    pointedlist QuickCheck random regexBase regexTdfa split time
    uniplate unixCompat unorderedContainers utf8String vty xdgBasedir
  ];
  testDepends = [
    filepath HUnit QuickCheck testFramework testFrameworkHunit
  ];
  buildTools = [ alex ];
  configureFlags = "-fpango";
  jailbreak = true;
  doCheck = false;
  meta = {
    homepage = "http://haskell.org/haskellwiki/Yi";
    description = "The Haskell-Scriptable Editor";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
