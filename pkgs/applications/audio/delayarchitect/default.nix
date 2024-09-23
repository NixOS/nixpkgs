{ lib, stdenv, fetchFromGitHub, libGL, libX11, libXext, libXrandr, libXinerama, libXcursor, freetype, alsa-lib, cmake, pkg-config, gcc-unwrapped }:

stdenv.mkDerivation rec {
  pname = "delayarchitect";
  version = "unstable-2022-01-16";

  src = fetchFromGitHub {
    owner = "jpcima";
    repo = "DelayArchitect";
    rev = "5abf4dfb7f92ba604d591a2c388d2d69a9055fe3";
    hash = "sha256-LoK2pYPLzyJF7tDJPRYer6gKHNYzvFvX/d99TuOPECo=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    libGL libX11 libXext libXrandr libXinerama libXcursor freetype alsa-lib
  ];

  cmakeFlags = [
    "-DCMAKE_AR=${gcc-unwrapped}/bin/gcc-ar"
    "-DCMAKE_RANLIB=${gcc-unwrapped}/bin/gcc-ranlib"
    "-DCMAKE_NM=${gcc-unwrapped}/bin/gcc-nm"
  ];

  installPhase = ''
    mkdir -p $out/lib/vst3
    cd DelayArchitect_artefacts/Release
    cp -r VST3/Delay\ Architect.vst3 $out/lib/vst3
  '';

  meta = with lib; {
    homepage = "https://github.com/jpcima/DelayArchitect";
    description = "Visual, musical editor for delay effects";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.all;
    license = licenses.gpl3Plus;
  };
}
