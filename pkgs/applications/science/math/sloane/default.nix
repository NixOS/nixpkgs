{ cabal, ansiTerminal, cmdargs, filepath, HTTP, network
, stringsearch, terminalSize, time, zlib
}:

cabal.mkDerivation (self: {
  pname = "sloane";
  version = "1.7";
  sha256 = "1xy22cdswb5blvdsz8l7irfj6msl85v7gpl9ymcx985gj4z0l2ik";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    ansiTerminal cmdargs filepath HTTP network stringsearch
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
