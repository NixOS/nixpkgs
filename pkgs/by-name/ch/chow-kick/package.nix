{
  alsa-lib,
  cmake,
  curl,
  libepoxy,
  fetchFromGitHub,
  freetype,
  lib,
  libGL,
  libXcursor,
  libXext,
  libXinerama,
  libXrandr,
  libjack2,
  libxkbcommon,
  lv2,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chow-kick";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "Chowdhury-DSP";
    repo = "ChowKick";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YYcNiJGGw21aVY03tyQLu3wHCJhxYiDNJZ+LWNbQdj4=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];
  buildInputs = [
    alsa-lib
    curl
    libepoxy
    freetype
    libGL
    libXcursor
    libXext
    libXinerama
    libXrandr
    libjack2
    libxkbcommon
    lv2
  ];

  cmakeFlags = [
    "-DCMAKE_AR=${stdenv.cc.cc}/bin/gcc-ar"
    "-DCMAKE_RANLIB=${stdenv.cc.cc}/bin/gcc-ranlib"
  ];

  postPatch = ''
    substituteInPlace modules/chowdsp_wdf/CMakeLists.txt --replace-fail \
      'cmake_minimum_required(VERSION 3.1)' \
      'cmake_minimum_required(VERSION 4.0)'
  '';

  installPhase = ''
    mkdir -p $out/lib/lv2 $out/lib/vst3 $out/bin
    cp -r ChowKick_artefacts/Release/LV2/ChowKick.lv2 $out/lib/lv2
    cp -r ChowKick_artefacts/Release/VST3/ChowKick.vst3 $out/lib/vst3
    cp ChowKick_artefacts/Release/Standalone/ChowKick  $out/bin
  '';

  meta = {
    homepage = "https://github.com/Chowdhury-DSP/ChowKick";
    description = "Kick synthesizer based on old-school drum machine circuits";
    license = [ lib.licenses.bsd3 ];
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
    mainProgram = "ChowKick";
  };
})
