{ cabal, curl, extensibleExceptions, filepath, hashedStorage
, haskeline, html, HTTP, mmap, mtl, network, parsec, random
, regexCompat, tar, terminfo, text, utf8String, vector, zlib
}:

cabal.mkDerivation (self: {
  pname = "darcs";
  version = "2.8.4";
  sha256 = "164zclgib9ql4rqykpdhhk2bad0m5v0k0iwzsj0z7nax5nxlvarz";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    extensibleExceptions filepath hashedStorage haskeline html HTTP
    mmap mtl network parsec random regexCompat tar terminfo text
    utf8String vector zlib
  ];
  extraLibraries = [ curl ];
  doCheck = false;
  postInstall = ''
    mkdir -p $out/etc/bash_completion.d
    mv contrib/darcs_completion $out/etc/bash_completion.d/darcs
  '';
  meta = {
    homepage = http://darcs.net/;
    description = "A distributed, interactive, smart revision control system";
    license = "GPL";
    # FIXME: this gives an infinite recursion in the "darcs" attribute
    # in all-packages.nix.
    #platforms = self.ghc.meta.platforms;
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
