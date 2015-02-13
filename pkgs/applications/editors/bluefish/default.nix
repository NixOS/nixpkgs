{ stdenv, fetchurl, intltool, pkgconfig , gtk, libxml2
, enchant, gucharmap, python
}:

stdenv.mkDerivation rec {
  name = "bluefish-2.2.7";

  src = fetchurl {
    url = "mirror://sourceforge/bluefish/${name}.tar.bz2";
    sha256 = "1psqx3ljz13ylqs4zkaxv9lv1hgzld6904kdp0alwx99p5rlnlr3";
  };

  buildInputs = [ intltool pkgconfig gtk libxml2
    enchant gucharmap python ];

  meta = with stdenv.lib; {
    description = "A powerful editor targeted towards programmers and webdevelopers";
    homepage = http://bluefish.openoffice.nl/;
    license = licenses.gpl3Plus;
    maintainers = [maintainers.vbgl];
    platforms = platforms.all;
  };
}
