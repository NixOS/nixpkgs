{ stdenv, fetchgit, fftw, ncurses }:

stdenv.mkDerivation rec {
  version = "06-02-2016";
  name = "cli_visualizer-${version}";

  src = fetchgit {
    url = "https://github.com/dpayne/cli-visualizer.git";
    rev = "bc0104eb57e7a0b3821510bc8f93cf5d1154fa8e";
    sha256 = "7b0c69a16b4854149522e2d0ec544412fb368cecba771d1e9481330ed86c8cb7";
  };

  buildInputs = [ fftw ncurses ];

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
