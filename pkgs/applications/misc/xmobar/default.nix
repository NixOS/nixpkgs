{ cabal, filepath, libXrandr, mtl, parsec, stm, time, utf8String
, wirelesstools, X11, X11Xft
}:

cabal.mkDerivation (self: {
  pname = "xmobar";
  version = "0.17";
  sha256 = "0ahb3xqxcfvpgxyb901bpl4i56mnslzwplcqxrr13glngcl7d25s";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    filepath mtl parsec stm time utf8String X11 X11Xft
  ];
  extraLibraries = [ libXrandr wirelesstools ];
  configureFlags = "-fwith_xft -fwith_iwlib";
  meta = {
    homepage = "http://projects.haskell.org/xmobar/";
    description = "A Minimalistic Text Based Status Bar";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
