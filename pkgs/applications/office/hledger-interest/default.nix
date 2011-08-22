{ cabal, hledgerLib, mtl, time }:

cabal.mkDerivation (self: {
  pname = "hledger-interest";
  version = "1.2";
  sha256 = "1r5x6z0k33fpvqba6zlkhpm7b0rwwnli4q100psms89x0rrj7y2d";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ hledgerLib mtl time ];
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
