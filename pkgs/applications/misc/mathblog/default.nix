{ cabal, ConfigFile, filepath, HStringTemplate, HUnit, pandoc
, pandocTypes, SHA, testFramework, testFrameworkHunit, time
}:

cabal.mkDerivation (self: {
  pname = "mathblog";
  version = "0.4";
  sha256 = "0kpawik74hp9k56b858idnlkla3iaalys8mas6c4gf4jfw2w0r3j";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    ConfigFile filepath HStringTemplate HUnit pandoc pandocTypes SHA
    testFramework testFrameworkHunit time
  ];
  patches = [
    ./0006-Loosen-dependencies-on-SHA-HUnit-and-test-framework.patch
  ];
  meta = {
    description = "A program for creating and managing a static weblog with LaTeX math and function graphs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
