{ lib, stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  pname = "hexedit";
  version = "1.2.13";

  src = fetchurl {
    url = "http://rigaux.org/${pname}-${version}.src.tgz";
    sha256 = "1mwdp1ikk64cqmagnrrps5jkn3li3n47maiqh2qc1xbp1ains4ka";
  };

  buildInputs = [ ncurses ];

  meta = {
    description = "View and edit files in hexadecimal or in ASCII";
    homepage = "http://prigaux.chez.com/hexedit.html";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
}
