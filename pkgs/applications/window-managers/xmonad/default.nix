{cabal, X11, xmessage}:

cabal.mkDerivation (self : {
  pname = "xmonad";
  name = "${self.fname}";
  version = "0.7";
  sha256 = "d5ee338eb6d0680082e20eaafa0b23b32358fffe69e2ec4ad7bdf6e03c751d67";
  extraBuildInputs = [X11];
  meta = {
    description = "xmonad is a tiling window manager for X";
  };

  preConfigure = '' 
    substituteInPlace XMonad/Core.hs --replace \
      '"xmessage"' '"${xmessage}/bin/xmessage"'
  '';
})
