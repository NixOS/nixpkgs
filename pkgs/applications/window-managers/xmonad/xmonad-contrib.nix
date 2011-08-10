{ cabal, X11, X11Xft, extensibleExceptions, mtl, utf8String, xmonad
}:

cabal.mkDerivation (self: {
  pname = "xmonad-contrib";
  version = "0.9.2";
  sha256 = "06hg5j4w8iz62wmyygq4c7xcbi9dxlhhh3dbic438cjk7c0w1h5p";
  buildDepends = [
    X11 X11Xft extensibleExceptions mtl utf8String xmonad
  ];
  meta = {
    homepage = "http://xmonad.org/";
    description = "Third party extensions for xmonad";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
