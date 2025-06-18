{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doxygen,
}:

stdenv.mkDerivation {
  pname = "ogdf";
  version = "2023.09";

  src = fetchFromGitHub {
    owner = "ogdf";
    repo = "ogdf";
    tag = "elderberry-202309";
    hash = "sha256-vnhPuMhz+pE4ExhRhjwHy4OilIkJ/kXc2LWU+9auY9k=";
  };

  nativeBuildInputs = [
    cmake
    doxygen
  ];

  cmakeFlags = [
    "-DCMAKE_CXX_FLAGS=-fPIC"
    "-DBUILD_SHARED_LIBS=ON"
    "-DOGDF_WARNING_ERRORS=OFF"
  ];

  meta = {
    description = "Open Graph Drawing Framework/Open Graph algorithms and Data structure Framework";
    homepage = "http://www.ogdf.net";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.ianwookim ];
    platforms = lib.platforms.all;
    longDescription = ''
      OGDF stands both for Open Graph Drawing Framework (the original name) and
      Open Graph algorithms and Data structures Framework.

      OGDF is a self-contained C++ library for graph algorithms, in particular
      for (but not restricted to) automatic graph drawing. It offers sophisticated
      algorithms and data structures to use within your own applications or
      scientific projects.

      OGDF is developed and supported by Osnabrück University, TU Dortmund,
      University of Cologne, University of Konstanz, and TU Ilmenau.
    '';
  };
}
