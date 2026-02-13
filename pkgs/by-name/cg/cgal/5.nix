{
  lib,
  stdenv,
  fetchurl,
  cmake,
  boost,
  gmp,
  mpfr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cgal";
  version = "5.6.2";

  src = fetchurl {
    url = "https://github.com/CGAL/cgal/releases/download/v${finalAttrs.version}/CGAL-${finalAttrs.version}.tar.xz";
    hash = "sha256-RY9g346PHy/a2TyPJOGqj0sJXMYaFPrIG5BoDXMGpC4=";
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

  meta = {
    description = "Computational Geometry Algorithms Library";
    homepage = "http://cgal.org";
    license = with lib.licenses; [
      gpl3Plus
      lgpl3Plus
    ];
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.raskin ];
  };
})
