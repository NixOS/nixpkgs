{ cabal, extensibleExceptions, filepath, mtl, utf8String, X11 }:

cabal.mkDerivation (self: {
  pname = "xmonad";
  version = "0.11";
  sha256 = "1nsv88y2b206n3s5hrsp5ginvz1bj818ns7jmikavb2g33akdgg5";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    extensibleExceptions filepath mtl utf8String X11
  ];
  postInstall = ''
    mkdir -p $out/share/man/man1
    mv $out/share/xmonad-*/man/*.1 $out/share/man/man1/
  '';
  meta = {
    homepage = "http://xmonad.org";
    description = "A tiling window manager";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
