{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "hexedit-${version}";
  version = "1.2.12";

  src = fetchurl {
    url = "http://rigaux.org/${name}.src.tgz";
    sha256 = "bcffbf3d128516cc4e1da64485866fbb5f62754f2af8327e7a527855186ba10f";
  };

  buildInputs = [ ncurses ];

  meta = {
    description = "View and edit files in hexadecimal or in ASCII";
    homepage = "http://prigaux.chez.com/hexedit.html";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
