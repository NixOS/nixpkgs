{ cabal, ConfigFile, filepath, HStringTemplate, HUnit, pandoc
, pandocTypes, SHA, testFramework, testFrameworkHunit, time
}:

cabal.mkDerivation (self: {
  pname = "mathblog";
  version = "0.5";
  sha256 = "01iyzrwscqirhcr4622d0n16mr4p54qbvg5m2a0ns36j59xfd79g";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    ConfigFile filepath HStringTemplate HUnit pandoc pandocTypes SHA
    testFramework testFrameworkHunit time
  ];
  meta = {
    description = "A program for creating and managing a static weblog with LaTeX math and function graphs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
