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
  version = "unstable-2022-02-23";

  src = fetchFromGitHub {
    owner = "baconpaul";
    repo = "odin2";
    rev = "ed02d06cfb5db8a118d291c00bd2e4cd6e262cde";
    fetchSubmodules = true;
    sha256 = "sha256-VkZ+mqCmqWQafdN0nQxJdPxbiaZ37/0jOhLvVbnGLvQ=";
  };

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
    mkdir -p $out/bin $out/lib/vst3
    cd Odin2_artefacts/Release
    cp -r VST3/Odin2.vst3 $out/lib/vst3
    cp -r Standalone/Odin2 $out/bin
'';


  meta = with lib; {
    description = "Odin 2 Synthesizer Plugin";
    homepage = "https://thewavewarden.com/odin2";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ magnetophon ];
  };
}
