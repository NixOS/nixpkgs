{
  stdenv,
  fetchFromGitHub,
  lib,
  cmake,
  pkg-config,
  alsa-lib,
  copyDesktopItems,
  makeDesktopItem,
  libx11,
  libxcomposite,
  libxcursor,
  libxinerama,
  libxrandr,
  libxtst,
  libxdmcp,
  libxext,
  xvfb,
  freetype,
  fontconfig,
  expat,
  libGL,
  libjack2,
  curl,
  ninja,
  writableTmpDirAsHomeHook,
  # Disable VST building by default, since its unfree
  enableVST2 ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "socalabs-rp2a03";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "FigBug";
    repo = "RP2A03";
    rev = "dd90863aed05afe110a5302b5eff4b5144f28d4c";
    hash = "sha256-arEM6mq2oJATj87pyPZ+ZNlLd3kL//BNO5y2SFf+nSo=";
    fetchSubmodules = true;
  };

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = "socalabs-rp2a03";
      desktopName = "Socalabs RP2A03";
      comment = "Socalabs NES Ricoh 2A03 Emulation Plugin (Standalone)";
      icon = "RP2A03";
      exec = "RP2A03";
      categories = [
        "Audio"
        "AudioVideo"
      ];
    })
  ];

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
    cmake
    pkg-config
    copyDesktopItems
    ninja
  ];

  buildInputs = [
    alsa-lib
    libx11
    libxcomposite
    libxcursor
    libxinerama
    libxrandr
    libxtst
    libxdmcp
    libxext
    xvfb
    libGL
    libjack2
    freetype
    fontconfig
    expat
    curl
  ];

  cmakeFlags = [
    (lib.cmakeBool "JUCE_COPY_PLUGIN_AFTER_BUILD" false)
    "--preset ninja-gcc"
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
    --replace-fail 'FORMATS Standalone VST VST3 AU LV2' 'FORMATS Standalone ${lib.optionalString enableVST2 "VST"} VST3 LV2'
  '';

  strictDeps = true;

  preBuild = ''
    cd ../Builds/ninja-gcc
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/vst3 $out/lib/lv2 $out/bin

    ${lib.optionalString enableVST2 ''
      mkdir -p $out/lib/vst
      cp -r RP2A03_artefacts/Release/VST/libRP2A03.so $out/lib/vst
    ''}

    cp -r RP2A03_artefacts/Release/LV2/RP2A03.lv2 $out/lib/lv2
    cp -r RP2A03_artefacts/Release/VST3/RP2A03.vst3 $out/lib/vst3

    install -Dm555 RP2A03_artefacts/Release/Standalone/RP2A03 $out/bin

    install -Dm444 $src/plugin/Resources/logo.png $out/share/pixmaps/RP2A03.png

    runHook postInstall
  '';

  env.NIX_LDFLAGS = toString [
    "-lX11"
    "-lXext"
    "-lXcomposite"
    "-lXcursor"
    "-lXinerama"
    "-lXrandr"
    "-lXtst"
    "-lXdmcp"
  ];

  meta = {
    description = "Socalabs NES Ricoh 2A03 Emulation Plugin";
    homepage = "https://socalabs.com/synths/rp2a03/";
    mainProgram = "RP2A03";
    platforms = lib.platforms.linux;
    license = [ lib.licenses.lgpl21 ] ++ lib.optional enableVST2 lib.licenses.unfree;
    maintainers = [ lib.maintainers.l1npengtul ];
  };
})
