{ lib
, stdenv
, mkDerivation
, fetchurl
, cmake
, doxygen
, graphviz
, boost
, cgal_5
, gdal
, glew
, gmp
, libGL
, libGLU
, mpfr
, proj
, python3
, qtxmlpatterns
, qwt
}:

let
  python = python3.withPackages (ps: with ps; [
    numpy
  ]);
  boost' = boost.override {
    enablePython = true;
    inherit python;
  };
  cgal = cgal_5.override {
    boost = boost';
  };
in mkDerivation rec {
  pname = "gplates";
  version = "2.3.0";

  src = fetchurl {
    name = "gplates_${version}_src.tar.bz2";
    url = "https://www.earthbyte.org/download/8421/?uid=b89bb31428";
    sha256 = "0lrcmcxc924ixddii8cyglqlwwxvk7f00g4yzbss5i3fgcbh8n96";
  };

  patches = [
    ./boost-placeholders.patch
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
  ];

  buildInputs = [
    boost'
    cgal
    gdal
    glew
    gmp
    libGL
    libGLU
    mpfr
    proj
    python
    qtxmlpatterns
    qwt
  ];

  meta = with lib; {
    description = "Desktop software for the interactive visualisation of plate-tectonics";
    homepage = "https://www.gplates.org";
    license = licenses.gpl2Only;
    platforms = platforms.all;
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/gplates.x86_64-darwin
  };
}
