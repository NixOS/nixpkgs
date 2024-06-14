{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, alsa-lib
, freetype
, libX11
, libXrandr
, libXinerama
, libXext
, libXcursor
, makeDesktopItem
, copyDesktopItems
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "show-midi";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "gbevin";
    repo = "ShowMIDI";
    rev = finalAttrs.version;
    hash = "sha256-xt2LpoiaOWAeWM/YzaKM0WGi8aHs4T7pvMw1s/P4Oj0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    copyDesktopItems
  ];
  buildInputs = [
    alsa-lib
    freetype
    libX11
    libXrandr
    libXinerama
    libXext
    libXcursor
  ];

  enableParallelBuilding = true;

  makeFlags = [
    "-C Builds/LinuxMakefile"
    "CONFIG=Release"
    # Specify targets by hand, because it tries to build VST by default,
    # even though it's not supported in JUCE anymore
    "LV2"
    "LV2_MANIFEST_HELPER"
    "Standalone"
    "VST3"
    "VST3_MANIFEST_HELPER"
  ];

  installPhase = ''
    runHook preInstall

    install -Dt $out/share/ShowMIDI/themes Themes/*

    install -D Design/icon.png $out/share/icons/hicolor/1024x1024/apps/show-midi.png

    mkdir -p $out/bin $out/lib/lv2 $out/lib/vst3
    cd Builds/LinuxMakefile/build/
    cp -r ShowMIDI.lv2 $out/lib/lv2
    cp -r ShowMIDI.vst3 $out/lib/vst3
    cp ShowMIDI $out/bin

    runHook postInstall
  '';

  desktopItems = [(makeDesktopItem {
    name = "ShowMIDI";
    exec = finalAttrs.meta.mainProgram;
    comment = finalAttrs.meta.description;
    type = "Application";
    icon = "show-midi";
    desktopName = "ShowMIDI";
    categories = [ "Audio" ];
  })];

  # JUCE dlopens these, make sure they are in rpath
  # Otherwise, segfault will happen
  env.NIX_LDFLAGS = toString [
    "-lX11"
    "-lXext"
    "-lXcursor"
    "-lXinerama"
    "-lXrandr"
  ];

  meta = with lib; {
    description = "Multi-platform GUI application to effortlessly visualize MIDI activity";
    homepage = "https://github.com/gbevin/ShowMIDI";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ minijackson ];
    mainProgram = "ShowMIDI";
    platforms = platforms.linux;
  };
})
