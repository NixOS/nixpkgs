{lib, stdenv, fetchFromGitHub, gmp, cmake, python3}:

stdenv.mkDerivation rec {
  pname = "libpoly";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "SRI-CSL";
    repo = "libpoly";
    # they've pushed to the release branch, use explicit tag
    rev = "refs/tags/v${version}";
    sha256 = "sha256-vrYB6RQYShipZ0c0j1KcSTJR1h0rQKAAeJvODMar1GM=";
  };

  # https://github.com/SRI-CSL/libpoly/pull/52
  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace src/CMakeLists.txt --replace \
      '"utils/open_memstream.c ''${poly_SOURCES}"' \
      'utils/open_memstream.c ''${poly_SOURCES}'
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [ gmp python3 ];

  strictDeps = true;

  meta = with lib; {
    homepage = "https://github.com/SRI-CSL/libpoly";
    description = "C library for manipulating polynomials";
    license = licenses.lgpl3;
    platforms = platforms.all;
  };
}
