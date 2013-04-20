{ cabal, filepath, strict, time, xdgBasedir }:

cabal.mkDerivation (self: {
  pname = "yeganesh";
  version = "2.5";
  sha256 = "1bgw5v1g5n06jj0lyxpf48mdpaa2s49g0lbagf3jf9q01rb92bvf";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ filepath strict time xdgBasedir ];
  meta = {
    homepage = "http://dmwit.com/yeganesh";
    description = "small dmenu wrapper";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
