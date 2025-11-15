{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  ninja,
  pkg-config,
  writableTmpDirAsHomeHook,
  copyDesktopItems,
  libx11,
  libxrandr,
  libxinerama,
  libxext,
  libxcursor,
  freetype,
  fontconfig,
  curl,
  alsa-lib,
  expat,
  libGL,

  buildStandalone ? true,
  buildVST3 ? true,
  buildLV2 ? true,

  plugins ? [
    "ABTester"
    "AddInvert"
    "ChannelMute"
    "CompensatedDelay"
    "Compressor"
    "Crossfeed"
    "Delay"
    "Expander"
    "Gate"
    "GraphicEQ"
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
  ],
}:

let
  formats = lib.concatStringsSep " " [
    (lib.optionalString buildStandalone "Standalone")
    (lib.optionalString buildVST3 "VST3")
    (lib.optionalString buildLV2 "LV2")
  ];
in

stdenv.mkDerivation {
  pname = "socalabs-other-bundle";
  version = "0-unstable-2026-01-13";

  src = fetchFromGitHub {
    owner = "FigBug";
    repo = "slPlugins";
    rev = "dd96ff4c161a29b779436433cb93183941029ef1";
    hash = "sha256-uapnWwUetRsg6sKq5VfIK16B2h6VMscw465JSRIM2ls=";
    fetchSubmodules = true;

    preFetch = ''
      export GIT_CONFIG_COUNT=1
      export GIT_CONFIG_KEY_0=url.https://github.com/.insteadOf
      export GIT_CONFIG_VALUE_0=git@github.com:
    '';
  };

  postPatch = ''
    substituteInPlace plugins/*/CMakeLists.txt \
      --replace-fail "juce::juce_recommended_lto_flags" "# no lto" \
      --replace-fail "set(FORMATS Standalone VST VST3 AU LV2)" "set(FORMATS ${formats})"

    echo "" > plugins/CMakeLists.txt
  ''
  + (lib.concatStringsSep "\n" (
    map (plugin: "echo \"add_subdirectory(${plugin})\" >> plugins/CMakeLists.txt") plugins
  ));

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    writableTmpDirAsHomeHook
    copyDesktopItems
  ];

  buildInputs = [
    libx11
    libxcursor
    libxrandr
    libxinerama
    libxext
    freetype
    fontconfig
    expat
    alsa-lib
    curl
    libGL
  ];

  cmakeFlags = [
    "--preset ninja-gcc"
    (lib.cmakeBool "JUCE_COPY_PLUGIN_AFTER_BUILD" false)
  ];

  # Fontconfig error: Cannot load default config file: No such file: (null)
  env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  preBuild = "cd ../Builds/ninja-gcc";

  installPhase =
    let
      mkPlugin = plugin: ''
        pushd ${plugin}/${plugin}_artefacts/Release
          ${lib.optionalString buildStandalone ''
            install -Dm755 Standalone/${plugin} -t $out/bin
          ''}

          ${lib.optionalString buildVST3 ''
            mkdir -p $out/lib/vst3
            cp -r VST3/${plugin}.vst3 $out/lib/vst3
          ''}

          ${lib.optionalString buildLV2 ''
            mkdir -p $out/lib/lv2
            cp -r LV2/${plugin}.lv2 $out/lib/lv2
          ''}
        popd
      '';
    in
    ''
      runHook preInstall

      pushd plugins
        ${lib.concatStringsSep "\n" (map mkPlugin plugins)}
      popd

      runHook postInstall
    '';

  # Needed by standalone
  NIX_LDFLAGS = [
    "-lX11"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Various plugins by Socalabs";
    homepage = "https://socalabs.com";
    platforms = lib.platforms.linux;
    license = [ lib.licenses.bsd3 ];
    maintainers = [ lib.maintainers.mrtnvgr ];
  };
}
