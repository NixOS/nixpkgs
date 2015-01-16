{ stdenv, cmake, fetchurl, ncurses }:

let
  version = "1.1";
in
stdenv.mkDerivation {
  name = "ctodo-${version}";

  src = fetchurl {
    url = "https://github.com/Acolarh/ctodo/archive/v1.1.tar.gz";
    sha256 = "1sv5p1b08pp73qshakz4qy4pjglxz2pvx2cjfx52i3532hd3xcaf";
  };

  buildInputs = [ stdenv cmake ncurses ];

  configurePhase = ''
    cmake -DCMAKE_INSTALL_PREFIX=$out .
  '';

  meta = {
    homepage = "http://ctodo.apakoh.dk/";
    description = "A simple ncurses-based task list manager.";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.matthiasbeyer ];
    platforms = stdenv.lib.platforms.linux;
  };
}
