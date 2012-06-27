{ cabal, curl, extensibleExceptions, filepath, hashedStorage
, haskeline, html, HTTP, mmap, mtl, network, parsec, random
, regexCompat, tar, terminfo, text, vector, zlib
}:

cabal.mkDerivation (self: {
  pname = "darcs";
  version = "2.8.1";
  sha256 = "1fz9k9zihb0fz0w2y55iqa1fd604nxzz48r62sx3ixxn8qqsvrd1";
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
