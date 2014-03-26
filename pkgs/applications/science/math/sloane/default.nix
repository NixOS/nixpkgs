{ cabal, ansiTerminal, cmdargs, HTTP, terminalSize, url }:

cabal.mkDerivation (self: {
  pname = "sloane";
  version = "1.6";
  sha256 = "0my3j53bda3s8zxnm6is1align4k082wwsfg2y1i75js5z9kwmzy";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ ansiTerminal cmdargs HTTP terminalSize url ];
  postInstall = ''
    mkdir -p $out/share/man/man1
    cp sloane.1 $out/share/man/man1/
  '';
  meta = {
    homepage = "http://github.com/akc/sloane";
    description = "A command line interface to Sloane's On-Line Encyclopedia of Integer Sequences";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ akc ];
  };
})
