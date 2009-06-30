{stdenv, fetchurl, ocaml, zlib, ncurses}:

stdenv.mkDerivation {
  name = "mldonkey-3.0.0";
  
  src = fetchurl {
    url = mirror://sourceforge/mldonkey/mldonkey-3.0.0.tar.bz2;
    sha256 = "0zzvcfnbhxk8axfch5fbkd9j2ks67nbb1ndjjarxvrza78g5y8r7";
  };
  
  meta = {
    description = "Client for many p2p networks, with multiple frontends";
    homepage = http://mldonkey.sourceforge.net/;
  };

  buildInputs = [ ocaml zlib ncurses ];
  configureFlags = "--disable-gd --disable-gui";
}
