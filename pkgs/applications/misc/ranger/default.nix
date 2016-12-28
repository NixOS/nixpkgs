{ stdenv, fetchurl, pythonPackages, w3m, file, less }:

pythonPackages.buildPythonApplication rec {
  name = "ranger-1.8.0";

  meta = {
    description = "File manager with minimalistic curses interface";
    homepage = "http://ranger.nongnu.org/";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
  };

  src = fetchurl {
    url = "http://ranger.nongnu.org/${name}.tar.gz";
    sha256 = "14j067n1azk6vc6cxlhi5w5bsn2wcz4hypvgxc0vjl9xp5n4f0nf";
  };

  propagatedBuildInputs = [ file ];

  preConfigure = ''
    substituteInPlace ranger/ext/img_display.py \
      --replace /usr/lib/w3m ${w3m}/libexec/w3m
    substituteInPlace ranger/__init__.py \
      --replace "DEFAULT_PAGER = 'less'" "DEFAULT_PAGER = '${stdenv.lib.getBin less}/bin/less'"

    for i in ranger/config/rc.conf doc/config/rc.conf ; do
      substituteInPlace $i --replace /usr/share $out/share
    done
  '';

}
