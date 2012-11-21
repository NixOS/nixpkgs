{ cabal, curl, extensibleExceptions, filepath, hashedStorage
, haskeline, html, HTTP, mmap, mtl, network, parsec, random
, regexCompat, tar, terminfo, text, vector, zlib
}:

cabal.mkDerivation (self: {
  pname = "darcs";
  version = "2.8.3";
  sha256 = "0nbg45i5sgbsc488siqirgysy3z912xghqbwm5hcsl37j910hxch";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    extensibleExceptions filepath hashedStorage haskeline html HTTP
    mmap mtl network parsec random regexCompat tar terminfo text vector
    zlib
  ];
  extraLibraries = [ curl ];
  postInstall = ''
    mkdir -p $out/etc/bash_completion.d
    mv contrib/darcs_completion $out/etc/bash_completion.d/darcs
  '';
  meta = {
    homepage = "http://darcs.net/";
    description = "a distributed, interactive, smart revision control system";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
