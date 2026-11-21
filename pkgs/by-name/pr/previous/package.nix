{
  lib,
  stdenv,
  fetchsvn,
  cmake,
  SDL2,
  libpcap,
  libpng,
  zlib,
  readline,
  copyDesktopItems,
  makeDesktopItem,
}:

let
  revision = "1667";
in
stdenv.mkDerivation {
  pname = "previous";
  version = "3.9-unstable-2025-07-21";

  src = fetchsvn {
    url = "svn://svn.code.sf.net/p/previous/code/trunk";
    rev = revision;
    hash = "sha256-/uAcYwWgGPFVlH6Klp5BXxnVdoBI30FZjmDqQRUEofM=";
  };

  nativeBuildInputs = [
    cmake
    SDL2 # for sdl-config during build time
    copyDesktopItems
  ];
  buildInputs = [
    libpcap
    libpng
    zlib
    readline
  ];

  cmakeFlags = [
    "-Wno-dev" # suppress noisy cmake warnings
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "previous";
      exec = "previous";
      icon = "Previous-icon.bmp";
      comment = "NeXT 68k workstation emulator";
      desktopName = "previous";
      categories = [
        "Emulator"
        "System"
      ];
    })
  ];

  postInstall = ''
    cp src/ditool/ditool $out/bin/
  '';

  meta = {
    description = "NeXT computer hardware emulator";
    homepage = "https://previous.unixdude.net/";
    downloadPage = "https://sourceforge.net/projects/previous/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ tesuji ];
    platforms = lib.platforms.linux;
    mainProgram = "previous";
  };
}
