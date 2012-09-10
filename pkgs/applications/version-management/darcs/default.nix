{ cabal, curl, extensibleExceptions, filepath, hashedStorage
, haskeline, html, HTTP, mmap, mtl, network, parsec, random
, regexCompat, tar, terminfo, text, vector, zlib
}:

cabal.mkDerivation (self: {
  pname = "darcs";
  version = "2.8.2";
  sha256 = "1gd8028k91hjsd9hvx3pw4h5zsn2ckc7pfp7f1f566dpp1g422v5";
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
