{stdenv, fetchurl, ocaml, zlib, ncurses}:

stdenv.mkDerivation {
  name = "mldonkey-2.9.6";
  
  src = fetchurl {
    url = mirror://sourceforge/mldonkey/mldonkey-2.9.6.tar.bz2;
    sha256 = "27cc8ae95aa7a2934b6cc9b077d10ca6a776496c051d8f35d60f1e73d38fd505";
  };
  
  meta = {
    description = "Client for many p2p networks, with multiple frontends";
    homepage = http://mldonkey.sourceforge.net/;
  };

  buildInputs = [ ocaml zlib ncurses ];
  configureFlags = "--disable-gd --disable-gui";
}
