{ stdenv, fetchurl, intltool, wrapGAppsHook, pkgconfig , gtk, libxml2
, enchant, gucharmap, python, gnome3
}:

stdenv.mkDerivation rec {
  name = "bluefish-2.2.12";

  src = fetchurl {
    url = "mirror://sourceforge/bluefish/${name}.tar.bz2";
    sha256 = "0slyjx4b4l612505q02crk00pjg9d5wi8gm5gxvcs0f6l9dr1y8d";
  };

  nativeBuildInputs = [ intltool pkgconfig wrapGAppsHook ];
  buildInputs = [ gnome3.adwaita-icon-theme gtk libxml2
    enchant gucharmap python ];

  meta = with stdenv.lib; {
    description = "A powerful editor targeted towards programmers and webdevelopers";
    homepage = "http://bluefish.openoffice.nl/";
    license = licenses.gpl3Plus;
    maintainers = [maintainers.vbgl];
    platforms = platforms.all;
  };
}
