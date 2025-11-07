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
  webkitgtk_4_1,
  libsysprof-capture,
  pcre2,
  util-linux,
  libselinux,
  libsepol,
  libthai,
  libxkbcommon,
  libdatrie,
  libepoxy,
  lerc,
  sqlite,
  ninja,
  # Disable VST building by default, since NixOS doesn't have a VST license
  enableVST2 ? false,
}:
stdenv.mkDerivation {
  pname = "socalabs-sid";
  version = "1.1.0";

  src =
    (fetchFromGitHub {
      owner = "FigBug";
      repo = "SID";
      rev = "bb826fdea39da0804c53d81d35bea29aeff4436d";
      hash = "sha256-6IStysItOS7EltTCqdyo9vrsnSA1YYoN4y8Bjv1fhNk=";
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
      name = "socalabs-sid";
      desktopName = "Socalabs SID";
      comment = "Socalabs Commodore 64 SID Emulation Plugin (Standalone)";
      icon = "SID";
      exec = "SID";
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
    lerc
    freetype
    curl
    webkitgtk_4_1
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
      cp -r SID_artefacts/Release/VST/libSID.so $out/lib/vst
    ''}

    cp -r SID_artefacts/Release/LV2/SID.lv2 $out/lib/lv2
    cp -r SID_artefacts/Release/VST3/SID.vst3 $out/lib/vst3

    install -Dm755 SID_artefacts/Release/Standalone/SID $out/bin

    install -Dm444 $src/plugin/Resources/icon.png $out/share/pixmaps/SID.png

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
    description = "Socalabs Commodore 64 SID Emulation Plugin";
    homepage = "https://socalabs.com/synths/commodore-64-sid/";
    mainProgram = "SID";
    platforms = lib.platforms.linux;
    license = [ lib.licenses.gpl3 ] ++ lib.optional enableVST2 lib.licenses.unfree;
    maintainers = [ lib.maintainers.l1npengtul ];
  };
}
