{
  lib,
  stdenv,
  SDL2,
  cmake,
  fetchFromGitHub,
  ffmpeg,
  libx11,
  libxdmcp,
  libxcb,
  lua5_1,
  minizip,
  pkg-config,
  qt5,
  qt6,
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
  version = "2.6.6-unstable-2026-04-13";

  src = fetchFromGitHub {
    owner = "TASEmulators";
    repo = "fceux";
    rev = "1e1168db6662ce86848460b5d078e17c6dc6e2ce";
    hash = "sha256-FHNMDvEMgKnZjpm0DEN2rj0aI3T244zfcS+NEYWytaU=";
  };

  patches = [
    # https://github.com/TASEmulators/fceux/pull/834
    ./0001-cmake-fix-qt6-build-on-linux.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    SDL2
    ffmpeg
    libx11
    libxdmcp
    libxcb
    lua5_1
    minizip
    qttools
    x264
  ];

  strictDeps = true;

  postInstall = ''
    substituteInPlace $out/share/applications/fceux.desktop \
      --replace-fail "/usr/bin/" "" \
      --replace-fail "/usr/share/pixmaps/" ""
  '';

  meta = {
    homepage = "http://www.fceux.com";
    description = "Nintendo Entertainment System (NES) Emulator";
    changelog = "https://github.com/TASEmulators/fceux/blob/${finalAttrs.src.rev}/changelog.txt";
    license = with lib.licenses; [ gpl2Plus ];
    mainProgram = "fceux";
    maintainers = with lib.maintainers; [ kuflierl ];
    platforms = lib.platforms.linux;
  };
})
