{ alsa-lib, at-spi2-core, cmake, curl, dbus, libepoxy, fetchFromGitHub, libglut
, freetype, gcc-unwrapped, gtk3, lib, libGL, libXcursor, libXdmcp, libXext
, libXinerama, libXrandr, libXtst, libdatrie, libjack2, libpsl, libselinux
, libsepol, libsysprof-capture, libthai, libxkbcommon, pcre, pkg-config
, python3, sqlite, stdenv }:

stdenv.mkDerivation (finalAttrs: {
  pname = "chow-phaser";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "jatinchowdhury18";
    repo = "ChowPhaser";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-9wo7ZFMruG3QNvlpILSvrFh/Sx6J1qnlWc8+aQyS4tQ=";
  };

  nativeBuildInputs = [ pkg-config cmake ];

  buildInputs = [
    alsa-lib
    at-spi2-core
    curl
    dbus
    libepoxy
    libglut
    freetype
    gtk3
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
    pcre
    python3
    sqlite
    gcc-unwrapped
  ];

  cmakeFlags = [
    "-DCMAKE_AR=${gcc-unwrapped}/bin/gcc-ar"
    "-DCMAKE_RANLIB=${gcc-unwrapped}/bin/gcc-ranlib"
    "-DCMAKE_NM=${gcc-unwrapped}/bin/gcc-nm"
  ];

  installPhase = ''
    mkdir -p $out/lib/lv2 $out/lib/vst3 $out/bin $out/share/doc/ChowPhaser/
    cd ChowPhaserMono_artefacts/Release
    cp libChowPhaserMono_SharedCode.a  $out/lib
    cp -r VST3/ChowPhaserMono.vst3 $out/lib/vst3
    cp Standalone/ChowPhaserMono  $out/bin
    cd ../../ChowPhaserStereo_artefacts/Release
    cp libChowPhaserStereo_SharedCode.a  $out/lib
    cp -r VST3/ChowPhaserStereo.vst3 $out/lib/vst3
    cp Standalone/ChowPhaserStereo  $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/jatinchowdhury18/ChowPhaser";
    description = "Phaser effect based loosely on the Schulte Compact Phasing 'A'";
    license = with licenses; [ bsd3 ];
    mainProgram = "ChowPhaserStereo";
    maintainers = with maintainers; [ magnetophon ];
    platforms = platforms.linux;
  };
})
