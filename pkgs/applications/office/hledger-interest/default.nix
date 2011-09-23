{ cabal, hledgerLib, mtl, time }:

cabal.mkDerivation (self: {
  pname = "hledger-interest";
  version = "1.3";
  sha256 = "1sgnl3vv38cmgxv3xag3c78j1955xxwdmr5xr3f8rc78np6d0wnz";
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
