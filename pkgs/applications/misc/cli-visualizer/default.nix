{ stdenv, fetchFromGitHub, fftw, ncurses5, libpulseaudio, makeWrapper }:

stdenv.mkDerivation rec {
  version = "1.8";
  name = "cli-visualizer-${version}";

  src = fetchFromGitHub {
    owner = "dpayne";
    repo = "cli-visualizer";
    rev = "v${version}";
    sha256 = "003mbbwsz43mg3d7llphpypqa9g7rs1p1cdbqi1mbc2bfrc1gcq2";
  };

  postPatch = ''
    sed '1i#include <cmath>' -i src/Transformer/SpectrumCircleTransformer.cpp
  '';

  buildInputs = [ fftw ncurses5 libpulseaudio makeWrapper ];

  buildFlags = [ "ENABLE_PULSE=1" ];

  installPhase = ''
    mkdir -p $out/bin
    cp build/vis $out/bin/vis
    # See https://github.com/dpayne/cli-visualizer/issues/62#issuecomment-330738075
    wrapProgram $out/bin/vis --set TERM rxvt-256color
  '';

  meta = {
    homepage = https://github.com/dpayne/cli-visualizer;
    description = "CLI based audio visualizer";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.matthiasbeyer ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
