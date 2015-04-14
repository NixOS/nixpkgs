{ stdenv, buildPythonPackage, python, fetchurl }:

buildPythonPackage rec {
  name = "ranger-1.7.0";

  meta = {
    description = "File manager with minimalistic curses interface";
    homepage = "http://ranger.nongnu.org/";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "http://ranger.nongnu.org/${name}.tar.gz";
    sha256 = "066lp1k2zcz2lnww2aj0m3fgn9g5ms67kxgclhgq66pxkjwgc4kx";
  };

  propagatedBuildInputs = with python.modules; [ curses ];
}
