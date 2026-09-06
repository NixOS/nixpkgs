{
  clangStdenv,
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
  # Disable VST building by default, since it is unfree
  enableVST2 ? false,
}:
let
  plugins = [
    "ABTester"
    "AddInvert"
    "ChannelMute"
    "CompensatedDelay"
    "Compressor"
    "Crossfeed"
    "Delay"
    "Expander"
    "Gate"
    "HugeGain"
    "Limiter"
    "Maths"
    "MidiLooper"
    "Oscilloscope"
    "PitchTrack"
    "SFX8"
    "SampleDelay"
    "SimpleVerb"
    "SpectrumAnalyzer"
    "StereoEnhancer"
    "StereoProcessor"
    "ToneGenerator"
    "WaveLooper"
    "XYScope"
  ];
  desktopItems = map (
    pl:
    (makeDesktopItem {
      type = "Application";
      name = "socalabs-${lib.toLower pl}";
      desktopName = "Socalabs ${pl}";
      comment = "Socalabs ${pl} Plugin (Standalone)";
      # only SFX8 has an icon
      exec = "${pl}";
      categories = [
        "Audio"
        "AudioVideo"
      ];
    })
  ) plugins;
in
clangStdenv.mkDerivation {
  pname = "socalabs-slplugins";
  version = "1.1.0";
  inherit desktopItems;

  src = fetchFromGitHub {
    owner = "FigBug";
    repo = "slPlugins";
    rev = "dc51ca3cc468e2fcead6ac0c2ba460f3f9c04176";
    hash = "sha256-/84FHtO3HC//VCTs68AN4H0xngI0BkYm1K4G//DQkyU=";
    fetchSubmodules = true;
    preFetch = ''
      # can't clone using ssh
      export GIT_CONFIG_COUNT=1
      export GIT_CONFIG_KEY_0=url.https://github.com/.insteadOf
      export GIT_CONFIG_VALUE_0=git@github.com:
    '';
  };

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
    "-B build"
  ];

  patches = [
    ./plugins-cmakelists-fix.patch
  ];

  postPatch =
    let
      patches = map (
        pl:
        "substituteInPlace plugins/${pl}/CMakeLists.txt --replace-fail 'FORMATS Standalone VST VST3 AU LV2' 'FORMATS Standalone ${lib.optionalString enableVST2 "VST"} LV2 VST3'"
      ) plugins;
      lto-yeeter = map (
        pl:
        "substituteInPlace plugins/${pl}/CMakeLists.txt --replace-fail 'juce::juce_recommended_lto_flags' ''"
      ) plugins;
    in
    ''
      ${lib.strings.concatStringsSep "\n" patches}
      ${lib.strings.concatStringsSep "\n" lto-yeeter}
    '';

  strictDeps = true;

  preBuild = ''
    cd /build/source/build/build
  '';

  installPhase =
    let
      install-vst = map (
        vst2:
        "install -Dm555 /build/source/build/build/plugins/${vst2}/${vst2}_artefacts/Release/VST/lib${vst2}.so $out/lib/vst/lib${vst2}.so"
      ) plugins;
      install-vst-str = lib.concatStringsSep "\n" install-vst;
      install-vst3 = map (
        plugin:
        "cp -r /build/source/build/build/plugins/${plugin}/${plugin}_artefacts/Release/VST3/${plugin}.vst3 $out/lib/vst3"
      ) plugins;
      install-lv2 = map (
        plugin:
        "cp -r /build/source/build/build/plugins/${plugin}/${plugin}_artefacts/Release/LV2/${plugin}.lv2 $out/lib/lv2"
      ) plugins;
      install-standalone = map (
        plugin:
        "install -Dm555 /build/source/build/build/plugins/${plugin}/${plugin}_artefacts/Release/Standalone/${plugin} $out/bin/${plugin}"
      ) plugins;
      inherit enableVST2;
    in
    ''
      runHook preInstall
      mkdir -p $out/lib/vst3 $out/bin $out/lib/lv2
      ${lib.optionalString enableVST2 ''
        mkdir -p $out/lib/vst
        ${install-vst-str}
      ''}

      ${lib.concatStringsSep "\n" install-vst3}
      ${lib.concatStringsSep "\n" install-lv2}
      ${lib.concatStringsSep "\n" install-standalone}

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

  meta = {
    description = "Various VST/AU Plugins from SocaLabs.com";
    homepage = "https://socalabs.com/";
    platforms = lib.platforms.linux;
    license = [ lib.licenses.gpl3 ] ++ lib.optional enableVST2 lib.licenses.unfree;
    maintainers = [ lib.maintainers.l1npengtul ];
  };
}
