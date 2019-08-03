{ stdenv, fetchurl, gmp, mpfr, boost }:

stdenv.mkDerivation {
  name = "gappa-1.3.5";

  src = fetchurl {
    url = https://gforge.inria.fr/frs/download.php/file/38044/gappa-1.3.5.tar.gz;
    sha256 = "0q1wdiwqj6fsbifaayb1zkp20bz8a1my81sqjsail577jmzwi07w";
  };

  buildInputs = [ gmp mpfr boost.dev ];

  buildPhase = "./remake";
  installPhase = "./remake install";

  meta = {
    homepage = http://gappa.gforge.inria.fr/;
    description = "Verifying and formally proving properties on numerical programs dealing with floating-point or fixed-point arithmetic";
    license = with stdenv.lib.licenses; [ cecill20 gpl2 ];
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
    platforms = stdenv.lib.platforms.all;
  };
}
