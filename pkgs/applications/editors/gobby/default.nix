{ avahiSupport ? false # build support for Avahi in libinfinity
, gnomeSupport ? false # build support for Gnome(gnome-vfs)
, stdenv, fetchurl, pkgconfig
, gtkmm, gsasl, gtksourceview, libxmlxx, libinfinity, intltool
, gnome_vfs ? null}:

let
  libinf = libinfinity.override { gtkWidgets = true; inherit avahiSupport; };
  
in stdenv.mkDerivation rec {

  name = "gobby-0.4.94";
  src = fetchurl {
    url = "http://releases.0x539.de/gobby/${name}.tar.gz";
    sha256 = "b9798808447cd94178430f0fb273d0e45d0ca30ab04560e3790bac469e03bb00";
  };

  buildInputs = [ pkgconfig gtkmm gsasl gtksourceview libxmlxx libinf intltool ]
    ++ stdenv.lib.optional gnomeSupport gnome_vfs;
  
  configureFlags = ''
  '';

  meta = with stdenv.lib; {
    homepage = http://gobby.0x539.de/;
    description = "A GTK-based collaborative editor supporting multiple documents in one session and a multi-user chat";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.all;
  };
}
