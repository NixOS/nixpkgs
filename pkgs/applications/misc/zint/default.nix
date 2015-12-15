{ stdenv, fetchgit, libpng, zlib, cmake, qt4 }:

let
  version = "2.4.2";
in
stdenv.mkDerivation {
  name = "zint-${version}";

  src = fetchgit {
    url = "https://github.com/et4te/zint/";
    sha256 = "1ki5148iblnma8kf64pn4h6llz2fgqw44zfg99xhpic06j77ip03";
  };

  buildInputs = [ cmake stdenv libpng zlib qt4 ];

  configurePhase = ''
    cmake -DCMAKE_INSTALL_PREFIX=$out
  '';

  meta = {
    homepage = "https://zint.github.io";
    description = "A barcode generator library written in C.";
  };
}
