{ alsa-lib, at-spi2-core, cmake, curl, dbus, libepoxy, fetchFromGitHub, freeglut
, freetype, gcc-unwrapped, gtk3, lib, libGL, libXcursor, libXdmcp, libXext
, libXinerama, libXrandr, libXtst, libdatrie, libjack2, libpsl, libselinux
, libsepol, libsysprof-capture, libthai, libxkbcommon, lv2, pcre, pkg-config
, python3, sqlite, stdenv }:

stdenv.mkDerivation rec {
  pname = "CHOWTapeModel";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "jatinchowdhury18";
    repo = "AnalogTapeModel";
    rev = "v${version}";
    sha256 = "sha256-iuT7OBRBtMkjcTHayCcne1mNqkcxzKnEYl62n65V7Z4=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config cmake ];

  buildInputs = [
    alsa-lib
    at-spi2-core
    curl
    dbus
    libepoxy
    freeglut
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
    lv2
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

  postPatch = "cd Plugin";

  installPhase = ''
    mkdir -p $out/lib/lv2 $out/lib/vst3 $out/bin $out/share/doc/CHOWTapeModel/
    cd CHOWTapeModel_artefacts/Release
    cp libCHOWTapeModel_SharedCode.a  $out/lib
    cp -r LV2/CHOWTapeModel.lv2 $out/lib/lv2
    cp -r VST3/CHOWTapeModel.vst3 $out/lib/vst3
    cp Standalone/CHOWTapeModel  $out/bin
    cp ../../../../Manual/ChowTapeManual.pdf $out/share/doc/CHOWTapeModel/
  '';

  meta = with lib; {
    homepage = "https://github.com/jatinchowdhury18/AnalogTapeModel";
    description =
      "Physical modelling signal processing for analog tape recording. LV2, VST3 and standalone";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ magnetophon ];
    platforms = platforms.linux;
    # error: 'vvtanh' was not declared in this scope; did you mean 'tanh'?
    # error: no matching function for call to 'juce::dsp::SIMDRegister<double>::SIMDRegister(xsimd::simd_batch_traits<xsimd::batch<double, 2> >::batch_bool_type)'
    broken = stdenv.isAarch64; # since 2021-12-27 on hydra (update to 2.10): https://hydra.nixos.org/build/162558991
  };
}
