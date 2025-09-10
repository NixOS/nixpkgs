{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  fuse,
  zlib,
  bzip2,
  openssl,
  libxml2,
  icu,
  lzfse,
  libiconv,
  nixosTests,
}:

stdenv.mkDerivation {
  pname = "darling-dmg";
  version = "1.0.4-unstable-2023-07-26";

  src = fetchFromGitHub {
    owner = "darlinghq";
    repo = "darling-dmg";
    rev = "a36bf0c07b16675b446377890c5f6f74563f84dd";
    hash = "sha256-QM75GuFHl2gRlRw1BmTexUE1d9YNnhG0qmTqmE9kMX4=";
  };

  patches = [
    # Fix compilation
    (fetchpatch2 {
      name = "cmake-cxx-standard-17.patch";
      url = "https://github.com/darlinghq/darling-dmg/pull/105/commits/b7c620f76a5f76748b3d14dd2a58e77f8b6ed0c0.patch";
      hash = "sha256-i1lisEiwYm4IxgKmBYnjscvW6ObT7XGLVbjW2i5yXV4=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    fuse
    openssl
    zlib
    bzip2
    libxml2
    icu
    lzfse
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  CXXFLAGS = [
    "-DCOMPILE_WITH_LZFSE=1"
    "-llzfse"
  ];

  passthru.tests = {
    inherit (nixosTests) darling-dmg;
  };

  meta = with lib; {
    homepage = "https://www.darlinghq.org/";
    description = "FUSE module for .dmg files (containing an HFS+ filesystem)";
    mainProgram = "darling-dmg";
    platforms = platforms.unix;
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Luflosi ];
  };
}
