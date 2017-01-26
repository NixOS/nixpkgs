{ stdenv, fetchurl, intltool, wrapGAppsHook, pkgconfig , gtk, libxml2
, enchant, gucharmap, python, gnome3
}:

stdenv.mkDerivation rec {
  name = "bluefish-2.2.9";

  src = fetchurl {
    url = "mirror://sourceforge/bluefish/${name}.tar.bz2";
    sha256 = "1l7pg6h485yj84i34jr09y8qzc1yr4ih6w5jdhmnrg156db7nwav";
  };

  nativeBuildInputs = [ intltool pkgconfig wrapGAppsHook ];
  buildInputs = [ gnome3.defaultIconTheme gtk libxml2
    enchant gucharmap python ];

  meta = with stdenv.lib; {
    description = "A powerful editor targeted towards programmers and webdevelopers";
    homepage = http://bluefish.openoffice.nl/;
    license = licenses.gpl3Plus;
    maintainers = [maintainers.vbgl];
    platforms = platforms.all;
  };
}
