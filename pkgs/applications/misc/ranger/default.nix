{ stdenv, buildPythonPackage, python, fetchurl }:

buildPythonPackage {
  name = "ranger-1.6.1";

  meta = {
    description = "File manager with minimalistic curses interface";
    homepage = "http://ranger.nongnu.org/";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "http://ranger.nongnu.org/ranger-1.6.1.tar.gz";
    sha256 = "0pnvfwk2a1p35246fihm3fsr1m7r2njirbxm28ba276psajk1cnc";
  };

  doCheck = false;

  propagatedBuildInputs = with python.modules; [ curses ];
}
