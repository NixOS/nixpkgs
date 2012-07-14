{ cabal, Cabal, hledgerLib, mtl, time }:

cabal.mkDerivation (self: {
  pname = "hledger-interest";
  version = "1.4.1";
  sha256 = "05mzqmnr9c4zmss0f2aac4qh4s954nbkimv924d31q2lisdddvw8";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ Cabal hledgerLib mtl time ];
  meta = {
    homepage = "http://github.com/peti/hledger-interest";
    description = "computes interest for a given account";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
