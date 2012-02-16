{ cabal, Cabal, hledgerLib, mtl, time }:

cabal.mkDerivation (self: {
  pname = "hledger-interest";
  version = "1.4";
  sha256 = "0lm4jcxcig3yxzhbnka1q54fvshn5b9d91a5a2mbmkzbwhzjj0lg";
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
