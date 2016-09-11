{ avahiSupport ? false # build support for Avahi in libinfinity
, gnomeSupport ? false # build support for Gnome(gnome-vfs)
, stdenv, fetchurl, pkgconfig
, gtkmm2, gsasl, gtksourceview, libxmlxx, libinfinity, intltool
, gnome_vfs ? null}:

let
  libinf = libinfinity.override { gtkWidgets = true; inherit avahiSupport; };
  
in stdenv.mkDerivation rec {

  name = "gobby-0.5.0";
  src = fetchurl {
    url = "http://releases.0x539.de/gobby/${name}.tar.gz";
    sha256 = "165x0r668ma5blziisvbr8qig3jw9hf7i6w8r7wwvz3wsac3bswc";
  };

  buildInputs = [ pkgconfig gtkmm2 gsasl gtksourceview libxmlxx libinf intltool ]
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
