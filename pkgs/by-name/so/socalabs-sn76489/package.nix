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
  makeDesktopItem,
  libx11,
  libxrandr,
  libxinerama,
  libxext,
  libxcursor,
  freetype,
  fontconfig,
  expat,
  curl,
  alsa-lib,

  buildStandalone ? true,
  buildVST3 ? true,
  buildLV2 ? true,
}:

let
  cmakeFormats = [
    (lib.optionalString buildStandalone "Standalone")
    (lib.optionalString buildVST3 "VST3")
    (lib.optionalString buildLV2 "LV2")
  ];
in

stdenv.mkDerivation {
  pname = "socalabs-sn76489";
  version = "0-unstable-2025-08-08";

  src = fetchFromGitHub {
    owner = "FigBug";
    repo = "SN76489";
    rev = "a5448839895cf58eb97a99920b328da7cf5ea6ad";
    hash = "sha256-SrBFfXTrn0AWKJNbkH5yhjzw687QZsool+V6EmLnj6g=";
    fetchSubmodules = true;

    preFetch = ''
      export GIT_CONFIG_COUNT=1
      export GIT_CONFIG_KEY_0=url.https://github.com/.insteadOf
      export GIT_CONFIG_VALUE_0=git@github.com:
    '';
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "FORMATS Standalone VST VST3 AU LV2" "FORMATS ${lib.concatStringsSep " " cmakeFormats}"

    # -- (taken from socalabs-sid package) --
    # we need to patch JUCE itself to enable jack MIDI support
    # please https://github.com/juce-framework/JUCE/issues/952
    # TODO: remove when juce updates :D
    substituteInPlace modules/juce/modules/juce_audio_devices/native/juce_Midi_linux.cpp \
      --replace-fail "port = client.createPort (portName, forInput, false);" "port = client.createPort (portName, forInput, true);"
  '';

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
    curl
    alsa-lib
  ];

  cmakeFlags = [
    "--preset ninja-gcc"
    (lib.cmakeBool "JUCE_COPY_PLUGIN_AFTER_BUILD" false)
  ];

  # Fontconfig error: Cannot load default config file: No such file: (null)
  env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  preBuild = "cd ../Builds/ninja-gcc";

  installPhase = ''
    runHook preInstall

    pushd SN76489_artefacts/Release
      ${lib.optionalString buildStandalone ''
        install -Dm755 Standalone/SN76489 -t $out/bin
      ''}

      ${lib.optionalString buildVST3 ''
        mkdir -p $out/lib/vst3
        cp -r VST3/SN76489.vst3 $out/lib/vst3
      ''}

      ${lib.optionalString buildLV2 ''
        mkdir -p $out/lib/lv2
        cp -r LV2/SN76489.lv2 $out/lib/lv2
      ''}
    popd

    runHook postInstall
  '';

  # JUCE dlopens these at runtime, standalone executable crashes without them
  NIX_LDFLAGS = [
    "-lX11"
  ];

  passthru.updateScript = nix-update-script { };

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = "socalabs-sn76489";
      desktopName = "Socalabs SN76489";
      comment = "Nintendo Sega Master System Sound Chip Emulation Plugin (Standalone)";
      exec = "SN76489";
      categories = [
        "Audio"
        "AudioVideo"
      ];
    })
  ];

  meta = {
    description = "Nintendo Sega Master System Sound Chip Emulation Plugin";
    homepage = "https://socalabs.com/synths/sn76489";
    platforms = lib.platforms.linux;
    license = [ lib.licenses.bsd3 ];
    maintainers = [ lib.maintainers.mrtnvgr ];
    mainProgram = lib.optionalString buildStandalone "SN76489";
  }
  // lib.optionalAttrs buildStandalone {
    mainProgram = "SN76489";
  };
}
