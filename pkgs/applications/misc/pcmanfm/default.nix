{ stdenv, fetchurl, glib, gtk2, intltool, libfm, libX11, pango, pkgconfig }:

stdenv.mkDerivation rec {
  name = "pcmanfm-1.2.5";
  src = fetchurl {
    url = "mirror://sourceforge/pcmanfm/${name}.tar.xz";
    sha256 = "0rxdh0dfzc84l85c54blq42gczygq8adhr3l9hqzy1dp530cm1hc";
  };

  buildInputs = [ glib gtk2 intltool libfm libX11 pango pkgconfig ];

  meta = with stdenv.lib; {
    homepage = http://blog.lxde.org/?cat=28/;
    license = licenses.gpl2Plus;
    description = "File manager with GTK+ interface";
    maintainers = [ maintainers.ttuegel ];
    platforms = platforms.linux;
  };
}
