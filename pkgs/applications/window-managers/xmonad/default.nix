{cabal, X11, mtl, xmessage}:

cabal.mkDerivation (self : {
  pname = "xmonad";
  name = "${self.fname}";
  version = "0.9.1";
  sha256 = "014201200e8a521ee3a0d8c0727392916a7549207b91064fb456f8c660609927";
  propagatedBuildInputs = [X11 mtl];
  meta = {
    description = "xmonad is a tiling window manager for X";
  };

  preConfigure = '' 
    substituteInPlace XMonad/Core.hs --replace \
      '"xmessage"' '"${xmessage}/bin/xmessage"'
  '';
})
