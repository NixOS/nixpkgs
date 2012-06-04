{ cabal, filepath, libXrandr, mtl, parsec, stm, time, utf8String
, wirelesstools, X11, X11Xft
}:

cabal.mkDerivation (self: {
  pname = "xmobar";
  version = "0.15";
  sha256 = "1wa141bf3krzr8qcd9cyix3cflbw1yr1l3299ashjs7skqnjadcl";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    filepath mtl parsec stm time utf8String X11 X11Xft
  ];
  extraLibraries = [ libXrandr wirelesstools ];
  configureFlags = "-fwith_xft -fwith_iwlib";
  meta = {
    homepage = "http://projects.haskell.org/xmobar/";
    description = "A Minimalistic Text Based Status Bar";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
