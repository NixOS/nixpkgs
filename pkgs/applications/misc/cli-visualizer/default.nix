{ stdenv, fetchgit, fftw, ncurses, libpulseaudio }:

stdenv.mkDerivation rec {
  version = "2016-06-02";
  name = "cli-visualizer-${version}";

  src = fetchgit {
    url = "https://github.com/dpayne/cli-visualizer.git";
    rev = "bc0104eb57e7a0b3821510bc8f93cf5d1154fa8e";
    sha256 = "7b0c69a16b4854149522e2d0ec544412fb368cecba771d1e9481330ed86c8cb7";
  };

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
