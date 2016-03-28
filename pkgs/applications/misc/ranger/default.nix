{ stdenv, fetchurl, buildPythonApplication, python, w3m, file }:

buildPythonApplication rec {
  name = "ranger-1.7.2";

  meta = {
    description = "File manager with minimalistic curses interface";
    homepage = "http://ranger.nongnu.org/";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
  };

  src = fetchurl {
    url = "http://ranger.nongnu.org/${name}.tar.gz";
    sha256 = "0yaviybviwdvfg2a0pf2kk28g10k245499xmbpqlai7fv91f7xll";
  };

  propagatedBuildInputs = [ python.modules.curses file ];

  preConfigure = ''
    substituteInPlace ranger/ext/img_display.py \
      --replace /usr/lib/w3m ${w3m}/libexec/w3m

    for i in ranger/config/rc.conf doc/config/rc.conf ; do
      substituteInPlace $i --replace /usr/share $out/share
    done
  '';

}
