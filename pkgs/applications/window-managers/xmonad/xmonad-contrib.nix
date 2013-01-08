{ cabal, extensibleExceptions, mtl, random, utf8String, X11, X11Xft
, xmonad
}:

cabal.mkDerivation (self: {
  pname = "xmonad-contrib";
  version = "0.11";
  sha256 = "188brys16b3wmxd22j4284wnpasm8bixdjfxl1jr2q2xi45nzks0";
  buildDepends = [
    extensibleExceptions mtl random utf8String X11 X11Xft xmonad
  ];
  meta = {
    homepage = "http://xmonad.org/";
    description = "Third party extensions for xmonad";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
