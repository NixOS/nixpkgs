{ cabal, filepath, libXrandr, mtl, parsec, regexCompat, stm, time
, utf8String, X11, X11Xft
}:

cabal.mkDerivation (self: {
  pname = "xmobar";
  version = "0.18";
  sha256 = "08kk0yjx51vjrvvvd34hv8v80dsh8kjv150qf413ikaff0i28v7w";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    filepath mtl parsec regexCompat stm time utf8String X11 X11Xft
  ];
  extraLibraries = [ libXrandr ];
  configureFlags = "-fwith_xft";
  meta = {
    homepage = "http://projects.haskell.org/xmobar/";
    description = "A Minimalistic Text Based Status Bar";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
