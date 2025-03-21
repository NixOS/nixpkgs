{
  lib,
  stdenv,
  fetchFromGitHub,
  nixosTests,
  alsa-lib,
  boost,
  cmake,
  cryptopp,
  glslang,
  ffmpeg,
  fmt,
  half,
  jack2,
  libdecor,
  libpulseaudio,
  libunwind,
  libusb1,
  magic-enum,
  libgbm,
  pkg-config,
  pugixml,
  qt6,
  rapidjson,
  renderdoc,
  robin-map,
  sdl3,
  sndio,
  stb,
  vulkan-headers,
  vulkan-loader,
  vulkan-memory-allocator,
  xorg,
  xxHash,
  zlib-ng,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "shadps4";
  version = "0.6.0-unstable-2025-03-18";

  src = fetchFromGitHub {
    owner = "shadps4-emu";
    repo = "shadPS4";
    rev = "171f755c139764d83e6fc712fcbbcc9d4c5c5956";
    hash = "sha256-vYOI4ffKN8QPg6om3T0PUu2I/K84Y7Hn2iUfVHi7N7o=";
    fetchSubmodules = true;
  };

  buildInputs = [
    alsa-lib
    boost
    cryptopp
    glslang
    ffmpeg
    fmt
    half
    jack2
    libdecor
    libpulseaudio
    libunwind
    libusb1
    xorg.libX11
    xorg.libXext
    magic-enum
    libgbm
    pugixml
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtmultimedia
    qt6.qttools
    qt6.qtwayland
    rapidjson
    renderdoc
    robin-map
    sdl3
    sndio
    stb
    vulkan-headers
    vulkan-loader
    vulkan-memory-allocator
    xxHash
    zlib-ng
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_QT_GUI" true)
    (lib.cmakeBool "ENABLE_UPDATER" false)
  ];

  # Still in development, help with debugging
  cmakeBuildType = "RelWithDebugInfo";
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    install -D -t $out/bin shadps4
    install -Dm644 $src/.github/shadps4.png $out/share/icons/hicolor/512x512/apps/net.shadps4.shadPS4.png
    install -Dm644 -t $out/share/applications $src/dist/net.shadps4.shadPS4.desktop
    install -Dm644 -t $out/share/metainfo $src/dist/net.shadps4.shadPS4.metainfo.xml

    runHook postInstall
  '';

  runtimeDependencies = [
    vulkan-loader
    xorg.libXi
  ];

  passthru = {
    tests.openorbis-example = nixosTests.shadps4;
    updateScript = unstableGitUpdater {
      tagFormat = "v.*";
      tagPrefix = "v.";
    };
  };

  meta = {
    description = "Early in development PS4 emulator";
    homepage = "https://github.com/shadps4-emu/shadPS4";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      ryand56
      liberodark
    ];
    mainProgram = "shadps4";
    platforms = lib.intersectLists lib.platforms.linux lib.platforms.x86_64;
  };
})
