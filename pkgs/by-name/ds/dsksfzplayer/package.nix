{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  alsa-lib,
  freetype,
  libGL,
  libjack2,
  libx11,
  libxcursor,
  libxext,
  libxinerama,
  libxrandr,
  libxkbcommon,
  libepoxy,
}:

let
  juce-src = fetchFromGitHub {
    owner = "juce-framework";
    repo = "JUCE";
    tag = "7.0.12";
    hash = "sha256-/awe6D824ZjF17xjkt0wY7dcDuS/s8KKAv1UKHxF0FM=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dsksfzplayer";
  version = "1.0.28";

  src = fetchFromGitHub {
    owner = "dskmusic";
    repo = "DSKSFzPlayer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/QaH2jiE0Hzow/T0x0pmEseJt4R71SiGN9cNPe/vvGM=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    freetype
    libGL
    libjack2
    libx11
    libxcursor
    libxext
    libxinerama
    libxrandr
    libxkbcommon
    libepoxy
  ];

  cmakeFlags = [
    "-DFETCHCONTENT_SOURCE_DIR_JUCE=${juce-src}"
    "-DJUCE_COPY_PLUGIN_AFTER_BUILD=OFF"
  ];

  env = {
    # JUCE dlopen's these at runtime, crashes without them
    NIX_LDFLAGS = toString [
      "-lX11"
      "-lXext"
      "-lXcursor"
      "-lXinerama"
      "-lXrandr"
    ];
    NIX_CFLAGS_COMPILE = toString [
      "-ffat-lto-objects"
    ];
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/vst3
    mkdir -p $out/bin
    mkdir -p $out/share/doc/dsksfzplayer

    cp -r DSKSFzPlayer_artefacts/Release/VST3/DSK\ SFz\ player.vst3 $out/lib/vst3/
    install -Dm755 "DSKSFzPlayer_artefacts/Release/Standalone/DSK SFz player" $out/bin/dsksfzplayer

    # Copy documentation
    cp DSKSFzPlayer_artefacts/Release/VST3/manual.md $out/share/doc/dsksfzplayer/
    cp DSKSFzPlayer_artefacts/Release/VST3/install_notes.md $out/share/doc/dsksfzplayer/

    runHook postInstall
  '';

  meta = {
    description = "High-performance, 64-voice polyphonic SFZ/SF2/Decent Sampler sampler";
    homepage = "https://github.com/dskmusic/DSKSFzPlayer";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ eymeric ];
    platforms = lib.platforms.linux;
  };
})
