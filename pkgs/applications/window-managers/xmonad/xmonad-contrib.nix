{cabal, xmonad, X11, utf8String, X11Xft}:

cabal.mkDerivation (self : {
  pname = "xmonad-contrib";
  version = "0.9.2";
  sha256 = "06hg5j4w8iz62wmyygq4c7xcbi9dxlhhh3dbic438cjk7c0w1h5p";
  propagatedBuildInputs = [X11 xmonad utf8String X11Xft];
  meta = {
    description = "a huge extension library for xmonad";
  };
})
