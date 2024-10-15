{
  lib,
  SDL2,
  cmake,
  fetchFromGitHub,
  ffmpeg,
  libX11,
  libXdmcp,
  libxcb,
  lua5_1,
  minizip,
  pkg-config,
  qt5,
  qt6,
  stdenv,
  x264,
  # Configurable options
  ___qtVersion ? "5",
}:

let
  qtVersionDictionary = {
    "5" = qt5;
    "6" = qt6;
  };
  inherit (qtVersionDictionary.${___qtVersion}) qttools wrapQtAppsHook;
in
assert lib.elem ___qtVersion [
  "5"
  "6"
];
stdenv.mkDerivation (finalAttrs: {
  pname = "fceux";
  version = "2.6.6-unstable-2024-01-19";

  src = fetchFromGitHub {
    owner = "TASEmulators";
    repo = "fceux";
    rev = "2fce5ffe745bb89be471e450d9cd6284cd5614d9";
    hash = "sha256-5uUTw7ZkmBrGuntSQFNAp1Xz69ANmmIxNGd0/enPoW8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    SDL2
    ffmpeg
    libX11
    libXdmcp
    libxcb
    lua5_1
    minizip
    qttools
    x264
  ];

  strictDeps = true;

  meta = {
    homepage = "http://www.fceux.com/";
    description = "Nintendo Entertainment System (NES) Emulator";
    changelog = "https://github.com/TASEmulators/blob/fceux/${finalAttrs.src.rev}/changelog.txt";
    license = with lib.licenses; [ gpl2Plus ];
    mainProgram = "fceux";
    maintainers = with lib.maintainers; [
      AndersonTorres
      sbruder
    ];
    platforms = lib.platforms.linux;
  };
})
