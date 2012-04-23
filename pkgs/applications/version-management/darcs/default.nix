{ cabal, curl, extensibleExceptions, filepath, hashedStorage
, haskeline, html, HTTP, mmap, mtl, network, parsec, random
, regexCompat, tar, terminfo, text, vector, zlib
}:

cabal.mkDerivation (self: {
  pname = "darcs";
  version = "2.8.0";
  sha256 = "10yfab7qb20hzikwrgra7zhx7ad2j0s6l7zksmvczf4xm6hw458l";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    extensibleExceptions filepath hashedStorage haskeline html HTTP
    mmap mtl network parsec random regexCompat tar terminfo text vector
    zlib
  ];
  extraLibraries = [ curl ];
  meta = {
    homepage = "http://darcs.net/";
    description = "a distributed, interactive, smart revision control system";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
