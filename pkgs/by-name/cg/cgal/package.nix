{
  lib,
  stdenv,
  fetchurl,
  cmake,
  boost,
  gmp,
  mpfr,
}:

stdenv.mkDerivation rec {
  pname = "cgal";
  version = "6.0.1";

  src = fetchurl {
    url = "https://github.com/CGAL/cgal/releases/download/v${version}/CGAL-${version}.tar.xz";
    sha256 = "0zwvyp096p0vx01jks9yf74nx6zjh0vjbwr6sl6n6mn52zrzpk8a";
  };

  # note: optional component libCGAL_ImageIO would need zlib and opengl;
  #   there are also libCGAL_Qt{3,4} omitted ATM
  buildInputs = [
    boost
    gmp
    mpfr
  ];
  nativeBuildInputs = [ cmake ];

  patches = [ ./cgal_path.patch ];

  doCheck = false;

  meta = with lib; {
    description = "Computational Geometry Algorithms Library";
    homepage = "http://cgal.org";
    license = with licenses; [
      gpl3Plus
      lgpl3Plus
    ];
    platforms = platforms.all;
    maintainers = with lib.maintainers; [
      raskin
      drew-dirac
      ylannl
    ];
  };
}
