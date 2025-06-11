{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  cmake,
  ninja,
  pkg-config,
  sqlite,
  zlib,
}:

stdenv.mkDerivation {
  name = "libdjinterop";

  version = "unstable";

  src = fetchFromGitHub {
    owner = "xsco";
    repo = "libdjinterop";
    rev = "0.24.3";
    hash = "sha256-Fp7AwEOq2JOpL60GDAXmA15ptFeLoG79nnnPXHl1Hjw=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  outputs = [
    "out"
    "dev"
  ];

  buildInputs = [
    boost
    sqlite
    zlib
  ];

  meta = with lib; {
    homepage = "https://github.com/xsco/libdjinterop";
    description = "C++ library for access to DJ record libraries";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
