{ cabal, hledgerLib, mtl, time }:

cabal.mkDerivation (self: {
  pname = "hledger-interest";
  version = "1.0";
  sha256 = "082cyyyina7w5zvzsy1b9m9a7vb12ccxd351s8ajk11pg628zb80";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ hledgerLib mtl time ];
  meta = {
    homepage = "http://github.com/peti/hledger-interest";
    description = "computes interest for a given account";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
