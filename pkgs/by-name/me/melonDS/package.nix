{
  lib,
  SDL2,
  cmake,
  enet,
  extra-cmake-modules,
  fetchFromGitHub,
  libGL,
  libarchive,
  libpcap,
  libslirp,
  pkg-config,
  qt6,
  stdenv,
  unstableGitUpdater,
  wayland,
  zstd,
}:

let
  inherit (qt6)
    qtbase
    qtmultimedia
    qtwayland
    wrapQtAppsHook
    ;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "melonDS";
  version = "0.9.5-unstable-2024-08-11";

  src = fetchFromGitHub {
    owner = "melonDS-emu";
    repo = "melonDS";
    rev = "e290c42360f5f2ae7182c5430234545f3b066876";
    hash = "sha256-idsUxEsR9MPAY3arH4UNEsB6Cds4yZUaZOilqUQCnDE";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs =
    [
      SDL2
      enet
      extra-cmake-modules
      libarchive
      libslirp
      libGL
      qtbase
      qtmultimedia
      zstd
    ]
    ++ lib.optionals stdenv.isLinux [
      wayland
      qtwayland
    ];

  cmakeFlags = [ (lib.cmakeBool "USE_QT6" true) ];

  strictDeps = true;

  qtWrapperArgs =
    lib.optionals stdenv.isLinux [
      "--prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libpcap
          wayland
        ]
      }"
    ]
    ++ lib.optionals stdenv.isDarwin [
      "--prefix DYLD_LIBRARY_PATH : ${lib.makeLibraryPath [ libpcap ]}"
    ];

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = {
    homepage = "https://melonds.kuribo64.net/";
    description = "Work in progress Nintendo DS emulator";
    longDescription = ''
      melonDS aims at providing fast and accurate Nintendo DS emulation. While
      it is still a work in progress, it has a pretty solid set of features:

      - Nearly complete core (CPU, video, audio, ...)
      - JIT recompiler for fast emulation
      - OpenGL renderer, 3D upscaling
      - RTC, microphone, lid close/open
      - Joystick support
      - Savestates
      - Various display position/sizing/rotation modes
      - (WIP) Wifi: local multiplayer, online connectivity
      - (WIP) DSi emulation
      - DLDI
      - (WIP) GBA slot add-ons
      - and more are planned!
    '';
    license = with lib.licenses; [ gpl3Plus ];
    mainProgram = "melonDS";
    maintainers = with lib.maintainers; [
      AndersonTorres
      artemist
      benley
      shamilton
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
