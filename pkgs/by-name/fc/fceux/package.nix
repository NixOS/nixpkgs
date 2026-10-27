{
  lib,
  stdenv,
  SDL2,
  cmake,
  fetchFromGitHub,
  ffmpeg_8,
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
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "TASEmulators";
    repo = "fceux";
    rev = "fceux-${finalAttrs.version}";
    hash = "sha256-SJ9axFIW3T8PykPnN6Itvxl6tkXKfrmbF880TtpcOVg=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    SDL2
    ffmpeg_8
    libx11
    libxdmcp
    libxcb
    lua5_1
    minizip
    qttools
    x264
  ];

  cmakeFlags = [ "-DGLVND=1" ];

  strictDeps = true;

  postInstall = ''
    substituteInPlace $out/share/applications/fceux.desktop \
      --replace-fail "/usr/bin/" "" \
      --replace-fail "/usr/share/pixmaps/" ""
  '';

  meta = {
    homepage = "http://www.fceux.com";
    description = "Nintendo Entertainment System (NES) Emulator";
    changelog = "https://github.com/TASEmulators/fceux/releases";
    license = lib.licenses.gpl2Plus;
    mainProgram = "fceux";
    maintainers = with lib.maintainers; [ kuflierl ];
    platforms = lib.platforms.linux;
  };
})
