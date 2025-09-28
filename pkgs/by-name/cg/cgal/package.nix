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
  version = "6.0.2";

  src = fetchurl {
    url = "https://github.com/CGAL/cgal/releases/download/v${version}/CGAL-${version}.tar.xz";
    sha256 = "sha256-8wxb58JaKj6iS8y6q1z2P6/aY8AnnzTX5/izISgh/tY=";
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
