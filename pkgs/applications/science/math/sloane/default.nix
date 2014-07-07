{ cabal, ansiTerminal, filepath, HTTP, network, optparseApplicative
, terminalSize, text, time, zlib
}:

cabal.mkDerivation (self: {
  pname = "sloane";
  version = "1.8.2";
  sha256 = "0kdznrvyrax1gihqxxw36jfbmjri808ii827fa71v2ijlm416hk1";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    ansiTerminal filepath HTTP network optparseApplicative terminalSize
    text time zlib
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
