{cabal, X11, mtl, parsec, stm, utf8String, X11Xft}:

cabal.mkDerivation (self : {
  pname = "xmobar";
  name = "${self.fname}";
  version = "0.12";
  sha256 = "633b7985dbaebd58864f591ea7ff8b44f5a69b4e3d0a592df01daf8fe11a5d31";
  extraBuildInputs = [X11 mtl parsec stm utf8String X11Xft];
  configureFlags = "--flags=with_xft";
  meta = {
    description = "xmobar is a minimalistic text based status bar";
  };
})
