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
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "melonDS-emu";
    repo = "melonDS";
    rev = finalAttrs.version;
    hash = "sha256-n4Vkxb/7fr214PgB6VFNgH1tMDgTBS/UHUQ6V4uGkDA=";
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
