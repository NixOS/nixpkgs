{
  lib,
  stdenv,
  fetchFromGitHub,
  nixosTests,
  alsa-lib,
  boost184,
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
  version = "0.4.0-unstable-2024-12-08";

  src = fetchFromGitHub {
    owner = "shadps4-emu";
    repo = "shadPS4";
    rev = "4fb2247196d4626bab8f2c28710b0c34cad053fe";
    hash = "sha256-bRURBUhIVQLrBxJFaJirw3n1n7xviRoAZGLZ+rV/UeM=";
    fetchSubmodules = true;
  };

  patches = [
    # Fix controls without a numpad
    ./laptop-controls.patch
  ];

  buildInputs = [
    alsa-lib
    boost184
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

  fixupPhase = ''
    patchelf --add-rpath ${
      lib.makeLibraryPath [
        vulkan-loader
        xorg.libXi
      ]
    } \
      $out/bin/shadps4
  '';

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
    maintainers = with lib.maintainers; [ ryand56 ];
    mainProgram = "shadps4";
    platforms = lib.intersectLists lib.platforms.linux lib.platforms.x86_64;
  };
})
