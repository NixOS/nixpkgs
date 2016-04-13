{ stdenv, fetchurl, glib, gtk, intltool, libfm, libX11, pango, pkgconfig }:

stdenv.mkDerivation rec {
  name = "pcmanfm-1.2.4";
  src = fetchurl {
    url = "mirror://sourceforge/pcmanfm/${name}.tar.xz";
    sha256 = "04z3vd9si24yi4c8calqncdpb9b6mbj4cs4f3fs86i6j05gvpk9q";
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
