{stdenv, fetchurl, x11, imlib2, libjpeg, libpng}:

let

  giblib = stdenv.mkDerivation {
    name = "giblib-1.2.4";
    src = fetchurl {
      url = http://linuxbrit.co.uk/downloads/giblib-1.2.4.tar.gz;
      sha256 = "1b4bmbmj52glq0s898lppkpzxlprq9aav49r06j2wx4dv3212rhp";
    };
    buildInputs = [x11 imlib2];
  };

in
  
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
