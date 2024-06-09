{ lib
, SDL2
, cmake
, extra-cmake-modules
, fetchFromGitHub
, libGL
, libarchive
, libpcap
, libsForQt5
, libslirp
, pkg-config
, stdenv
, unstableGitUpdater
, wayland
, zstd
}:

let
  inherit (libsForQt5)
    qtbase
    qtmultimedia
    wrapQtAppsHook;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "melonDS";
  version = "0.9.5-unstable-2024-05-15";

  src = fetchFromGitHub {
    owner = "melonDS-emu";
    repo = "melonDS";
    rev = "a72b79a55ad2d61811af11b1b911f6af863f66c2";
    hash = "sha256-cdKfJ316iuRajdrRESt68oR8vkHISFRdHXxVuvGSUqE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    SDL2
    extra-cmake-modules
    libarchive
    libslirp
    libGL
    qtbase
    qtmultimedia
    wayland
    zstd
  ];

  strictDeps = true;

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libpcap ]}"
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
    platforms = lib.platforms.linux;
  };
})
