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
  nix-update-script,
  # Disable VST building by default, since its unfree
  enableVST2 ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "socalabs-papu";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "FigBug";
    repo = "PAPU";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8GM28Qt+wCc+r/6wWCh/msbIQJJqFii8ijkhuOLWfdc=";
    fetchSubmodules = true;
  };

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = "socalabs-papu";
      desktopName = "Socalabs PAPU";
      comment = "Socalabs Nintendo Gameboy PAPU Emulation Plugin (Standalone)";
      icon = "PAPU";
      exec = "PAPU";
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
      cp -r PAPU_artefacts/Release/VST/libPAPU.so $out/lib/vst
    ''}

    cp -r PAPU_artefacts/Release/LV2/PAPU.lv2 $out/lib/lv2
    cp -r PAPU_artefacts/Release/VST3/PAPU.vst3 $out/lib/vst3

    install -Dm555 PAPU_artefacts/Release/Standalone/PAPU $out/bin

    install -Dm444 $src/plugin/Resources/icon.png $out/share/pixmaps/PAPU.png

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

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
    description = "Socalabs Nintendo Gameboy PAPU Emulation Plugin";
    homepage = "https://socalabs.com/synths/papu/";
    mainProgram = "PAPU";
    platforms = lib.platforms.linux;
    license = [ lib.licenses.gpl2 ] ++ lib.optional enableVST2 lib.licenses.unfree;
    maintainers = [ lib.maintainers.l1npengtul ];
  };
})
