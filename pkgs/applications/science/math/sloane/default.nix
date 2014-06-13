{ cabal, ansiTerminal, filepath, HTTP, network, optparseApplicative
, stringsearch, terminalSize, time, zlib
}:

cabal.mkDerivation (self: {
  pname = "sloane";
  version = "1.8";
  sha256 = "0c30slsswfqwzi39hk6jraxz1y1a2yn8g8nyjvlnggwajx2rlm6p";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    ansiTerminal filepath HTTP network optparseApplicative stringsearch
    terminalSize time zlib
  ];
  postInstall = ''
    mkdir -p $out/share/man/man1
    cp sloane.1 $out/share/man/man1/
  '';
  meta = {
    homepage = "http://github.com/akc/sloane";
    description = "A command line interface to Sloane's On-Line Encyclopedia of Integer Sequences";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.akc ];
  };
})
