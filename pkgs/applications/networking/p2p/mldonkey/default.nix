{stdenv, fetchurl, ocaml, zlib, bzip2, ncurses, file, gd, libpng }:

stdenv.mkDerivation {
  name = "mldonkey-3.0.1";
  
  src = fetchurl {
    url = "mirror://sourceforge/mldonkey/mldonkey-3.0.1.tar.bz2";
    sha256 = "09zk53rfdkjipf5sl37rypzi2mx0a5v57vsndj22zajkqr4l0zds";
  };
  
  meta = {
    description = "Client for many p2p networks, with multiple frontends";
    homepage = http://mldonkey.sourceforge.net/;
  };

  buildInputs = [ ocaml zlib ncurses bzip2 file gd libpng ];
  configureFlags = [ "--disable-gui" "--enable-ocamlver=3.11.1" ];
}
