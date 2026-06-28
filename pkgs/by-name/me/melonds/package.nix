{
  lib,
  SDL2,
  cmake,
  enet,
  kdePackages,
  fetchFromGitHub,
  faad2,
  libGL,
  libarchive,
  libpcap,
  libslirp,
  pipewire,
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
  pname = "melonds";
  version = "1.1-unstable-2026-06-07";

  src = fetchFromGitHub {
    owner = "melonDS-emu";
    repo = "melonDS";
    rev = "10a173b5536fc75cd93f8a3868349dad963542ef";
    hash = "sha256-YsVCU40BZgYoxyuscbD0Ab613eUIgYlXJkm0KJQg+yY=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.extra-cmake-modules
    SDL2
    enet
    faad2
    libarchive
    libslirp
    libGL
    qtbase
    qtmultimedia
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wayland
    qtwayland
  ];

  cmakeFlags = [ (lib.cmakeBool "USE_QT6" true) ];

  strictDeps = true;

  qtWrapperArgs =
    lib.optionals stdenv.hostPlatform.isLinux [
      "--prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libpcap
          pipewire
          wayland
        ]
      }"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
    license = with lib.licenses; gpl3Plus;
    mainProgram = "melonDS";
    maintainers = with lib.maintainers; [
      artemist
      benley
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
