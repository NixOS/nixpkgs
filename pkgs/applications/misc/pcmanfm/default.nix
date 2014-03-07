{ stdenv, fetchurl, glib, gtk, intltool, libfm, libX11, pango, pkgconfig }:

stdenv.mkDerivation {
  name = "pcmanfm-1.2.0";
  src = fetchurl {
    url = "mirror://sourceforge/pcmanfm/pcmanfm-1.2.0.tar.xz";
    sha256 = "1cmskj7dpjgrrn89z7cc1h1nsmd6qq3bakf207ldrhrxxv3fxl2j";
  };

  buildInputs = [ glib gtk intltool libfm libX11 pango pkgconfig ];

  meta = with stdenv.lib; {
    homepage = "http://blog.lxde.org/?cat=28/";
    license = licenses.gpl2Plus;
    description = "File manager with GTK+ interface";
    maintainers = [ maintainers.ttuegel ];
    platforms = platforms.linux;
  };
}
