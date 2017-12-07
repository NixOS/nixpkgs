{ stdenv, cmake, fetchurl, ncurses, readline }:

stdenv.mkDerivation rec {
  name = "ctodo-${version}";
  version = "1.3";

  src = fetchurl {
    url = "https://github.com/Acolarh/ctodo/archive/v${version}.tar.gz";
    sha256 = "1k3raigcgpwa0h8zkv5x9rycnn2iqkb9qim4q9ydqy9wbv3m32jb";
  };

  buildInputs = [ stdenv cmake ncurses readline ];

  configurePhase = ''
    cmake -DCMAKE_INSTALL_PREFIX=$out .
  '';

  meta = {
    homepage = http://ctodo.apakoh.dk/;
    description = "A simple ncurses-based task list manager";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.matthiasbeyer ];
    platforms = stdenv.lib.platforms.linux;
  };
}
