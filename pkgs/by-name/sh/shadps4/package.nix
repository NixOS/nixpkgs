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
  mesa,
  pkg-config,
  pugixml,
  qt6,
  rapidjson,
  renderdoc,
  robin-map,
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
  version = "0.5.0-unstable-2025-01-02";

  src = fetchFromGitHub {
    owner = "shadps4-emu";
    repo = "shadPS4";
    rev = "596f4cdf0e66a97c9d2d4272091d8c0167a5b8e1";
    hash = "sha256-apwAl8TCzSKchqYGHV0UsMSGErF4GgiwhlwmOPWpeLs=";
    fetchSubmodules = true;
  };

  patches = [
    # Fix controls without a numpad
    ./laptop-controls.patch
  ];

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
    mesa
    pugixml
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtmultimedia
    qt6.qttools
    qt6.qtwayland
    rapidjson
    renderdoc
    robin-map
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

  meta = with lib; {
    description = "Early in development PS4 emulator";
    homepage = "https://github.com/shadps4-emu/shadPS4";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      ryand56
      liberodark
    ];
    mainProgram = "shadps4";
    platforms = intersectLists platforms.linux platforms.x86_64;
  };
})
