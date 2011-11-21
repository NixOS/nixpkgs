{ cabal, hint, mtl, network, parsec, random, regexPosix, split, X11
, xmonad, xmonadContrib
}:

cabal.mkDerivation (self: {
  pname = "xmonad-extras";
  version = "0.10";
  sha256 = "0pxvzqcwva64xlrw21wxxc8zq8w36rgg58a12j6kz47ivwkin27g";
  buildDepends = [
    hint mtl network parsec random regexPosix split X11 xmonad
    xmonadContrib
  ];
  configureFlags = "-f-with_hlist -f-with_mpd";
  noHaddock = true;
  meta = {
    homepage = "http://projects.haskell.org/xmonad-extras";
    description = "Third party extensions for xmonad with wacky dependencies";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
