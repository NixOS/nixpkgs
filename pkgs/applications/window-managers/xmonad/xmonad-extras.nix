{ cabal, hint, libmpd, mtl, network, parsec, random, regexPosix
, split, X11, xmonad, xmonadContrib
}:

cabal.mkDerivation (self: {
  pname = "xmonad-extras";
  version = "0.11";
  sha256 = "09r64z09mfdz86k7v5c6zds9ng0fjcp44kd8f5qg1sz40yblrny5";
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
