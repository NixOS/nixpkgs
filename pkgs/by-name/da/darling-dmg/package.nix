{
  lib,
  stdenv,
  fetchFromGitHub,
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

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    fuse
    openssl
    zlib
    bzip2
    libxml2
    icu
    lzfse
  ] ++ lib.optionals stdenv.isDarwin [ libiconv ];

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
