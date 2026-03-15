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
  pname = "socalabs-voc";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "FigBug";
    repo = "Voc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wLO/855JkpCN7BL5/V7bZJa4d9MvnfYrTC3d+0p1+F4=";
    fetchSubmodules = true;
    preFetch = ''
      # can't clone using ssh
      export GIT_CONFIG_COUNT=1
      export GIT_CONFIG_KEY_0=url.https://github.com/.insteadOf
      export GIT_CONFIG_VALUE_0=git@github.com:
    '';
  };

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = "socalabs-voc";
      desktopName = "Socalabs Voc";
      comment = "Socalabs Wacky Vocal Synth Plugin (Standalone)";
      icon = "Voc";
      exec = "Voc";
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

  # This is needed because otherwise g++ will complain about
  # "FORTIFY_SOURCE" needing to be ran with optimizations
  env.NIX_CFLAGS_COMPILE = toString [
    "-O2"
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
      cp -r Voc_artefacts/Release/VST/libVoc.so $out/lib/vst
    ''}

    cp -r Voc_artefacts/Release/LV2/Voc.lv2 $out/lib/lv2
    cp -r Voc_artefacts/Release/VST3/Voc.vst3 $out/lib/vst3

    install -Dm555 Voc_artefacts/Release/Standalone/Voc $out/bin

    install -Dm444 $src/plugin/Resources/logo.png $out/share/pixmaps/Voc.png

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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Socalabs Wacky Vocal Synthesizer Plugin";
    homepage = "https://socalabs.com/synths/voc-vocal-synth/";
    mainProgram = "Voc";
    platforms = lib.platforms.linux;
    license = [ lib.licenses.lgpl21 ] ++ lib.optional enableVST2 lib.licenses.unfree;
    maintainers = [ lib.maintainers.l1npengtul ];
  };
})
