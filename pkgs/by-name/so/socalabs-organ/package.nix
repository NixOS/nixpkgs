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
  # Disable VST building by default, its unfree
  enableVST2 ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "socalabs-organ";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "FigBug";
    repo = "Organ";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wo7ZWgTpeGLOrj15sx0PQbBWF5QCO6Y52kSYyJU1vHI=";
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
      name = "socalabs-organ";
      desktopName = "Socalabs Organ";
      comment = "Socalabs Organ Plugin based on setBFree (Standalone)";
      exec = "Organ";
      categories = [
        "Audio"
        "AudioVideo"
      ];
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    copyDesktopItems
    ninja
    writableTmpDirAsHomeHook
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
    (lib.cmakeBool "BUILD_EXTRAS" true)
    "--preset ninja-gcc"
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
    --replace-fail 'FORMATS Standalone VST VST3 AU LV2' 'FORMATS Standalone ${lib.optionalString enableVST2 "VST"} VST3 LV2'

    # fix compile error
    sed -i '32i #include <strings.h>' plugin/setBfree/src/tonegen.c

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
      cp -r Organ_artefacts/Release/VST/libOrgan.so $out/lib/vst
    ''}

    cp -r Organ_artefacts/Release/LV2/Organ.lv2 $out/lib/lv2
    cp -r Organ_artefacts/Release/VST3/Organ.vst3 $out/lib/vst3

    install -Dm555 Organ_artefacts/Release/Standalone/Organ $out/bin

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
    description = "Socalabs Organ Plugin based on setBFree";
    homepage = "https://socalabs.com/synths/organ/";
    mainProgram = "Organ";
    platforms = lib.platforms.linux;
    license = [ lib.licenses.gpl3Only ] ++ lib.optional enableVST2 lib.licenses.unfree;
    maintainers = [ lib.maintainers.l1npengtul ];
  };
})
