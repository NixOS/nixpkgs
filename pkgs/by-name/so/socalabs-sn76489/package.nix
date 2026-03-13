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
  # Disable VST building by default, since it is unfree
  enableVST2 ? false,
}:
let
  version = "1.1.1";
in
stdenv.mkDerivation {
  pname = "socalabs-sn76489";
  inherit version;

  src = fetchFromGitHub {
    owner = "FigBug";
    repo = "SN76489";
    tag = "v${version}";
    hash = "sha256-Dzv9qtUtuiQa2pc1TN9qyQWHP2pBU7bGXHZgALjKr3U=";
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
      name = "socalabs-sn76489";
      desktopName = "Socalabs SN76489";
      comment = "Socalabs Texas Instruments SN76489 Emulation Plugin";
      icon = "SN76489";
      exec = "SN76489";
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
      cp -r SN76489_artefacts/Release/VST/libSN76489.so $out/lib/vst
    ''}

    cp -r SN76489_artefacts/Release/LV2/SN76489.lv2 $out/lib/lv2
    cp -r SN76489_artefacts/Release/VST3/SN76489.vst3 $out/lib/vst3

    install -Dm555 SN76489_artefacts/Release/Standalone/SN76489 $out/bin

    install -Dm444 $src/plugin/Resources/logo.png $out/share/pixmaps/SN76489.png

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
    description = "Socalabs Texas Instruments SN76489 Emulation Plugin";
    homepage = "https://socalabs.com/synths/sn76489/";
    mainProgram = "SN76489";
    platforms = lib.platforms.linux;
    license = [ lib.licenses.lgpl21 ] ++ lib.optional enableVST2 lib.licenses.unfree;
    maintainers = [ lib.maintainers.l1npengtul ];
  };
}
