{cabal, xmonad, X11, utf8String}:

cabal.mkDerivation (self : {
  pname = "xmonad-contrib";
  name = "${self.fname}";
  version = "0.9";
  sha256 = "f67471785eba323ac416f912d3503976ef6ed43e93e53fabf5621b2c93351ae9";
  propagatedBuildInputs = [X11 xmonad utf8String];
  meta = {
    description = "a huge extension library for xmonad";
  };
})
