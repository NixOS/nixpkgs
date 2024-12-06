{ lib, stdenv, fetchFromGitHub, cmake, doxygen }:

stdenv.mkDerivation rec {
  pname = "ogdf";
  version = "2022.02";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "dogwood-202202";
    sha256 = "sha256-zkQ6sS0EUmiigv3T7To+tG3XbFbR3XEbFo15oQ0bWf0=";
  };

  nativeBuildInputs = [ cmake doxygen ];

  cmakeFlags = [
    "-DCMAKE_CXX_FLAGS=-fPIC"
    "-DBUILD_SHARED_LIBS=ON"
    "-DOGDF_WARNING_ERRORS=OFF"
  ];

  meta = with lib; {
    description = "Open Graph Drawing Framework/Open Graph algorithms and Data structure Framework";
    homepage = "http://www.ogdf.net";
    license = licenses.gpl2;
    maintainers = [ maintainers.ianwookim ];
    platforms = platforms.all;
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
