{ stdenv, fetchurl, x11, imlib2, libjpeg, libpng, giblib }:

stdenv.mkDerivation {
  name = "feh-1.3.4";

  src = fetchurl {
    url = http://linuxbrit.co.uk/downloads/feh-1.3.4.tar.gz;
    sha256 = "091iz2id5z80vn2qxg0ipwncv5bv8i9ifw2q15ja9zazq6xz5fc1";
  };

  buildInputs = [x11 imlib2 giblib libjpeg libpng];

  meta = {
    description = "A light-weight image viewer";
    homepage = http://linuxbrit.co.uk/feh/;
  };
}
