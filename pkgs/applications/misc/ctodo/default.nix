{ stdenv, cmake, fetchurl, ncurses }:

let
  version = "1.2";
in
stdenv.mkDerivation {
  name = "ctodo-${version}";

  src = fetchurl {
    url = "https://github.com/Acolarh/ctodo/archive/v${version}.tar.gz";
    sha256 = "0kjd84q8aw238z09yz9n1p732fh08vijaf8bk1xqlx544cgyfcjm";
  };

  buildInputs = [ stdenv cmake ncurses ];

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
