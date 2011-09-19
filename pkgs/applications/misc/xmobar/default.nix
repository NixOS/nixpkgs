{ cabal, mtl, parsec, stm, time, utf8String, X11, X11Xft }:

cabal.mkDerivation (self: {
  pname = "xmobar";
  version = "0.13";
  sha256 = "0ijava0vn2dmc6v57i6x663rvxz3ryb2gqks18qk1qli4k0m3hf7";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ mtl parsec stm time utf8String X11 X11Xft ];
  configureFlags = "-fwith_xft";
  meta = {
    homepage = "http://projects.haskell.org/xmobar/";
    description = "A Minimalistic Text Based Status Bar";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
