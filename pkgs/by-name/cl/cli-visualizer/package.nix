{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fftw,
  ncurses5,
  libpulseaudio,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  version = "1.8";
  pname = "cli-visualizer";

  src = fetchFromGitHub {
    owner = "dpayne";
    repo = "cli-visualizer";
    rev = "v${version}";
    sha256 = "003mbbwsz43mg3d7llphpypqa9g7rs1p1cdbqi1mbc2bfrc1gcq2";
  };

  postPatch = ''
    sed '1i#include <cmath>' -i src/Transformer/SpectrumCircleTransformer.cpp
  '';

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  buildInputs = [
    fftw
    ncurses5
    libpulseaudio
  ];

  buildFlags = [ "ENABLE_PULSE=1" ];

  postInstall = ''
    # See https://github.com/dpayne/cli-visualizer/issues/62#issuecomment-330738075
    wrapProgram $out/bin/vis --set TERM rxvt-256color
  '';

  meta = {
    homepage = "https://github.com/dpayne/cli-visualizer";
    description = "CLI based audio visualizer";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.matthiasbeyer ];
    platforms = with lib.platforms; linux;
    mainProgram = "vis";
  };
}
