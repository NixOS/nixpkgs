{
  lib,
  stdenv,
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
  version = "2.6.6-unstable-2025-01-20";

  src = fetchFromGitHub {
    owner = "TASEmulators";
    repo = "fceux";
    rev = "2b8f6e76271341616920bb7e0c54ee48570783d3";
    hash = "sha256-2QDiAk2HO9oQ1gNvc7QFZSCbWkCDYW5OJWT8f4bmXyg=";
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
    maintainers = with lib.maintainers; [ sbruder ];
    platforms = lib.platforms.linux;
  };
})
