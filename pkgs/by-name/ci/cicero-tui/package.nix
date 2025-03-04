{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  expat,
  fontconfig,
  freetype,
}:

rustPlatform.buildRustPackage rec {
  pname = "cicero-tui";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "eyeplum";
    repo = "cicero-tui";
    rev = "v${version}";
    sha256 = "sha256-2raSkIycXCdT/TSlaQviI6Eql7DONgRVsPP2B2YuW8U=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    expat
    fontconfig
    freetype
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "unic-0.9.0" = "sha256-ZE4C+rrtmHdqTmenP5c7QGNTW/n7pi8nh7lqLhHgi3w=";
    };
  };

  meta = with lib; {
    description = "Unicode tool with a terminal user interface";
    homepage = "https://github.com/eyeplum/cicero-tui";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
    mainProgram = "cicero";
  };
}
