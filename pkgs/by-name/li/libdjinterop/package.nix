{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
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

  patches = [
    # https://github.com/xsco/libdjinterop/pull/161
    (fetchpatch2 {
      url = "https://github.com/xsco/libdjinterop/commit/94ce315cd5155bd031eeccfec12fbeb8e399dd14.patch";
      hash = "sha256-WahMsFeetSlHHiIyaC04YxTiXDxD1ooASqoIP2TK9R0=";
    })
  ];

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
