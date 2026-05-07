{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libx11,
  libxrandr,
  libxinerama,
  libxext,
  libxcursor,
  freetype,
  alsa-lib,
  libjack2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stochas";
  version = "1.3.13";

  src = fetchFromGitHub {
    owner = "surge-synthesizer";
    repo = "stochas";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Gp49cWvUkwz4xAq5sA1nUO+amRC39iWeUemQJyv6hTs=";
    fetchSubmodules = true;
  };

  postPatch = ''
    sed '1i#include <utility>' -i \
      lib/JUCE/modules/juce_gui_basics/windows/juce_ComponentPeer.h # gcc12
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libx11
    libxrandr
    libxinerama
    libxext
    libxcursor
    freetype
    alsa-lib
    libjack2
  ];

  installPhase = ''
    mkdir -p $out/lib/vst3
    cp -r stochas_artefacts/Release/VST3/Stochas.vst3 $out/lib/vst3
  '';

  meta = {
    description = "Probabilistic polyrhythmic sequencer plugin";
    homepage = "https://stochas.org/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ magnetophon ];
    platforms = lib.platforms.unix;
  };
})
