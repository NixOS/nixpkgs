{ cabal, hint, libmpd, mtl, network, parsec, random, regexPosix
, split, X11, xmonad, xmonadContrib
}:

cabal.mkDerivation (self: {
  pname = "xmonad-extras";
  version = "0.12";
  sha256 = "1gyj9j6x21rvs6kg6g74wr0jdd36c5ml63a670456fhjr96s8y0g";
  buildDepends = [
    hint libmpd mtl network parsec random regexPosix split X11 xmonad
    xmonadContrib
  ];
  configureFlags = "-f-with_hlist -fwith_split -fwith_parsec";
  jailbreak = true;
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
