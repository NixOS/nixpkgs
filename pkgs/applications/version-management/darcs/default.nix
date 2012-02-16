{ cabal, Cabal, curl, extensibleExceptions, filepath, hashedStorage
, haskeline, html, HTTP, mmap, mtl, network, parsec, random
, regexCompat, tar, terminfo, text, zlib
}:

cabal.mkDerivation (self: {
  pname = "darcs";
  version = "2.5.2";
  sha256 = "11mk1xcrxk2x5c0s96s19wb4xvhjl9s59bdqcrj8f4w09zbgjlw9";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    Cabal extensibleExceptions filepath hashedStorage haskeline html
    HTTP mmap mtl network parsec random regexCompat tar terminfo text
    zlib
  ];
  extraLibraries = [ curl ];
  meta = {
    homepage = "http://darcs.net/";
    description = "a distributed, interactive, smart revision control system";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
