{ alsa-lib
, curl
, fetchFromGitHub
, freeglut
, freetype
, libGL
, libXcursor
, libXext
, libXinerama
, libXrandr
, libjack2
, pkg-config
, python3
, stdenv
, lib
}:

stdenv.mkDerivation rec {
  pname = "CHOWTapeModel";
  version = "unstable-2020-12-12";

  src = fetchFromGitHub {
    owner = "jatinchowdhury18";
    repo = "AnalogTapeModel";
    rev = "a7cf10c3f790d306ce5743bb731e4bc2c1230d70";
    sha256 = "09nq8x2dwabncbp039dqm1brzcz55zg9kpxd4p5348xlaz5m4661";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    curl
    freeglut
    freetype
    libGL
    libXcursor
    libXext
    libXinerama
    libXrandr
    libjack2
    python3
  ];

  buildPhase = ''
    cd Plugin/
    ./build_linux.sh
  '';

  installPhase = ''
    mkdir -p $out/lib/lv2 $out/lib/vst3 $out/bin $out/share/doc/CHOWTapeModel/
    cd Builds/LinuxMakefile/build/
    cp CHOWTapeModel.a  $out/lib
    cp -r CHOWTapeModel.lv2 $out/lib/lv2
    cp -r CHOWTapeModel.vst3 $out/lib/vst3
    cp CHOWTapeModel  $out/bin
    cp ../../../../Manual/ChowTapeManual.pdf $out/share/doc/CHOWTapeModel/
  '';

  meta = with lib; {
    homepage = "https://github.com/jatinchowdhury18/AnalogTapeModel";
    description = "Physical modelling signal processing for analog tape recording. LV2, VST3 and standalone";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ magnetophon ];
    platforms = platforms.linux;
  };
}
