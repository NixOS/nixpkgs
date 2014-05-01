{ cabal, extensibleExceptions, mtl, random, utf8String, X11, X11Xft
, xmonad
}:

cabal.mkDerivation (self: {
  pname = "xmonad-contrib";
  version = "0.11.2";
  sha256 = "0qlc732m6mhvx7g10r69hk5x460kjv2r04s91cnn5yfiia1qfpai";
  buildDepends = [
    extensibleExceptions mtl random utf8String X11 X11Xft xmonad
  ];
  patchPhase = self.stdenv.lib.optional (self.stdenv.lib.versionOlder "7.8" self.ghc.version) ''
    sed -i -e 's|ForeignFunctionInterface|AllowAmbiguousTypes, ForeignFunctionInterface|' xmonad-contrib.cabal
  '';
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
