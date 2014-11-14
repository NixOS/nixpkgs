{ stdenv, fetchurl, glib, gtk, intltool, libfm, libX11, pango, pkgconfig }:

stdenv.mkDerivation {
  name = "pcmanfm-1.2.3";
  src = fetchurl {
    url = "mirror://sourceforge/pcmanfm/pcmanfm-1.2.3.tar.xz";
    sha256 = "1033rw5jd7nlzbcdpx3bik7347kyh1sg1gkla424gq9vqqpxia6g";
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
