{cabal, xmonad, xmonadContrib, X11, utf8String, X11Xft,
 parsec, split}:

cabal.mkDerivation (self : {
  pname = "xmonad-extras";
  version = "0.9.2";
  sha256 = "54b41a4c59ff3d68b3a214d727fb5675fa7c1b90090d99e58ecae62b3dfdd701";
  propagatedBuildInputs =
    [X11 xmonad xmonadContrib utf8String X11Xft parsec split];
  noHaddock = true;
  meta = {
    description = "Various modules for xmonad that cannot be added to xmonad-contrib because of additional dependencies";
  };
})
