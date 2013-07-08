{ cabal, Cabal, hledgerLib, statistics, time }:

cabal.mkDerivation (self: {
  pname = "hledger-irr";
  version = "0.1.1.2";
  sha256 = "1mh1lzhnxc8ps8n5j37wrmbqafwdyap60j8rqr6xdfa2syfyq8i2";
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
