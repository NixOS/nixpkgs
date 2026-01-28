{
  stdenv,
  fetchFromGitHub,
  lib,
  cmake,
  pkg-config,
  alsa-lib,
  copyDesktopItems,
  makeDesktopItem,
  libX11,
  libXcomposite,
  libXcursor,
  libXinerama,
  libXrandr,
  libXtst,
  libXdmcp,
  libXext,
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
  pname = "socalabs-piano";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "FigBug";
    repo = "Piano";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4kGJLoTaD6ji0xrCCrsu2kQ0IwhSnWCRTcr/b55F4kY=";
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
      name = "socalabs-piano";
      desktopName = "Socalabs Piano";
      comment = "Socalabs Physical Modeling Piano Plugin (Standalone)";
      exec = "Piano";
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
    libX11
    libXcomposite
    libXcursor
    libXinerama
    libXrandr
    libXtst
    libXdmcp
    libXext
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
      cp -r Piano_artefacts/Release/VST/libPiano.so $out/lib/vst
    ''}

    cp -r Piano_artefacts/Release/LV2/Piano.lv2 $out/lib/lv2
    cp -r Piano_artefacts/Release/VST3/Piano.vst3 $out/lib/vst3

    install -Dm555 Piano_artefacts/Release/Standalone/Piano $out/bin

    runHook postInstall
  '';

  NIX_LDFLAGS = (
    toString [
      "-lX11"
      "-lXext"
      "-lXcomposite"
      "-lXcursor"
      "-lXinerama"
      "-lXrandr"
      "-lXtst"
      "-lXdmcp"
    ]
  );

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Socalabs Physical Modeling Piano Plugin";
    homepage = "https://socalabs.com/synths/piano/";
    mainProgram = "Piano";
    platforms = lib.platforms.linux;
    license = [ lib.licenses.gpl2Only ] ++ lib.optional enableVST2 lib.licenses.unfree;
    maintainers = [ lib.maintainers.l1npengtul ];
  };
})
