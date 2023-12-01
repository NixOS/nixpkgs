{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, alsa-lib
, freetype
, libjack2
, lv2
, libX11
, libXcursor
, libXext
, libXinerama
, libXrandr
, libGL
, gcc-unwrapped
}:

stdenv.mkDerivation rec {
  pname = "odin2";
  version = "2.3.4";

  src = fetchFromGitHub {
    owner = "TheWaveWarden";
    repo = "odin2";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-N96Nb7G6hqfh8DyMtHbttl/fRZUkS8f2KfPSqeMAhHY=";
  };

  postPatch = ''
    sed '1i#include <utility>' -i \
      libs/JUCELV2/modules/juce_gui_basics/windows/juce_ComponentPeer.h # gcc12
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    freetype
    libjack2
    lv2
    libX11
    libXcursor
    libXext
    libXinerama
    libXrandr
    libGL
  ];

  # JUCE dlopen's these at runtime, crashes without them
  NIX_LDFLAGS = (toString [
    "-lX11"
    "-lXext"
    "-lXcursor"
    "-lXinerama"
    "-lXrandr"
  ]);

  cmakeFlags = [
    "-DCMAKE_AR=${gcc-unwrapped}/bin/gcc-ar"
    "-DCMAKE_RANLIB=${gcc-unwrapped}/bin/gcc-ranlib"
    "-DCMAKE_NM=${gcc-unwrapped}/bin/gcc-nm"
  ];

  installPhase = ''
    mkdir -p $out/bin $out/lib/vst3 $out/lib/lv2 $out/lib/clap
    cd Odin2_artefacts/Release
    cp Standalone/Odin2 $out/bin
    cp -r VST3/Odin2.vst3 $out/lib/vst3
    cp -r LV2/Odin2.lv2 $out/lib/lv2
    cp -r CLAP/Odin2.clap $out/lib/clap
'';


  meta = with lib; {
    description = "Odin 2 Synthesizer Plugin";
    homepage = "https://thewavewarden.com/odin2";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ magnetophon ];
  };
}
