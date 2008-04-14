{cabal, xmonad, X11}:

cabal.mkDerivation (self : {
  pname = "xmonad-contrib";
  name = "${self.fname}";
  version = "0.7";
  sha256 = "4034d0c8ce092fc9b4e9d9ecf89bc9c16c4ac28aad190f074edc9e4201db0697";
  extraBuildInputs = [X11 xmonad];
  meta = {
    description = "a huge extension library for xmonad";
  };
})
