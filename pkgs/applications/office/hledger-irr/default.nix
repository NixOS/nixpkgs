{ cabal, Cabal, hledgerLib, statistics, time }:

cabal.mkDerivation (self: {
  pname = "hledger-irr";
  version = "0.1.1.3";
  sha256 = "0vjf478b9msmgr1nxyy8pgc9mvn61i768ypcr5gbinsnsr9kxqsm";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ Cabal hledgerLib statistics time ];
  meta = {
    description = "computes the internal rate of return of an investment";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
