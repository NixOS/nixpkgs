{ lib, stdenv, fetchurl, gmp, mpfr, boost }:

stdenv.mkDerivation {
  name = "gappa-1.4.0";

  src = fetchurl {
    url = "https://gforge.inria.fr/frs/download.php/file/38044/gappa-1.4.0.tar.gz";
    sha256 = "sha256-/IDIf5XnFBqVllgH5GtQ6C8g7vxheaVcXNoZiXlsPGA=";
  };

  buildInputs = [ gmp mpfr boost.dev ];

  buildPhase = "./remake";
  installPhase = "./remake install";

  meta = {
    homepage = "http://gappa.gforge.inria.fr/";
    description = "Verifying and formally proving properties on numerical programs dealing with floating-point or fixed-point arithmetic";
    license = with lib.licenses; [ cecill20 gpl2 ];
    maintainers = with lib.maintainers; [ vbgl ];
    platforms = lib.platforms.all;
  };
}
