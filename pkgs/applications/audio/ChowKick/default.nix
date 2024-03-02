{ alsa-lib
, at-spi2-core
, brotli
, cmake
, curl
, dbus
, libepoxy
, fetchFromGitHub
, freeglut
, freetype
, gtk2-x11
, lib
, libGL
, libXcursor
, libXdmcp
, libXext
, libXinerama
, libXrandr
, libXtst
, libdatrie
, libjack2
, libpsl
, libselinux
, libsepol
, libsysprof-capture
, libthai
, libxkbcommon
, lv2
, pcre
, pkg-config
, python3
, sqlite
, stdenv
, util-linuxMinimal
, webkitgtk
}:

stdenv.mkDerivation rec {
  pname = "ChowKick";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "Chowdhury-DSP";
    repo = pname;
    rev = "v${version}";
    sha256 = "0amnp0p7ckbbr9dcbdnld1ryv46kvza2dj8m6hzmi7c1s4df8x5q";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];
  buildInputs = [
    alsa-lib
    at-spi2-core
    brotli
    curl
    dbus
    libepoxy
    freeglut
    freetype
    gtk2-x11
    libGL
    libXcursor
    libXdmcp
    libXext
    libXinerama
    libXrandr
    libXtst
    libdatrie
    libjack2
    libpsl
    libselinux
    libsepol
    libsysprof-capture
    libthai
    libxkbcommon
    lv2
    pcre
    python3
    sqlite
    util-linuxMinimal
    webkitgtk
  ];

  cmakeFlags = [
    "-DCMAKE_AR=${stdenv.cc.cc}/bin/gcc-ar"
    "-DCMAKE_RANLIB=${stdenv.cc.cc}/bin/gcc-ranlib"
  ];

  installPhase = ''
    mkdir -p $out/lib/lv2 $out/lib/vst3 $out/bin
    cp -r ChowKick_artefacts/Release/LV2//${pname}.lv2 $out/lib/lv2
    cp -r ChowKick_artefacts/Release/VST3/${pname}.vst3 $out/lib/vst3
    cp ChowKick_artefacts/Release/Standalone/${pname}  $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/Chowdhury-DSP/ChowKick";
    description = "Kick synthesizer based on old-school drum machine circuits";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ magnetophon ];
    platforms = platforms.linux;
    mainProgram = "ChowKick";
  };
}
