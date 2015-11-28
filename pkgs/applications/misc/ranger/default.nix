{ stdenv, fetchurl, buildPythonPackage, python, w3m }:

buildPythonPackage rec {
  name = "ranger-1.7.1";

  meta = {
    description = "File manager with minimalistic curses interface";
    homepage = "http://ranger.nongnu.org/";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "http://ranger.nongnu.org/${name}.tar.gz";
    sha256 = "11nznx2lqv884q9d2if63101prgnjlnan8pcwy550hji2qsn3c7q";
  };

  propagatedBuildInputs = with python.modules; [ curses ];

  preConfigure = ''
    substituteInPlace ranger/ext/img_display.py \
      --replace /usr/lib/w3m ${w3m}/libexec/w3m

    for i in ranger/config/rc.conf doc/config/rc.conf ; do
      substituteInPlace $i --replace /usr/share $out/share
    done
  '';

}
