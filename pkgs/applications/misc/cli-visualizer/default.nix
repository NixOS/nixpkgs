{ stdenv, fetchgit, fftw, ncurses, libpulseaudio }:

stdenv.mkDerivation rec {
  version = "2016-06-02";
  name = "cli-visualizer-${version}";

  src = fetchgit {
    url = "https://github.com/dpayne/cli-visualizer.git";
    rev = "bc0104eb57e7a0b3821510bc8f93cf5d1154fa8e";
    sha256 = "16768gyi85mkizfn874q2q9xf32knw08z27si3k5bk99492dxwzw";
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
    homepage = "https://github.com/dpayne/cli-visualizer";
    description = "CLI based audio visualizer";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.matthiasbeyer ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
