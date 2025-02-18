{
  stdenv,
  fetchFromGitHub,
  lib,
  cmake,
  pkg-config,
  alsa-lib,
  copyDesktopItems,
  makeDesktopItem,
  xorg,
  freetype,
  expat,
  libGL,
  libjack2,
  curl,
  webkitgtk_4_0,
  libsysprof-capture,
  pcre2,
  util-linux,
  libselinux,
  libsepol,
  libthai,
  libxkbcommon,
  libdatrie,
  libepoxy,
  libsoup_2_4,
  lerc,
  sqlite,
  ninja,
  # Disable VST building by default, since NixOS doesn't have a VST license
  enableVST2 ? false,
}:
stdenv.mkDerivation {
  pname = "socalabs-rp2a03";
  version = "1.1.0";

  src =
    (fetchFromGitHub {
      owner = "FigBug";
      repo = "RP2A03";
      rev = "383b677226a1a686599041fb5f5fcdb81c96db7a";
      hash = "sha256-xPfBI18SCf81W3bfDmq75cCimSqWMwdB5jNG6Jq+Scs=";
      fetchSubmodules = true;
    }).overrideAttrs
      (_: {
        GIT_CONFIG_COUNT = 1;
        GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf";
        GIT_CONFIG_VALUE_0 = "git@github.com:";
      });

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
    cmake
    pkg-config
    copyDesktopItems
    ninja
  ];

  buildInputs = [
    alsa-lib
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXtst
    xorg.libXdmcp
    xorg.xvfb
    libGL
    libjack2
    libsysprof-capture
    libselinux
    libsepol
    libthai
    libxkbcommon
    libdatrie
    libepoxy
    libsoup_2_4
    lerc
    freetype
    curl
    webkitgtk_4_0
    pcre2
    util-linux
    sqlite
    expat
  ];

  cmakeFlags = [
    (lib.cmakeBool "JUCE_COPY_PLUGIN_AFTER_BUILD" false)
    "--preset ninja-gcc"
  ];

  patchPhase = ''
    substituteInPlace CMakeLists.txt \
    --replace-fail 'FORMATS Standalone VST VST3 AU LV2' 'FORMATS Standalone ${lib.optionalString enableVST2 "VST"} VST3 LV2'

    # we need to patch JUCE itself to enable jack MIDI support
    # please https://github.com/juce-framework/JUCE/issues/952
    # TODO: remove when juce updates :D
    substituteInPlace modules/juce/modules/juce_audio_devices/native/juce_Midi_linux.cpp \
    --replace-fail "port = client.createPort (portName, forInput, false);" "port = client.createPort (portName, forInput, true);"
  '';

  cmakeBuildType = "Release";

  strictDeps = true;

  preBuild = ''
    # build takes 10 years without this set
    HOME=(mktemp -d)

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

    install -Dm755 RP2A03_artefacts/Release/Standalone/RP2A03 $out/bin

    install -Dm444 $src/plugin/Resources/logo.png $out/share/pixmaps/RP2A03.png

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
    description = "Socalabs NES Ricoh 2A03 Emulation Plugin";
    homepage = "https://socalabs.com/synths/rp2a03/";
    mainProgram = "RP2A03";
    platforms = lib.platforms.linux;
    license = [ lib.licenses.lgpl21 ] ++ lib.optional enableVST2 lib.licenses.unfree;
    maintainers = [ lib.maintainers.l1npengtul ];
  };
}
