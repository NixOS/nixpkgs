{cabal, X11, mtl, xmessage, syb}:

cabal.mkDerivation (self: {
  pname = "xmonad";
  name = "${self.fname}";
  version = "0.9.2";
  sha256 = "07w5k3pqmybjn0zh2nr1glp69685xg2fhj3z9zxb37x5nzss7kdd";
  noHaddock = true;
  propagatedBuildInputs = [X11 mtl syb];
  meta = {
    homepage = "http://xmonad.org";
    description = "A tiling window manager";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };

  preConfigure = '' 
    substituteInPlace XMonad/Core.hs --replace \
      '"xmessage"' '"${xmessage}/bin/xmessage"'
  '';
})
