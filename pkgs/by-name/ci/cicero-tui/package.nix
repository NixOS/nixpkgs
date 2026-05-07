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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cicero-tui";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "eyeplum";
    repo = "cicero-tui";
    rev = "v${finalAttrs.version}";
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

  cargoHash = "sha256-D+CcUNVMgn8fiGcr+dYkQJoRHzpo3l5qTacCUKCydOQ=";

  meta = {
    description = "Unicode tool with a terminal user interface";
    homepage = "https://github.com/eyeplum/cicero-tui";
    license = with lib.licenses; [ gpl3Plus ];
    platforms = lib.platforms.linux;
    mainProgram = "cicero";
  };
})
