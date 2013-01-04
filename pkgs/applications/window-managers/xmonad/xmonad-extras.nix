{ cabal, hint, libmpd, mtl, network, parsec, random, regexPosix
, split, X11, xmonad, xmonadContrib
}:

cabal.mkDerivation (self: {
  pname = "xmonad-extras";
  version = "0.10.1.2";
  sha256 = "1v0yhi3sw7qks8d13amps0qs5p90j3prjh5abm02wblcd0bm1xay";
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
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
