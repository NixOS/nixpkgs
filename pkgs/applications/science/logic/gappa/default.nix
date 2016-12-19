{ stdenv, fetchurl, gmp, mpfr, boost }:

stdenv.mkDerivation {
  name = "gappa-1.2";

  src = fetchurl {
    url = https://gforge.inria.fr/frs/download.php/file/34787/gappa-1.2.0.tar.gz;
    sha256 = "03hfzmaf5jm54sjpbks20q7qixpmagrfbnyyc276vgmiyslk4dkh";
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
