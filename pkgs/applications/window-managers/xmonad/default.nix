{cabal, X11, mtl, xmessage}:

cabal.mkDerivation (self : {
  pname = "xmonad";
  name = "${self.fname}";
  version = "0.9";
  sha256 = "51670f83de211a8ea24ce2724c71ac5c3e4782f25422319d8b5e43f3ae7bf9e8";
  propagatedBuildInputs = [X11 mtl];
  meta = {
    description = "xmonad is a tiling window manager for X";
  };

  preConfigure = '' 
    substituteInPlace XMonad/Core.hs --replace \
      '"xmessage"' '"${xmessage}/bin/xmessage"'
  '';
})
