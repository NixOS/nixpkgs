{ lib
, SDL2
, cmake
, extra-cmake-modules
, fetchFromGitHub
, libarchive
, libpcap
, libsForQt5
, libslirp
, libGL
, pkg-config
, stdenv
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
  version = "0.9.5-unstable-2024-01-17";

  src = fetchFromGitHub {
    owner = "melonDS-emu";
    repo = "melonDS";
    rev = "7897bd387bfd37615a049eba28d02dc23cfa5194";
    hash = "sha256-7BrUa8QJnudJkiCtuBdfar+FeeJSrdMGJdhXrPP6uww=";
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

  meta = {
    homepage = "https://melonds.kuribo64.net/";
    description = "Work in progress Nintendo DS emulator";
    license = with lib.licenses; [ gpl3Plus ];
    mainProgram = "melonDS";
    maintainers = with lib.maintainers; [
      AndersonTorres
      artemist
      benley
      shamilton
      xfix
    ];
    platforms = lib.platforms.linux;
  };
})
