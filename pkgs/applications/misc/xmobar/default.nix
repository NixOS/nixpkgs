{ cabal, libXrandr, mtl, parsec, stm, time, utf8String, X11, X11Xft
}:

cabal.mkDerivation (self: {
  pname = "xmobar";
  version = "0.14";
  sha256 = "1y26b2a5v9hxv1zmjcb4m8j9qkqdn74mqc3q58vgp5cav45rphvh";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ mtl parsec stm time utf8String X11 X11Xft ];
  extraLibraries = [ libXrandr ];
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
