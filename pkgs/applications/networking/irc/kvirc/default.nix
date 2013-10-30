{ stdenv, fetchurl, cmake, qt4, perl, gettext, kdelibs, openssl, zlib}:

let
  pn = "kvirc";
  v = "4.2.0";
in

stdenv.mkDerivation {
  name = "${pn}-${v}";

  src = fetchurl {
    url = "ftp://ftp.kvirc.de/pub/${pn}/${v}/source/${pn}-${v}.tar.bz2";
    sha256 = "9a547d52d804e39c9635c8dc58bccaf4d34341ef16a9a652a5eb5568d4d762cb";
  };

  buildInputs = [ cmake qt4 perl gettext kdelibs openssl zlib ];

  meta = with stdenv.lib; {
    description = "Graphic IRC client with Qt";
    license = licences.gpl3;
    homepage = http://www.kvirc.net/;
    platforms   = platforms.linux;
  };
}
