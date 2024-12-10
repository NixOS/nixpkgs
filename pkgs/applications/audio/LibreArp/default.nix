{
  stdenv,
  lib,
  fetchFromGitLab,
  cmake,
  pkg-config,
  cairo,
  libxkbcommon,
  xcbutilcursor,
  xcbutilkeysyms,
  xcbutil,
  libXrandr,
  libXinerama,
  libXcursor,
  alsa-lib,
  libjack2,
  lv2,
  gcc-unwrapped,
  curl,
}:

stdenv.mkDerivation rec {
  pname = "LibreArp";
  version = "2.4";

  src = fetchFromGitLab {
    owner = "LibreArp";
    repo = "LibreArp";
    rev = version;
    hash = "sha256-jEpES68NuHhelUq/L46CxEeadk3LbuPZ72JaGDbw8fg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    cairo
    libxkbcommon
    xcbutilcursor
    xcbutilkeysyms
    xcbutil
    libXrandr
    libXinerama
    libXcursor
    alsa-lib
    libjack2
    lv2
    curl
  ];

  cmakeFlags = [
    "-DCMAKE_AR=${gcc-unwrapped}/bin/gcc-ar"
    "-DCMAKE_RANLIB=${gcc-unwrapped}/bin/gcc-ranlib"
    "-DCMAKE_NM=${gcc-unwrapped}/bin/gcc-nm"
  ];

  installPhase = ''
    mkdir -p $out/lib/vst3
    cd LibreArp_artefacts/Release
    cp -r VST3/LibreArp.vst3 $out/lib/vst3
  '';

  meta = with lib; {
    description = "A pattern-based arpeggio generator plugin.";
    homepage = "https://librearp.gitlab.io/";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ magnetophon ];
  };
}
