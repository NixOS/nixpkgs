{ cabal, Cabal, extensibleExceptions, mtl, random, utf8String, X11
, X11Xft, xmonad
}:

cabal.mkDerivation (self: {
  pname = "xmonad-contrib";
  version = "0.10";
  sha256 = "0lp7qr69rpjy4s3knhdgh2bp6zs81xp0az1lisv4a2i7i1ys7hfq";
  buildDepends = [
    Cabal extensibleExceptions mtl random utf8String X11 X11Xft xmonad
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
