{cabal, X11, mtl, xmessage, syb}:

cabal.mkDerivation (self : {
  pname = "xmonad";
  name = "${self.fname}";
  version = "0.9.2";
  sha256 = "07w5k3pqmybjn0zh2nr1glp69685xg2fhj3z9zxb37x5nzss7kdd";
  noHaddock = true;
  propagatedBuildInputs = [X11 mtl syb];
  meta = {
    description = "xmonad is a tiling window manager for X";
    homepage = http://xmonad.org/;
  };

  preConfigure = '' 
    substituteInPlace XMonad/Core.hs --replace \
      '"xmessage"' '"${xmessage}/bin/xmessage"'
  '';
})
