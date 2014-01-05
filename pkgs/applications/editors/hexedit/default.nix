{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "hexedit-${version}";
  version = "1.2.13";

  src = fetchurl {
    url = "http://rigaux.org/${name}.src.tgz";
    sha256 = "1mwdp1ikk64cqmagnrrps5jkn3li3n47maiqh2qc1xbp1ains4ka";
  };

  buildInputs = [ ncurses ];

  meta = {
    description = "View and edit files in hexadecimal or in ASCII";
    homepage = "http://prigaux.chez.com/hexedit.html";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
