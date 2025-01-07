{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  blas,
  lapack,
}:

stdenv.mkDerivation rec {
  pname = "hmat-oss";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "jeromerobert";
    repo = "hmat-oss";
    rev = "refs/tags/${version}";
    sha256 = "sha256-GnFlvZCEzSCcBVLjFWLe+AKXVA6UMs/gycrOJ2TBqrE=";
  };

  cmakeFlags = [
    "-DHMAT_GIT_VERSION=OFF"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    blas
    lapack
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Hierarchical matrix C/C++ library";
    homepage = "https://github.com/jeromerobert/hmat-oss";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ gdinh ];
  };
}
