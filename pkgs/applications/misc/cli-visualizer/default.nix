{ stdenv, fetchFromGitHub, fftw, ncurses, libpulseaudio }:

stdenv.mkDerivation rec {
  version = "1.5";
  name = "cli-visualizer-${version}";

  src = fetchFromGitHub {
    owner = "dpayne";
    repo = "cli-visualizer";
    rev = version;
    sha256 = "18qv4ya64qmczq94dnynrnzn7pwhmzbn14r05qcvbbwv7r8gclzs";
  };

  postPatch = ''
    sed '1i#include <cmath>' -i src/Transformer/SpectrumCircleTransformer.cpp
  '';

  buildInputs = [ fftw ncurses libpulseaudio ];

  buildFlags = [ "ENABLE_PULSE=1" ];

  installPhase = ''
    mkdir -p $out/bin
    cp build/vis $out/bin/vis
  '';

  meta = {
    homepage = https://github.com/dpayne/cli-visualizer;
    description = "CLI based audio visualizer";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.matthiasbeyer ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
