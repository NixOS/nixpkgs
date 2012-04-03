{ cabal, hint, HList, libmpd, mtl, network, parsec, random
, regexPosix, split, X11, xmonad, xmonadContrib
}:

cabal.mkDerivation (self: {
  pname = "xmonad-extras";
  version = "0.10.1";
  sha256 = "17rac0xjw1zw1jlc1rpq54vg50xscb3b98knk4gkb8bv1khpgz27";
  buildDepends = [
    hint HList libmpd mtl network parsec random regexPosix split X11
    xmonad xmonadContrib
  ];
  meta = {
    homepage = "http://projects.haskell.org/xmonad-extras";
    description = "Third party extensions for xmonad with wacky dependencies";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
