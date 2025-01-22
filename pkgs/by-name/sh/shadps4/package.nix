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
  version = "0.5.0-unstable-2025-01-20";

  src = fetchFromGitHub {
    owner = "shadps4-emu";
    repo = "shadPS4";
    rev = "95a30b2b3e1aa4e20c3db632955cc67bbded0fb1";
    hash = "sha256-52BhGKSUv+9asACNkppxiNm3Gja7r3LcXOIwhQR5ALs=";
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
