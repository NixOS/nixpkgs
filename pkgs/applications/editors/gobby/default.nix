{ avahiSupport ? false # build support for Avahi in libinfinity
, gnomeSupport ? false # build support for Gnome(gnome-vfs)
, stdenv, fetchurl, pkgconfig
, gtkmm, gsasl, gtksourceview, libxmlxx, libinfinity, intltool
, gnomevfs ? null}:

let
  libinf = libinfinity.override { gtkWidgets = true; inherit avahiSupport; };
  
in stdenv.mkDerivation rec {

  name = "gobby-0.4.93";
  src = fetchurl {
    url = "http://releases.0x539.de/gobby/${name}.tar.gz";
    sha256 = "1zk6p0kdp9vcvrr3kx0kw106ln309hd7bbsq8li1g0pcnkgrf4q4";
  };

  buildInputs = [ pkgconfig gtkmm gsasl gtksourceview libxmlxx libinf intltool ]
    ++ stdenv.lib.optional gnomeSupport gnomevfs;
  
  configureFlags = ''
  '';

  meta = with stdenv.lib; {
    homepage = http://gobby.0x539.de/;
    description = "A GTK-based collaborative editor supporting multiple documents in one session and a multi-user chat";
    license = "GPLv2+";
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.all;
  };
}