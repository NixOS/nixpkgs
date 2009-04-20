{cabal, xmonad, X11}:

cabal.mkDerivation (self : {
  pname = "xmonad-contrib";
  name = "${self.fname}";
  version = "0.8.1";
  sha256 = "dedbd2e7718f7383e403f5f0b40d411f27099625e7e1dcddd42f7c12bf6488a9";
  extraBuildInputs = [X11 xmonad];
  meta = {
    description = "a huge extension library for xmonad";
  };
})
