{ stdenv, fetchurl, glib, intltool, libfm, libX11, pango, pkgconfig
, wrapGAppsHook, gnome3, withGtk3 ? true, gtk2, gtk3 }:

let
  libfm' = libfm.override { inherit withGtk3; };
  gtk = if withGtk3 then gtk3 else gtk2;
  inherit (stdenv.lib) optional;
in
stdenv.mkDerivation rec {
  name = "pcmanfm-1.3.0";
  src = fetchurl {
    url = "mirror://sourceforge/pcmanfm/${name}.tar.xz";
    sha256 = "1ywgfyklms5hqkapsbjps4kyx20ac0d1qk16ww74yagkyfdkwsas";
  };

  buildInputs = [ glib gtk libfm' libX11 pango gnome3.defaultIconTheme ];
  nativeBuildInputs = [ pkgconfig wrapGAppsHook intltool ];

  configureFlags = optional withGtk3 "--with-gtk=3";

  meta = with stdenv.lib; {
    homepage = http://blog.lxde.org/?cat=28/;
    license = licenses.gpl2Plus;
    description = "File manager with GTK+ interface";
    maintainers = [ maintainers.ttuegel ];
    platforms = platforms.linux;
  };
}
