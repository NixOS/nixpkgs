{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "cista";
  version = "0.16";

  src = fetchFromGitHub {
    owner = "felixguendling";
    repo = "cista";
    rev = "v${version}";
    sha256 = "sha256-Q7IDQckFa/iMZ/f3Bim/yWyKCGqsNxJJ5C9PTToFZYI=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DCISTA_INSTALL=ON" ];

  meta = {
    homepage = "https://cista.rocks";
    description = "Simple, high-performance, zero-copy C++ serialization & reflection library";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sigmanificient ];
    platforms = lib.platforms.all;
  };
}
