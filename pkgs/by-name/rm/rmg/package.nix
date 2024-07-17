{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  boost,
  cmake,
  discord-rpc,
  freetype,
  hidapi,
  libpng,
  libsamplerate,
  minizip,
  nasm,
  pkg-config,
  qt6Packages,
  SDL2,
  speexdsp,
  vulkan-headers,
  vulkan-loader,
  which,
  xdg-user-dirs,
  zlib,
  withWayland ? false,
  # Affects final license
  withAngrylionRdpPlus ? false,
}:

let
  inherit (qt6Packages)
    qtbase
    qtsvg
    qtwayland
    wrapQtAppsHook
    ;
in
stdenv.mkDerivation rec {
  pname = "rmg";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "Rosalie241";
    repo = "RMG";
    rev = "v${version}";
    hash = "sha256-j3OVhcTGUXPC0+AqvAJ7+mc+IFqJeBITU99pvfXIunQ=";
  };

  patches = [
    # Fix bad concatenation of CMake GNUInstallDirs variables, causing broken asset lookup paths
    # Remove when version > 0.5.7
    (fetchpatch {
      name = "0001-rmg-Fix-GNUInstallDirs-usage.patch";
      url = "https://github.com/Rosalie241/RMG/commit/685aa597c7ee7ad7cfd4dd782f40d21863b75899.patch";
      hash = "sha256-HnaxUAX+3Z/VTtYYuhoXOtsDtV61nskgyzEcp8fdBsU=";
    })
  ];

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
  ] ++ lib.optional withWayland qtwayland;

  cmakeFlags = [
    "-DPORTABLE_INSTALL=OFF"
    # mupen64plus-input-gca is written in Rust, so we can't build it with
    # everything else.
    "-DNO_RUST=ON"
    "-DUSE_ANGRYLION=${lib.boolToString withAngrylionRdpPlus}"
  ];

  qtWrapperArgs =
    lib.optionals stdenv.isLinux [
      "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}"
    ]
    ++ lib.optional withWayland "--set RMG_WAYLAND 1";

  meta = with lib; {
    homepage = "https://github.com/Rosalie241/RMG";
    description = "Rosalie's Mupen GUI";
    longDescription = ''
      Rosalie's Mupen GUI is a free and open-source mupen64plus front-end
      written in C++. It offers a simple-to-use user interface.
    '';
    license = if withAngrylionRdpPlus then licenses.unfree else licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "RMG";
    maintainers = with maintainers; [ slam-bert ];
  };
}
