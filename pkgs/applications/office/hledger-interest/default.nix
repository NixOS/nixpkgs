{ cabal, Cabal, hledgerLib, mtl, time }:

cabal.mkDerivation (self: {
  pname = "hledger-interest";
  version = "1.4.2";
  sha256 = "1his6pxrvs5p28bmk77bd8vaq6rhjlilwq598mbkgfvlqg7q076v";
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
