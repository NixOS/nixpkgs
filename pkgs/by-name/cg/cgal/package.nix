{
  lib,
  stdenv,
  fetchurl,
  cmake,
  boost,
  gmp,
  mpfr,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cgal";
  version = "6.0.2";

  src = fetchurl {
    url = "https://github.com/CGAL/cgal/releases/download/v${finalAttrs.version}/CGAL-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-8wxb58JaKj6iS8y6q1z2P6/aY8AnnzTX5/izISgh/tY=";
  };

  patches = [ ./cgal_path.patch ];

  nativeBuildInputs = [ cmake ];

  # note: optional component libCGAL_ImageIO would need zlib and opengl;
  #   there are also libCGAL_Qt{3,4} omitted ATM
  buildInputs = [
    gmp
    mpfr
  ];

  propagatedBuildInputs = [
    boost
  ];

  doCheck = false;

  passthru = {
    tests = {
      cmake-config = testers.hasCmakeConfigModules {
        moduleNames = [ "CGAL" ];
        package = finalAttrs.finalPackage;
      };
    };
  };

  meta = {
    description = "Computational Geometry Algorithms Library";
    homepage = "http://cgal.org";
    license = with lib.licenses; [
      gpl3Plus
      lgpl3Plus
    ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      raskin
      drew-dirac
      ylannl
    ];
  };
})
