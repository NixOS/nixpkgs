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
  version = "2.6.6-unstable-2024-06-09";

  src = fetchFromGitHub {
    owner = "TASEmulators";
    repo = "fceux";
    rev = "f980ec2bc7dc962f6cd76b9ae3131f2eb902c9e7";
    hash = "sha256-baAjrTzRp61Lw1p5axKJ97PuFiuBNQewXrlN0s8o7us=";
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
