{cabal, X11, mtl, parsec, stm, utf8String, X11Xft}:

cabal.mkDerivation (self : {
  pname = "xmobar";
  name = "${self.fname}";
  version = "0.9.2";
  sha256 = "361295f5dc912512a2eb644ecd331562a271243192be6215cb071e44f50c7c66";
  extraBuildInputs = [X11 mtl parsec stm utf8String X11Xft];
  meta = {
    description = "xmobar is a minimalistic text based status bar";
  };
})
