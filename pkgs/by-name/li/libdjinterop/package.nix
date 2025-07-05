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

stdenv.mkDerivation (finalAttrs: {
  name = "libdjinterop";

  version = "0.26.1";

  src = fetchFromGitHub {
    owner = "xsco";
    repo = "libdjinterop";
    rev = finalAttrs.version;
    hash = "sha256-HwNhCemqVR1xNSbcht0AuwTfpRhVi70ZH5ksSTSRFoc=";
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
})
