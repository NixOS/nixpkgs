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
  pname = "melonDS";
  version = "1.0rc-unstable-2025-06-18";

  src = fetchFromGitHub {
    owner = "melonDS-emu";
    repo = "melonDS";
    rev = "71edf793fcd2726c4212f7915194c60107dc2809";
    hash = "sha256-B/qWdt+fWSov54zA+7S25bEVxqQuspo5oT3MyMk4Ato=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs =
    [
      SDL2
      enet
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
    license = with lib.licenses; [ gpl3Plus ];
    mainProgram = "melonDS";
    maintainers = with lib.maintainers; [
      artemist
      benley
      shamilton
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
