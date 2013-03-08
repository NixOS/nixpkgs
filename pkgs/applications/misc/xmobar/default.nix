{ cabal, filepath, libXrandr, mtl, parsec, stm, time, utf8String
, wirelesstools, X11, X11Xft
}:

cabal.mkDerivation (self: {
  pname = "xmobar";
  version = "0.16";
  sha256 = "1dx4kwygzp4c5j4jj4lsfgjfvhh863v68s106lmwc86a30h60p8i";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    filepath mtl parsec stm time utf8String X11 X11Xft
  ];
  extraLibraries = [ libXrandr wirelesstools ];
  configureFlags = "-fwith_xft -fwith_iwlib";
  patches = [ ./add-freeration-variable.patch ];
  meta = {
    homepage = "http://projects.haskell.org/xmobar/";
    description = "A Minimalistic Text Based Status Bar";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
