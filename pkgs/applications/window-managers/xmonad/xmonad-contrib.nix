{ cabal, extensibleExceptions, mtl, random, utf8String, X11, X11Xft
, xmonad
}:

cabal.mkDerivation (self: {
  pname = "xmonad-contrib";
  version = "0.11.1";
  sha256 = "1356dn8ipw7fgn2xijppn69f64zg36gcxbw9qndxbbmml5gq0zrl";
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
