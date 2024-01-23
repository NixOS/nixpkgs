{ lib
, stdenv
, fetchFromGitHub
, boost
, cmake
, discord-rpc
, freetype
, hidapi
, libpng
, libsamplerate
, minizip
, nasm
, pkg-config
, qt6Packages
, SDL2
, speexdsp
, vulkan-headers
, vulkan-loader
, which
, xdg-user-dirs
, zlib
}:

let
  inherit (qt6Packages) qtbase qtsvg wrapQtAppsHook;
in
stdenv.mkDerivation rec {
  pname = "rmg";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "Rosalie241";
    repo = "RMG";
    rev = "v${version}";
    hash = "sha256-au5GDyfW9+drkDNBWNbPY5Bgbow/hQmvP5pWJsYKbYs=";
  };

  nativeBuildInputs = [
    cmake
    nasm
    pkg-config
    wrapQtAppsHook
    which
  ];

  buildInputs = [
    boost
    discord-rpc
    freetype
    hidapi
    libpng
    libsamplerate
    minizip
    qtbase
    qtsvg
    SDL2
    speexdsp
    vulkan-headers
    vulkan-loader
    xdg-user-dirs
    zlib
  ];

  cmakeFlags = [
    "-DPORTABLE_INSTALL=OFF"
    # mupen64plus-input-gca is written in Rust, so we can't build it with
    # everything else.
    "-DNO_RUST=ON"
  ];

  qtWrapperArgs = lib.optionals stdenv.isLinux [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}"
  ];

  meta = with lib; {
    homepage = "https://github.com/Rosalie241/RMG";
    description = "Rosalie's Mupen GUI";
    longDescription = ''
      Rosalie's Mupen GUI is a free and open-source mupen64plus front-end
      written in C++. It offers a simple-to-use user interface.
    '';
    license = licenses.gpl3;
    platforms = platforms.linux;
    mainProgram = "RMG";
    maintainers = with maintainers; [ slam-bert ];
  };
}
