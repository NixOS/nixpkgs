{ cabal, alex, binary, Cabal, cautiousFile, concreteTyperep
, dataDefault, derive, Diff, dlist, dyre, filepath, fingertree
, glib, gtk, hashable, hint, HUnit, lens, mtl, pango, parsec
, pointedlist, QuickCheck, random, regexBase, regexTdfa, safe
, split, tasty, tastyHunit, tastyQuickcheck, time, transformersBase
, uniplate, unixCompat, unorderedContainers, utf8String, vty
, xdgBasedir
}:

cabal.mkDerivation (self: {
  pname = "yi";
  version = "0.8.1";
  sha256 = "1hyqlydc0na9pkb3fkbp13c6vnp4f80z8237bvrv12wkk5syyn23";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary Cabal cautiousFile concreteTyperep dataDefault derive Diff
    dlist dyre filepath fingertree glib gtk hashable hint lens mtl
    pango parsec pointedlist QuickCheck random regexBase regexTdfa safe
    split time transformersBase uniplate unixCompat unorderedContainers
    utf8String vty xdgBasedir
  ];
  testDepends = [
    filepath HUnit QuickCheck tasty tastyHunit tastyQuickcheck
  ];
  buildTools = [ alex ];
  configureFlags = "-fpango";
  doCheck = false;
  meta = {
    homepage = "http://haskell.org/haskellwiki/Yi";
    description = "The Haskell-Scriptable Editor";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
