{
  lib,
  stdenv,
  fetchurl,
  gmp,
  mpfr,
  boost,
}:

stdenv.mkDerivation rec {
  pname = "gappa";
  version = "1.4.0";

  src = fetchurl {
    url = "https://gforge.inria.fr/frs/download.php/file/38436/gappa-${version}.tar.gz";
    sha256 = "12x42z901pr05ldmparqdi8sq9s7fxbavhzk2dbq3l6hy247dwbb";
  };

  buildInputs = [
    gmp
    mpfr
    boost.dev
  ];

  buildPhase = "./remake";
  installPhase = "./remake install";

  meta = with lib; {
    homepage = "http://gappa.gforge.inria.fr/";
    description = "Verifying and formally proving properties on numerical programs dealing with floating-point or fixed-point arithmetic";
    mainProgram = "gappa";
    license = with licenses; [
      cecill20
      gpl2
    ];
    maintainers = with maintainers; [ vbgl ];
    platforms = platforms.all;
  };
}
