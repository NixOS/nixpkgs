{cabal, X11, mtl, xmessage}:

cabal.mkDerivation (self : {
  pname = "xmonad";
  name = "${self.fname}";
  version = "0.8.1";
  sha256 = "9d58789a0bc08d40b9d14097b079822c7b8290d60efc6aa79144abf47d5db32c";
  propagatedBuildInputs = [X11 mtl];
  meta = {
    description = "xmonad is a tiling window manager for X";
  };

  preConfigure = '' 
    substituteInPlace XMonad/Core.hs --replace \
      '"xmessage"' '"${xmessage}/bin/xmessage"'
  '';
})
