{ cabal, extensibleExceptions, mtl, utf8String, X11, xmessage }:

cabal.mkDerivation (self: {
  pname = "xmonad";
  version = "0.10";
  sha256 = "19z5y36pybsm93x6hlj5hzyys9r4ag7hkdib5spsnryk2mv72xj6";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ extensibleExceptions mtl utf8String X11 ];
  meta = {
    homepage = "http://xmonad.org";
    description = "A tiling window manager";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
    ];
  };

  preConfigure = ''
    substituteInPlace XMonad/Core.hs --replace \
      '"xmessage"' '"${xmessage}/bin/xmessage"'
  '';
})
