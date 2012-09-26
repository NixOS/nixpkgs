{ cabal, hint, libmpd, mtl, network, parsec, random, regexPosix
, split, X11, xmonad, xmonadContrib
}:

cabal.mkDerivation (self: {
  pname = "xmonad-extras";
  version = "0.10.1.1";
  sha256 = "1pkp9z58w2x8yhxhvm5nifxb1qcajv52ji53n77rjhpysvrgq5m7";
  buildDepends = [
    hint libmpd mtl network parsec random regexPosix split X11 xmonad
    xmonadContrib
  ];
  patchPhase = ''
    sed -i xmonad-extras.cabal -e 's|split .*|split|'
  '';
  configureFlags = "-f-with_hlist -fwith_split -fwith_parsec";
  meta = {
    homepage = "http://projects.haskell.org/xmonad-extras";
    description = "Third party extensions for xmonad with wacky dependencies";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
