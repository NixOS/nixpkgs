{ stdenv, cmake, fetchgit, ncurses }:

let
  version = "1.1";
in
stdenv.mkDerivation {
  name = "ctodo-${version}";

  src = fetchgit {
    url = "https://github.com/Acolarh/ctodo.git";
    rev = "de478f5028a1b167bfdb6dd4160d83d9ef7db839";
    sha256 = "3a43a6237e8fe5b37ca7d5abc88c20158f2cff1f8b98762c404e6f24d4b7993e";
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
  };
}
