{ stdenv, fetchurl, intltool, wrapGAppsHook, pkgconfig , gtk, libxml2
, enchant, gucharmap, python, gnome3
}:

stdenv.mkDerivation rec {
  name = "bluefish-2.2.10";

  src = fetchurl {
    url = "mirror://sourceforge/bluefish/${name}.tar.bz2";
    sha256 = "1ciygj79q6i3ga5x1j8aivc05nh6rhhnm7hrq8q8xd9vd4ms3v5g";
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
