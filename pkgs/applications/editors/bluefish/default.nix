{stdenv, fetchurl, intltool, pkgconfig , gtk, libxml2
, enchant, gucharmap, python
}:

stdenv.mkDerivation rec {
  name = "bluefish-2.2.6";

  src = fetchurl {
    url = "mirror://sourceforge/bluefish/${name}.tar.bz2";
    sha256 = "05j2mv6s2llf2pxknddhk8fzbghr7yff58xhkxy2icky64n8khjl";
  };

  buildInputs = [intltool pkgconfig gtk libxml2
    enchant gucharmap python];

  meta = with stdenv.lib; {
    description = "A powerful editor targeted towards programmers and webdevelopers";
    homepage = http://bluefish.openoffice.nl/;
    license = licenses.gpl3Plus;
    maintainers = [maintainers.vbgl];
    platforms = platforms.all;
  };
}
